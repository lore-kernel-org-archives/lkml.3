Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaBMP0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 10:26:50 -0500
Received: from mail.wdtv.com ([66.118.69.84]:56417 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbaBMP0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 10:26:49 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: i386_defconfig for 3.13.2?
Date: Thu, 13 Feb 2014 10:26:46 -0500
Cc: linux-kernel@vger.kernel.org, ubuntu-users@lists.ubuntu.com
References: <201402121408.12535.gheskett@wdtv.com> <52FC2531.9000304@infradead.org> <201402131006.50062.gheskett@wdtv.com>
In-Reply-To: <201402131006.50062.gheskett@wdtv.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201402131026.46472.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 February 2014, Gene Heskett wrote:
>On Wednesday 12 February 2014, Randy Dunlap wrote:
>>On 02/12/2014 11:08 AM, Gene Heskett wrote:
>>> Greetings, not making any progress on newer kernel builds yet.
>>> 
>>> So I unpacked 3.13.2 this morning and copied its
>>> arch/x86/i386_defconfig to .config.
>>> 
>>> Ran make oldconfig, then 3 or 4 sessions of xconfig removing stuff
>>> that isn't for my hardware & generally making lots of modules where I
>>> wasn't sure.
>>> 
>>> But, my "makeit" script, when it makes the initrd, spits out this, and
>>> note the not always final "/"
>>> 
>>> now making a new /boot/initrd.3.13.2.img
>>> find: `/lib/modules/3.13.2/kernel/arch': No such file or directory
>>> find: `/lib/modules/3.13.2/kernel/arch': No such file or directory
>>> find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
>>> find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
>>> find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
>>> find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
>>> find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
>>> find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
>>> find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
>>> 
>>> And indeed that directory does not exist.
>>> And that string does not exist in the .config.
>>> 
>>> Does this ring any bells?
>>
>>Not for me, but building the initrd (or initramfs) may be
>>distro-specific. You might have to share the command that was used for
>>that and maybe even the script that was executed (like /sbin/mkinitrd --
>>where yours and mine are probably different depending on distros).
>>
>>Have you (your script) already run 'make install' at this point?
>>AFAIK, that should have created /lib/modules/3.13.2/kernel/arch/ and
>>some other subdirectories there.
>
>Have modified the script, $VER is "3.13.2", to do a make install ahead of
>the
>
>mkinitramfs -o/boot/initrd-$VER.img $VER && \
>
>line but these directories:
>now making a new /boot/initrd.3.13.2.img
>find: `/lib/modules/3.13.2/kernel/arch': No such file or directory
>find: `/lib/modules/3.13.2/kernel/arch': No such file or directory
>find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
>find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
>find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
>find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
>find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
>find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
>find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
>and copying it to initrd-3.13.2.img
>
>are still not being made, initrd-$VER.img is not being made, and that
>path does not exist in the /etc/initramfs-tools directory. 
>initramfs-tools has been re-installed.
>
>I'm stuck.  Where can I buy a paddle? :)
>
>Thanks.
>
>Cheers, Gene

PS: looked at /usr/sbin/mkiniramfs, found it doesn't use the crap in 
/etc/initramfs-tools, but in /usr/share/initramfs-tools.  Grrrr.

There I find this:
gene@coyote:/usr/share/initramfs-tools$ grep -R arch *
hook-functions:		DPKG_ARCH=$(dpkg --print-architecture)
hooks/cryptroot:	#   a) /lib/modules/$VERSION/kernel/arch/$ARCH/crypto/$mod-$specific.ko
hooks/cryptroot:	for file in $(find "$MODULESDIR/kernel/arch/" -name "$mod-*.ko"); do
hooks/cryptroot:		archcrypto="$(find "$MODULESDIR/kernel/arch" -type d -name "crypto")"
hooks/cryptroot:		if [ -n "$archcrypto" ]; then
hooks/cryptroot:			copy_modules_dir "${archcrypto##*${MODULESDIR}/}"

WTF?

Thanks Randy.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

NOTICE: Will pay 100 USD for an HP-4815A defective but
complete probe assembly.

