Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab3LaSpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 13:45:35 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:49186 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232Ab3LaSpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 13:45:34 -0500
MIME-Version: 1.0
In-Reply-To: <201312311305.44859.gheskett@wdtv.com>
References: <201312311305.44859.gheskett@wdtv.com>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Tue, 31 Dec 2013 12:45:13 -0600
Message-ID: <CAAMCDef+swz3c33HseP19KzApT_crQ1eOv-y30a9wRUX4tQ-2A@mail.gmail.com>
Subject: Re: Probably silly Q about bootable partitions
To: Gene Heskett <gheskett@wdtv.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rescue boot it, change the /boot mount line in /etc/fstab to add
noauto (like noauto,defaults...or whatever else you already have) and
change the last column to 0 to disable fsck on it.

It should boot then, and you have the machine fully up were you can do
better debugging.

ie mount /boot may give you a useful error, or it may work...if it
works that implies that in the initrd some piece needed to start /boot
is not there (fs mayb?).

/boot is only needed by the bios...it is not needed when the os is up
except to update teh booting kernel to a new one...

On Tue, Dec 31, 2013 at 12:05 PM, Gene Heskett <gheskett@wdtv.com> wrote:
> Greetings;
>
> I can't build a bootable 3.12.6 kernel, it seems to die quite fast with a
> trace blaming binfmt-some-hex-number.  Or fail well into the boot waiting
> for / to come available.  But if I choose a shell at that failure, it
> isn't / that is not shown in a blkid report, it is /boot, named "ububoot"
> thats missing. "/", named uburoot, is fine.
>
> Here is blkid output booted to 3.12.0.
>
> gene@coyote:~/src/linux-3.12.6$ blkid
> /dev/sdc1: UUID="1321fc90-ba7a-4742-8176-f7b3a8284be5" TYPE="ext4"
> /dev/sdc2: LABEL="amandatapes-1-T" UUID="b7657920-d9a2-4379-ae21-08a0651b65cc" SEC_TYPE="ext2" TYPE="ext3"
> /dev/sda1: LABEL="ububoot" UUID="f54ba7af-1545-43f3-a86e-bfc0017b4526" SEC_TYPE="ext2" TYPE="ext3"
> /dev/sda2: LABEL="uburoot" UUID="ec677e9c-6be6-4311-b97b-3889d42ce6ef" TYPE="ext4"
> /dev/sda3: UUID="edc2880e-257d-4521-8220-0df5b57dcae4" TYPE="swap"
> /dev/sdb1: UUID="80ab0463-d6fc-4f5b-af08-5aa43d55fdf8" SEC_TYPE="ext2" TYPE="ext3"
> /dev/sdb5: UUID="b4841721-a040-48bc-80dc-e742164ad38a" TYPE="swap"
> /dev/sdd1: LABEL="home2" UUID="7601432d-7a30-42a3-80b5-57f08ae71f2a" TYPE="ext4"
> /dev/sdd2: LABEL="opt2" UUID="748b01e1-ae7b-4b17-b8e9-c88429bcefbf" TYPE="ext4"
>
> Duplicating this 3.12.0's settings under "filesystems" for 3.12.6 is
> apparently not the needed fix.
>
> Clues for the apparently clueless?
>
> Thanks all.
>
>
> Cheers, Gene
> --
> "There are four boxes to be used in defense of liberty:
>  soap, ballot, jury, and ammo. Please use in that order."
> -Ed Howdershelt (Author)
> Genes Web page <http://geneslinuxbox.net:6309/gene>
>
> There is no substitute for good manners, except, perhaps, fast reflexes.
> A pen in the hand of this president is far more
> dangerous than 200 million guns in the hands of
>          law-abiding citizens.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
