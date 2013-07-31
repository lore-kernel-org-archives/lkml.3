Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760785Ab3GaUAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 16:00:36 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37273 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756796Ab3GaUAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 16:00:35 -0400
Date: Wed, 31 Jul 2013 22:00:17 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: mbizon@freebox.fr, Mark Rutland <mark.rutland@arm.com>,
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
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
Message-ID: <20130731200017.GC8027@netboy>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <1999586.84BnWE5EUh@thinkpad>
 <20130731191209.GA8027@netboy>
 <1409617.9untvfnOTJ@flatron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409617.9untvfnOTJ@flatron>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 09:29:35PM +0200, Tomasz Figa wrote:
> 
> I showed you two example solutions that could handle this use case without 
> stable binding ABI, just to prove that b) is not the only option (even if 
> it's the best one, which I continue to agree on, don't get me wrong).

You only showed *one* solution (b) that satisfies the use case. The
use case was:

   User acquires a machine running ARM Linux version 3.x, with u-boot
   and dtb in a read only flash partition. The board boots and works just
                ^^^^^^^^^^^^^^^^^^^^^^^^^
   fine. However, for his application, the user requires a new kernel
   feature that appeared in version 3.y where y > x. He compiles the new
   kernel, and it also works.

But you suggested:

 a) using DT as direct replacement for board files - this means that you
    are free to say that DTSes are strictly coupled with kernel version
    and you are free to modify the bindings - see the analogy to board
    files, where you could modify the platform data structures and could
    not directly copy board file from one kernel version to another,

In the use case, the kernel is upgraded, but not the DTB. So this
solution makes no sense.

> I also added that the use case is not fully valid,

The use case *is* valid.  I am not inventing this just to be a pain.
There are plenty of people unable or unwilling to upgrade their boot
loader or DTB.  You can say that you won't support it, but it is a use
case from actual real life.

> because you can't 
> magically define bindings for all future hardware, which means you can't 
> support the hardware using a DTB made before stable bindings for that 
> hardware have ever been introduced.

Surely it is possible to develop and release a stable kernel and DT
ABI for a given hardware? Once this is present, it is reasonable for
users to expect forward compatibility from the DT system.
 
> With all of this, I agreed that a DTB made for kernel 3.x, when used with 
> kernel 3.y (y > x) should provide the same or greater feature set than 
> used with kernel 3.x, in other words, this should cause no regressions. 
> Still, for new features, you will likely need to update the DTB.

Yes, that is the idea.

> So, again, to summarize, my view on this is as follows:
>  - there is a list of best practices for binding design and existing 
>    stable bindings that can be used to help for designing new bindings,
>  - new bindings go through review process,
>  - after positive review, such bindings gets staging status, i.e. they are 
>    marked as something that could change,
>  - after some period of time (we need to define this precisely) they get 
>    frozen and can't be changed in a way that breaks compatibility any
>    more. In other words, they become ABI.
> 
> What do you think?

Sounds okay to me, but why bother with this marking business? Why not
just have staging or development trees like every other subsystem?

Thanks,
Richard

