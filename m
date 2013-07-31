Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152Ab3GaK76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 06:59:58 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:64150 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab3GaK75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 06:59:57 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: mbizon@freebox.fr
Cc: Richard Cochran <richardcochran@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Olof Johansson <olof@lixom.net>, Mark Brown <broonie@kernel.org>,
        Arend van Spriel <arend@broadcom.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have people interested in device tree janitoring / cleanup?]
Date: Wed, 31 Jul 2013 12:59:59 +0200
Message-ID: <1479410.BSGDrOcRvP@thinkpad>
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1375267057.20042.52.camel@sakura.staff.proxad.net>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com> <1441731.8CGUI1tUxh@flatron> <1375267057.20042.52.camel@sakura.staff.proxad.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 of July 2013 12:37:37 Maxime Bizon wrote:
> On Sat, 2013-07-27 at 11:51 -0700, Tomasz Figa wrote:
> > Well, it depends on how we use the DT. There are (at least) two possible
> > 
> > usage scenarios:
> >  a) using DT as direct replacement for board files - this means that you
> >  
> >     are free to say that DTSes are strictly coupled with kernel version
> >     and you are free to modify the bindings - see the analogy to board
> >     files, where you could modify the platform data structures and could
> >     not directly copy board file from one kernel version to another,
> 
> I'm shocked to see this as a possible option.
> 
> Board files are C code anyone has the skill to edit/understand/refactor.
> Moving to DT and keep them in tree tightly coupled with the kernel
> version just adds another layer of indirection for *no purpose*.

Well, I agree that it's not the most fortunate scenario, but it is not that 
bad as it might seem. It still has the benefit of separating hardware data 
(including board-specific data) from kernel code and has all the benefits of DT, 
e.g. easy way to specify relations between devices (phandles), no need to 
manually register any resources, platform data or platform devices, in other 
words, when describing hardware you just care about the hardware, not how the 
kernel works.

> The fact that we loose compiler syntax/type checking (as highlighted
> somewhere else in this thread) even looks like a regression.

Syntax checking is already there. We don't have semantic checking yet, but we 
are working on this.

> >  b) using DT as an ABI - this is the original way, i.e. define stable
> >  
> >     bindings and make sure that anu DTB built for older kernel will
> > 
> > work, with equal or greater set of functionality on newer kernels.
> 
> Linus started the whole thing some years ago by refusing to pull ARM
> tree [1]. Reread his post, what he wants is clearly b).
> 
> Going a) does not solve any problem. You are just moving churn to
> somewhere else. We had board files churn, then defconfigs churn, DTS
> files (and associated drivers) will be next.
> 
> DT is self inflicted pain. It has to be for the greater good.

It has several benefits over board files that I mentioned above, possible 
without fully separating them from kernel tree.

> Going b) *might* allow what some people here dream about, a kernel free
> of hardware knowledge. A new board could boot a kernel compiled before
> it was even designed.

This is very unlikely to happen. You can already see problems with defining 
bindings for existing hardware and what to say about hardware that is not even 
designed yet? Unless all the board uses is a set of already supported 
components, that have bindings defined and drivers merged, you would still need 
to provide remaining drivers and bindings for them.

> Now since I do "embedded" stuff everyday, I don't think b) can apply to
> the whole ARM world. There is just to much hardware peculiarity.

That's why I think we need a hybrid solution. Staging bindings could use a) 
and those stable one would use b). Staging bindings would be fixed over time if 
needed and if they turn out to be fine, they can be stabilized and move to b).

So basically, you can get all the stable functionality with one DTB on any 
kernel released after the functionality got stable, but during development of 
some functionality you might need to change the DTB to test the development.

Best regards,
Tomasz
 
> [1] https://lkml.org/lkml/2011/3/30/525
