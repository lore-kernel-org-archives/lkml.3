Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab3LaTQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 14:16:03 -0500
Received: from mail.wdtv.com ([66.118.69.84]:41090 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756395Ab3LaTQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 14:16:01 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Probably silly Q about bootable partitions
Date: Tue, 31 Dec 2013 14:15:52 -0500
Cc: Kernel development list <linux-kernel@vger.kernel.org>
References: <201312311305.44859.gheskett@wdtv.com> <CAAMCDef+swz3c33HseP19KzApT_crQ1eOv-y30a9wRUX4tQ-2A@mail.gmail.com>
In-Reply-To: <CAAMCDef+swz3c33HseP19KzApT_crQ1eOv-y30a9wRUX4tQ-2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201312311415.52588.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 December 2013, Roger Heflin wrote:
>rescue boot it, change the /boot mount line in /etc/fstab to add
>noauto (like noauto,defaults...or whatever else you already have) and
>change the last column to 0 to disable fsck on it.
>
>It should boot then, and you have the machine fully up were you can do
>better debugging.

It did not, reports a runaway loop in modprobe binfmt-464c, then spits out 
a panic report mentioning the kernel command line option of init= & freezes 
with that report still on screen.

In this install, grub does a preliminary modprobe ext2, but the /boot is 
ext2-3.  And has been for several years.

More clues?

Thanks.

>ie mount /boot may give you a useful error, or it may work...if it
>works that implies that in the initrd some piece needed to start /boot
>is not there (fs mayb?).
>
>/boot is only needed by the bios...it is not needed when the os is up
>except to update teh booting kernel to a new one...
>
>On Tue, Dec 31, 2013 at 12:05 PM, Gene Heskett <gheskett@wdtv.com> wrote:
>> Greetings;
>> 
>> I can't build a bootable 3.12.6 kernel, it seems to die quite fast with
>> a trace blaming binfmt-some-hex-number.  Or fail well into the boot
>> waiting for / to come available.  But if I choose a shell at that
>> failure, it isn't / that is not shown in a blkid report, it is /boot,
>> named "ububoot" thats missing. "/", named uburoot, is fine.
>> 
>> Here is blkid output booted to 3.12.0.
>> 
>> gene@coyote:~/src/linux-3.12.6$ blkid
>> /dev/sdc1: UUID="1321fc90-ba7a-4742-8176-f7b3a8284be5" TYPE="ext4"
>> /dev/sdc2: LABEL="amandatapes-1-T"
>> UUID="b7657920-d9a2-4379-ae21-08a0651b65cc" SEC_TYPE="ext2"
>> TYPE="ext3" /dev/sda1: LABEL="ububoot"
>> UUID="f54ba7af-1545-43f3-a86e-bfc0017b4526" SEC_TYPE="ext2"
>> TYPE="ext3" /dev/sda2: LABEL="uburoot"
>> UUID="ec677e9c-6be6-4311-b97b-3889d42ce6ef" TYPE="ext4" /dev/sda3:
>> UUID="edc2880e-257d-4521-8220-0df5b57dcae4" TYPE="swap" /dev/sdb1:
>> UUID="80ab0463-d6fc-4f5b-af08-5aa43d55fdf8" SEC_TYPE="ext2"
>> TYPE="ext3" /dev/sdb5: UUID="b4841721-a040-48bc-80dc-e742164ad38a"
>> TYPE="swap" /dev/sdd1: LABEL="home2"
>> UUID="7601432d-7a30-42a3-80b5-57f08ae71f2a" TYPE="ext4" /dev/sdd2:
>> LABEL="opt2" UUID="748b01e1-ae7b-4b17-b8e9-c88429bcefbf" TYPE="ext4"
>> 
>> Duplicating this 3.12.0's settings under "filesystems" for 3.12.6 is
>> apparently not the needed fix.
>> 
>> Clues for the apparently clueless?
>> 
>> Thanks all.
>> 
>> 
>> Cheers, Gene

