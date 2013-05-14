Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758406Ab3ENUKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 16:10:06 -0400
Received: from mout.gmx.net ([212.227.17.22]:62064 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757478Ab3ENUKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 16:10:05 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+Ik7gHQTSIO/2dDZeXRsAGyjSNlwSPJ52Cs/1Cav
	FGhjNq93TY5idY
Message-ID: <51929A16.8050306@gmx.de>
Date: Tue, 14 May 2013 22:09:58 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130405 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: v3.10: unmount won't work
References: <51928CB5.2050406@gmx.de>
In-Reply-To: <51928CB5.2050406@gmx.de>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 09:12 PM, Toralf Förster wrote:
> At a stable 32 bit stable Gentoo with kernel v3.10-rc1-113-ga2c7a54 I cannot umount an (EXT4) fs
> which was created in a file located in a tmpfs partition and loop mounted  :
> 
> That file system was used to hold victims files shared via NFSv4 to an user mode linux 
> on which trinity was used to fuzz testing a patched UML guest kernel.

FWIW the numbers are really wrong for /mnt/trinity

# df -m /mnt/trinity/
Filesystem     1M-blocks  Used Available Use% Mounted on
/dev/loop0        183851 31165    143325  18% /mnt/trinity

b/c 257 MB were specified for the file in which the EXT4FS was created:

# ls -lh /mnt/ramdisk/disk0
-rw-r--r-- 1 tfoerste users 257M May 14 20:56 /mnt/ramdisk/disk0

here is the corresponding code snippet :
	FS="ext4"
        dd if=/dev/zero of=/mnt/ramdisk/disk0 bs=1M count=257 2>/dev/null || return 2
        yes | /sbin/mkfs.$FS /mnt/ramdisk/disk0 1>/dev/null || return 3
        sudo su -c "mount -o loop /mnt/ramdisk/disk0 /mnt/trinity/; chmod 777 /mnt/trinity" || return 4

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
