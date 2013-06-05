Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab3FEWLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:11:39 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:54352 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757996Ab3FEWLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 18:11:35 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Luke Kenneth Casson Leighton <lkcl@lkcl.net>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        debian-release@lists.debian.org, debian-kernel@lists.debian.org
Subject: Re: getting allwinner SoC support upstream (was Re: Uploading linux (3.9.4-1))
Date: Thu, 06 Jun 2013 00:11:30 +0200
Message-ID: <3619282.JgdgeGHudI@flatron>
User-Agent: KMail/4.10.4 (Linux/3.9.4-gentoo; KDE/4.10.4; x86_64; ; )
In-Reply-To: <CAKON4OyyRF4Z46RyJFDWUwo4L52Z8bgSH0CzDr2gDerw4iDwcw@mail.gmail.com>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com> <CAKON4OyyRF4Z46RyJFDWUwo4L52Z8bgSH0CzDr2gDerw4iDwcw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 of June 2013 16:48:27 jonsmirl@gmail.com wrote:
> On Wed, Jun 5, 2013 at 3:46 PM, Luke Kenneth Casson Leighton
> 
> <lkcl@lkcl.net> wrote:
> > On Fri, May 31, 2013 at 3:52 AM, Ben Hutchings <ben@decadent.org.uk> 
wrote:
> > > The 3.8.y branch is over, so I think we have to move to 3.9, ready
> > > or
> > > not.  I merged the work in progress from trunk to sid and am going
> > > through the config changes at the moment.
> > > 
> > > I'm rather disappointed that nothing at all has been committed by
> > > ARM
> > > porters to either branch in the last month.
> >  
> >  *sigh* i didn't want to leave this as it stood, ben, purely for the
> > 
> > reason that i don't want to see you discouraged!  but, i also had to
> > think a bit about what potentially to say.
> > 
> >  the one SoC family that's going to become increasingly important to
> > 
> > have both upstream and in debian is support for allwinner's
> > processors.  with 40% world-wide tablet market share [*0], they must
> > be doing something right, and it's basically getting a staggering
> > price-performance value as well as having a set of interfaces and
> > level of integration that is really second to none.
> > 
> >  to begin to describe the problem in getting allwinner soc source code
> > 
> > upstream is this: not only do we have the usual "let's get it out the
> > door as fast as possible" learning curve of a very young, very new and
> > bewilderingly-successful fabless SoC company, but we also have a
> > completely new type of very successful and comprehensive
> > device-tree-like dynamic configuration system to deal with, which
> > allwinner have called "fex" [*1].
> > 
> >  basically at the time when device-tree was being thought of,
> > 
> > allwinner needed something that they could *right then* - not waiting
> > for developers to finish device-tree - they needed to be able to
> > reconfigure their customer's kernels *without* needing a recompile.
> > so they invented the script.fex system, which is a simple config.ini
> > file-format, compile it to binary, and get the bootloader to upload it
> > to memory and read it.
> 
> Why don't you try converting the sunxi code over to device tree? I
> don't think it will be as hard as you may think it is. Start off by
> mapping the existing fex syntax into a DTS file. Send your DTS file to
> devicetree-discuss to get help with the correct syntax. Once this DTS
> template is constructed you can write a program to convert any fex
> file into it.
> 
> Now boot with this DTB; that will get all of the existing info into
> the kernel's internal FDT.  Then start converting your drivers over to
> use the of_ support for accessing the FDT. You've already done all of
> the hard work in making the drivers configurable at boot. As a
> transition tool allow the kernel to boot with both fex and DT untill
> you get all of the drivers converted.
> 
> BTW, device tree has been in the kernel since 2007 (or earlier).
> About two years ago the ARM community decided to switch all new
> development onto it in order to stop the proliferation of
> platform/machine files. I believe the rule about no new non-DT ARM
> platforms has been in place for over eighteen months.

Well, it not only has been in the kernel, but has been extensively used 
for PowerPC. Not even saying that the idea started even earlier, 
originating from OpenFirmware.

Allwinner has just reinvented a wheel, without even considering the fact 
that it has been already invented. This is actually not so uncommon plot, 
because for such companies it is often easier to develop (or hack up) a 
completely new solution without any supervision, than to extend an 
existing solution that would need cooperation with community and (whoaa) 
being compliant with open source policy.

IMHO this is completely wrong and can't be justified. Not even saying 
about adopting such solution now that we already have a standard and 
widely accepted one, which they could have used as well.

Best regards,
Tomasz

