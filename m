Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364AbaGETGj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 15:06:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35997 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863AbaGETGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 15:06:38 -0400
Date: Sat, 5 Jul 2014 12:10:58 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.14 00/59] 3.14.11-stable review
Message-ID: <20140705191058.GB30203@kroah.com>
References: <20140704221539.544876024@linuxfoundation.org>
 <53B79106.2070102@roeck-us.net>
 <87zjgoffxi.wl%satoru.takeuchi@gmail.com>
 <87wqbsf9fj.wl%satoru.takeuchi@gmail.com>
 <s5htx6wrmjs.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5htx6wrmjs.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2014 at 02:56:55PM +0200, Takashi Iwai wrote:
> At Sat, 05 Jul 2014 18:21:04 +0900,
> Satoru Takeuchi wrote:
> > 
> > Hi Greg,
> > 
> > Add Takashi Iwai to this thread.
> > 
> > At Sat, 05 Jul 2014 16:00:41 +0900,
> > Satoru Takeuchi wrote:
> > > 
> > > At Fri, 04 Jul 2014 22:45:42 -0700,
> > > Guenter Roeck wrote:
> > > > 
> > > > On 07/04/2014 03:18 PM, Greg Kroah-Hartman wrote:
> > > > > This is the start of the stable review cycle for the 3.14.11 release.
> > > > > There are 59 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > > 
> > > > > Responses should be made by Sun Jul  6 22:15:27 UTC 2014.
> > > > > Anything received after that time might be too late.
> > > > > 
> > > > 
> > > > Build results:
> > > > 	total: 144 pass: 130 skipped: 4 fail: 10
> > > > Failed builds:
> > > > 	alpha:allmodconfig
> > > > 	i386:allyesconfig
> > > > 	i386:allmodconfig
> > > > 	powerpc:allmodconfig (binutils 2.23)
> > > > 	powerpc:allmodconfig (binutils 2.24)
> > > > 	sparc64:allmodconfig
> > > > 	unicore32:defconfig
> > > > 	x86_64:allyesconfig
> > > > 	x86_64:allmodconfig
> > > > 	xtensa:allmodconfig
> > > > 
> > > > Qemu test for x86 failed.
> > > > 
> > > > Build error is the same as seen with 3.14.
> > > > 
> > > > sound/pci/hda/patch_sigmatel.c: In function 'stac92hd95_fixup_hp_led':
> > > > sound/pci/hda/patch_sigmatel.c:4143:3: error: implicit declaration of function 'codec_dbg' [-Werror=implicit-function-declaration]
> > > 
> > > This kernel failed to build with the following error. Probably the root
> > > cause is the same as Guenter. I'm now bisecting to find the problematic
> > > patch...
> > 
> > The following patch caused the boot failure of both this kernel and 3.10.47-rc1.
> > 
> > alsa-hda-adjust-speaker-hpf-and-add-led-support-for-hp-spectre-13.patch:
> > ===============================================================================
> > From 8b3dfdaf0c25a584cb31d04d2574115cf2d422ab Mon Sep 17 00:00:00 2001
> > From: Takashi Iwai <tiwai@suse.de>
> > Date: Tue, 24 Jun 2014 13:55:25 +0200
> > Subject: ALSA: hda - Adjust speaker HPF and add LED support for HP Spectre 13
> > 
> > From: Takashi Iwai <tiwai@suse.de>
> > 
> > commit 8b3dfdaf0c25a584cb31d04d2574115cf2d422ab upstream.
> > 
> > HP Spectre 13 has the IDT 92HD95 codec, and BIOS seems to set the
> > default high-pass filter in some "safer" range, which results in the
> > very soft tone from the built-in speakers in contrast to Windows.
> > Also, the mute LED control is missing, since 92HD95 codec still has no
> > HP-specific fixups for GPIO setups.
> > 
> > This patch adds these missing features: the HPF is adjusted by the
> > vendor-specific verb, and the LED is set up from a DMI string (but
> > with the default polarity = 0 assumption due to the incomplete BIOS on
> > the given machine).
> > 
> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=74841
> > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ...
> > ===============================================================================
> > 
> > This patch uses codec_dbg(), however, this macro is intrdocuded by the
> > following patch and it's not applied to these stable-tree yet.
> > 
> > ===============================================================================
> > ommit 4e76a8833fac8dc1735aa5be7d1b3c92c65e209e
> > Author: Takashi Iwai <tiwai@suse.de>
> > Date:   Tue Feb 25 12:21:03 2014 +0100
> > 
> >     ALSA: hda - Replace with standard printk
> > 
> >     Use dev_err() and co for messages from HD-audio controller and codec
> >     drivers.  The codec drivers are mostly bound with codec objects, so
> >     some helper macros, codec_err(), codec_info(), etc, are provided.
> >     They merely wrap the corresponding dev_xxx().
> > 
> >     There are a few places still calling snd_printk() and its variants
> >     as they are called without the codec or device context.
> > 
> >     Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > ...
> > ===============================================================================
> > 
> > Unfortunately I failed to apply this patch to 3.14.11-rc1 with the following
> > error log.
> > 
> > ===============================================================================
> > $ git apply ~/src/test-linux-stable/extra_patch.txt 
> > error: patch failed: sound/pci/hda/hda_intel.c:897
> > error: sound/pci/hda/hda_intel.c: patch does not apply
> > error: sound/pci/hda/hda_sysfs.c: No such file or directory
> > ===============================================================================
> > 
> > I'm not sure whether we should drop this patch or should apply extra patches
> > to remove this build failure. Any idea?
> 
> Just drop the patch from 3.14 and earlier stable kernels. If anyone
> wants to use the laptop, they should use 3.15.x or later kernel.
> 
> The second patch cannot be used for 3.14 at all because it requires
> the other infrastructure change that was introduced in 3.15.
> Alternatively, you can replace codec_dbg() with pr_debug() and drop
> the first argument.

I've now dropped this patch from the 3.10 and 3.14 patch queues, sorry
for the build failures, I should have caught these before I put out the
series.

greg k-h
