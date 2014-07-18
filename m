Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762631AbaGRU4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 16:56:35 -0400
Received: from mail-db3lp0083.outbound.protection.outlook.com ([213.199.154.83]:33960
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762311AbaGRU4d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 16:56:33 -0400
X-Greylist: delayed 947 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jul 2014 16:56:33 EDT
From: Conrad Kostecki <ck@conrad-kostecki.de>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Early microcode not being loaded
Thread-Topic: Early microcode not being loaded
Thread-Index: Ac+iyGu0bjnYxuYsRMClhSHnVLMEqQ==
Date: Fri, 18 Jul 2014 20:40:42 +0000
Message-ID: <d01572d84b834e9d98aef338f7da446a@DB4PR04MB265.eurprd04.prod.outlook.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [93.218.107.228]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 02760F0D1C
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(189002)(377424004)(199002)(229853001)(19580395003)(2656002)(2351001)(74482001)(83072002)(87936001)(83322001)(107886001)(81342001)(54356999)(77982001)(50986999)(33646002)(75402002)(31966008)(85306003)(85852003)(19580405001)(79102001)(4396001)(99396002)(20776003)(101416001)(66066001)(64706001)(105586002)(86362001)(95666004)(46102001)(21056001)(106356001)(92566001)(81542001)(74316001)(110136001)(76576001)(107046002)(74662001)(108616002)(24736002)(19627235001);DIR:OUT;SFP:;SCL:1;SRVR:DB4PR04MB267;H:DB4PR04MB265.eurprd04.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: conrad-kostecki.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
I'am trying to use the feature of loading early an intel microcode.
According to the documentation (early-microcode.txt) that should be possible.

I am currently using my own initrd, so I've created a second one, as the docs specified and merged it with my own.

Galactica linux # file /tmp/ucode.cpio
/tmp/ucode.cpio: ASCII cpio archive (SVR4 with no CRC)

Galactica linux # file /tmp/my_own_initrd.cpio
/tmp/my_own_initrd.cpio: ASCII cpio archive (SVR4 with no CRC)

Galactica linux #  cpio -itv < /tmp/ucode.cpio
drwxr-xr-x   3 root     root            0 Jul 18 17:01 .
drwxr-xr-x   3 root     root            0 Jul 18 17:01 kernel
drwxr-xr-x   3 root     root            0 Jul 18 17:01 kernel/x86
drwxr-xr-x   2 root     root            0 Jul 18 17:01 kernel/x86/microcode
-rw-r--r--   1 root     root      1857432 Jul 18 17:01 kernel/x86/microcode/GenuineIntel.bin

Galactica tmp # cpio -itv < /tmp/my_own_initrd.cpio
drwxr-xr-x  11 root     root            0 Jul 18 22:33 .
drwxr-xr-x   3 root     root            0 Jul 18 22:33 mnt
drwxr-xr-x   2 root     root            0 Jul 18 22:33 mnt/root
drwxr-xr-x   2 root     root            0 Jul 18 22:33 lib64
drwxr-xr-x   2 root     root            0 Jul 18 22:33 etc
drwxr-xr-x   2 root     root            0 Jul 18 22:33 sys
drwxr-xr-x   2 root     root            0 Jul 18 22:33 bin
lrwxrwxrwx   1 root     root           12 Jul 18 22:33 bin/ash -> /bin/busybox
lrwxrwxrwx   1 root     root           12 Jul 18 22:33 bin/cat -> /bin/busybox
lrwxrwxrwx   1 root     root           12 Jul 18 22:33 bin/loadkmap -> /bin/busybox
lrwxrwxrwx   1 root     root           12 Jul 18 22:33 bin/cut -> /bin/busybox
lrwxrwxrwx   1 root     root           12 Jul 18 22:33 bin/setfont -> /bin/busybox
lrwxrwxrwx   1 root     root           12 Jul 18 22:33 bin/kbd_mode -> /bin/busybox
lrwxrwxrwx   1 root     root           12 Jul 18 22:33 bin/echo -> /bin/busybox
lrwxrwxrwx   1 root     root           12 Jul 18 22:33 bin/umount -> /bin/busybox
-rwxr-xr-x   1 root     root      2638208 Jul 18 22:33 bin/busybox
lrwxrwxrwx   1 root     root           12 Jul 18 22:33 bin/mount -> /bin/busybox
lrwxrwxrwx   1 root     root           12 Jul 18 22:33 bin/mdev -> /bin/busybox
lrwxrwxrwx   1 root     root           12 Jul 18 22:33 bin/sleep -> /bin/busybox
lrwxrwxrwx   1 root     root           12 Jul 18 22:33 bin/printf -> /bin/busybox
drwxr-xr-x   3 root     root            0 Jul 18 22:33 usr
drwxr-xr-x   2 root     root            0 Jul 18 22:33 usr/bin
lrwxrwxrwx   1 root     root           12 Jul 18 22:33 usr/bin/setfont -> /bin/busybox
lrwxrwxrwx   1 root     root           12 Jul 18 22:33 usr/bin/kbd_mode -> /bin/busybox
lrwxrwxrwx   1 root     root           12 Jul 18 22:33 usr/bin/printf -> /bin/busybox
drwxr-xr-x   3 root     root            0 Jul 18 22:33 dev
crw-r--r--   1 root     root       5,   1 Jul 18 22:33 dev/console
crw-r--r--   1 root     root       4,  64 Jul 18 22:33 dev/ttyS0
crw-r--r--   1 root     root       1,   3 Jul 18 22:33 dev/null
crw-r--r--   1 root     root       1,   5 Jul 18 22:33 dev/zero
drwxr-xr-x   2 root     root            0 Jul 18 22:33 proc
-rwxr-xr-x   1 root     root         5707 Jul 18 22:33 init
lrwxrwxrwx   1 root     root            5 Jul 18 22:33 lib -> lib64
drwxr-xr-x   2 root     root            0 Jul 18 22:33 sbin
lrwxrwxrwx   1 root     root           12 Jul 18 22:33 sbin/loadkmap -> /bin/busybox
lrwxrwxrwx   1 root     root           12 Jul 18 22:33 sbin/switch_root -> /bin/busybox
lrwxrwxrwx   1 root     root           12 Jul 18 22:33 sbin/mdev -> /bin/busybox
5174 blocks

Then I merged them, as the docs say:
cat /tmp/ucode.cpio /tmp/my_own_initrd.cpio > /boot/initramfs-3.15.5.img

Booting works fine with this combined initrd, but there is no new microcode applied.

[    1.058641] microcode: CPU0 sig=0x20661, pf=0x2, revision=0x104
[    1.063259] microcode: CPU1 sig=0x20661, pf=0x2, revision=0x104
[    1.068011] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba

It's only applied much later, when my microcode_ctl runs as a service.

[   15.764517] microcode: CPU0 sig=0x20661, pf=0x2, revision=0x104
[   15.764979] microcode: CPU0 updated to revision 0x105, date = 2011-07-18
[   15.765970] microcode: CPU1 sig=0x20661, pf=0x2, revision=0x104
[   15.766430] microcode: CPU1 updated to revision 0x105, date = 2011-07-18

Where is the problem? Why is the microcode not being loaded early?

Cheers
Conrad
