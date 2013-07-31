Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab3GaKsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 06:48:19 -0400
Received: from ns.iliad.fr ([212.27.33.1]:56602 "EHLO ns.iliad.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755524Ab3GaKsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 06:48:18 -0400
X-Greylist: delayed 638 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Jul 2013 06:48:17 EDT
Message-ID: <1375267057.20042.52.camel@sakura.staff.proxad.net>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
From: Maxime Bizon <mbizon@freebox.fr>
Reply-To: mbizon@freebox.fr
To: Tomasz Figa <tomasz.figa@gmail.com>
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
Date: Wed, 31 Jul 2013 12:37:37 +0200
In-Reply-To: <1441731.8CGUI1tUxh@flatron>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
	 <51F39FD8.6080808@broadcom.com> <20130727183059.GD4813@netboy>
	 <1441731.8CGUI1tUxh@flatron>
Organization: Freebox
Content-Type: text/plain; charset="ANSI_X3.4-1968"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2013-07-27 at 11:51 -0700, Tomasz Figa wrote:

> Well, it depends on how we use the DT. There are (at least) two possible 
> usage scenarios:
> 
>  a) using DT as direct replacement for board files - this means that you 
>     are free to say that DTSes are strictly coupled with kernel version 
>     and you are free to modify the bindings - see the analogy to board 
>     files, where you could modify the platform data structures and could 
>     not directly copy board file from one kernel version to another,

I'm shocked to see this as a possible option.

Board files are C code anyone has the skill to edit/understand/refactor.
Moving to DT and keep them in tree tightly coupled with the kernel
version just adds another layer of indirection for *no purpose*.

The fact that we loose compiler syntax/type checking (as highlighted
somewhere else in this thread) even looks like a regression.


>  b) using DT as an ABI - this is the original way, i.e. define stable 
>     bindings and make sure that anu DTB built for older kernel will
> work, with equal or greater set of functionality on newer kernels.
> 
Linus started the whole thing some years ago by refusing to pull ARM
tree [1]. Reread his post, what he wants is clearly b).

Going a) does not solve any problem. You are just moving churn to
somewhere else. We had board files churn, then defconfigs churn, DTS
files (and associated drivers) will be next.

DT is self inflicted pain. It has to be for the greater good.

Going b) *might* allow what some people here dream about, a kernel free
of hardware knowledge. A new board could boot a kernel compiled before
it was even designed.

Now since I do "embedded" stuff everyday, I don't think b) can apply to
the whole ARM world. There is just to much hardware peculiarity.


[1] https://lkml.org/lkml/2011/3/30/525

-- 
Maxime


