Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab3C2N1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 09:27:47 -0400
Received: from mail.wdtv.com ([66.118.69.84]:49784 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755485Ab3C2N1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 09:27:45 -0400
From: Gene Heskett <gheskett@wdtv.com>
To: ubuntu-users@lists.ubuntu.com
Subject: Re: 3.8.3 build error, compiler segfault
Date: Fri, 29 Mar 2013 09:27:43 -0400
References: <201303231334.54169.gheskett@wdtv.com> <104966318.mxHzboO7mH@p5915> <CAOdo=SwVaBKx2WMmB_t2f47hSNHtH_2mufFUuTYM0gWaXF4wgw@mail.gmail.com>
In-Reply-To: <CAOdo=SwVaBKx2WMmB_t2f47hSNHtH_2mufFUuTYM0gWaXF4wgw@mail.gmail.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201303290927.43394.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 March 2013 09:08:27 Tom H did opine:

CCing the lkml too.

> On Thu, Mar 28, 2013 at 10:49 AM, Nils Kassube <kassube@gmx.net> wrote:
> > I don't know of a particilar tool to extract that info. I can't tell
> > you for your -rtai kernel but the standard Ubuntu kernels come with a
> > file /boot/config-$(uname -r) which is the .config from the kernel
> > build. There you could search for '=y', but it would list more than
> > only parts which can be compiled either as module or built-in. I
> > checked the contents of the initrd and it seems the file /etc/modules
> > isn't included there. Obviously it is run later in the boot sequence,
> > not from the initrd. Sorry for that misleading suggestion.
> >
> >...
> >
> > While it looks right, I don't think it will help because the contents
> > of /etc/modules doesn't seem to be included in the initrd anyway (see
> > above).
> 
> /etc/initramfs-tools/modules

And that brings up a chicken/egg problem, as in if it can't access that 
UUID containing /etc/modules, how does it read it to find out its supposed 
to do early early loads of sata_nv, and possibly i2c_nforce even if they 
are in the generated initrd?

Either way I'm screwed.

When I installed 10.04-4 LTS, it had no complaints about my telling it to 
format / as ext4.  But now the newer kernels seem to have thrown away that 
capability by some sort of tom-foolery.

To bring the lkml up to speed on this, it seems that I can set 
CONFIG_SATA_NV=y in the .config file for a later kernel all I want, but 
then touching that file with either a 'make menuconfig' or a 'make xconfig' 
automatically nukes it, so I'm building kernels here that can't find the 
UUID of the / partition formatted as ext4, about 5 secs into the boot.  
Reset and go back to the only kernel I have that boots, 2.6.32-122.rtai.

Thanks to anyone who has a fix.  Perhaps an option passed to make I can put 
in my makeit script to build SATA_NV as part of vmlinuz anyway?  I'm not 
familiar enough with makefile arguments to have a clue what that syntax 
might look like. :(

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
My web page: <http://coyoteden.dyndns-free.com:85/gene> is up!
My views 
<http://www.armchairpatriot.com/What%20Has%20America%20Become.shtml>
I can't understand why a person will take a year or two to write a
novel when he can easily buy one for a few dollars.
		-- Fred Allen
I was taught to respect my elders, but its getting 
harder and harder to find any...
