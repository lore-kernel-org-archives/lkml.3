Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab3GJHbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 03:31:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45435 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980Ab3GJHbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 03:31:05 -0400
Date: Wed, 10 Jul 2013 09:30:49 +0200
From: Borislav Petkov <bp@alien8.de>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Cc: Jacob Shin <jacob.shin@amd.com>, linux-kernel@vger.kernel.org,
        Jacob Shin <jacob.w.shin@gmail.com>
Subject: Re: early microcode on amd is broken when no initramfs provided
Message-ID: <20130710073049.GA15525@pd.tnic>
References: <20130709183601.5d567a83@fem.tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130709183601.5d567a83@fem.tu-ilmenau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 06:36:01PM +0200, Johannes Hirte wrote:
> When CONFIG_MICROCODE_EARLY is enabled on AMD but no initramfs is provided in the
> bootmanager (grub2), the system hangs here:

Hmm, I can't reproduce it here.

grub2 entry is:

menuentry 'Debian GNU/Linux, with Linux 3.10.0+' --class debian --class gnu-linux --class gnu --class os {
        load_video
        insmod gzio
        insmod part_msdos
        insmod ext2
        set root='(hd0,msdos1)'
        search --no-floppy --fs-uuid --set=root adbbd17b-6e04-4458-814f-9a2b75a4d91e
        echo    'Loading Linux 3.10.0+ ...'
        linux   /boot/vmlinuz-3.10.0+ root=/dev/sda1 ro  resume=/dev/sda2 ignore_loglevel
}

Kernel is: v3.10-8587-g496322b

.config settings are:

$ zgrep -E "(INITRD|MICROCODE)" /proc/config.gz
CONFIG_BLK_DEV_INITRD=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
CONFIG_MICROCODE_INTEL_EARLY=y
CONFIG_MICROCODE_AMD_EARLY=y
CONFIG_MICROCODE_EARLY=y
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set

Can you send me your .config and your grub entry please?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
