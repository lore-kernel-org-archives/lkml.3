Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab3CKQbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 12:31:36 -0400
Received: from mx.mcc-med.de ([213.148.153.242]:65314 "EHLO mx.mcc-med.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594Ab3CKQbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 12:31:34 -0400
X-Greylist: delayed 1095 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Mar 2013 12:31:34 EDT
From: "Velykokhatko, Sergey" <Sergey.Velykokhatko@mcc-med.de>
To: "'artem.bityutskiy@linux.intel.com'" 
	<artem.bityutskiy@linux.intel.com>,
        Richard Genoud <richard.genoud@gmail.com>
CC: Brian Norris <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ricard Wanderlof <ricard.wanderlof@axis.com>
Date: Mon, 11 Mar 2013 17:13:06 +0100
Subject: UBI. How are critical these messages?
Thread-Topic: UBI. How are critical these messages?
Thread-Index: Ac4eL46l9zUmQBgnRmO06nkEbVwx3wAO5efQ
Message-ID: <BAF0C2081321BA469F9ADF648F97D9B04C78FA60DB@MCC023.weinmann.com>
References: <BAF0C2081321BA469F9ADF648F97D9B04C78FA6069@MCC023.weinmann.com>
	 <CAN8TOE9YJBvUE9GDW3krZB-Js6gUkqY23gYNLS4gFX0e2NDNZw@mail.gmail.com>
	 <BAF0C2081321BA469F9ADF648F97D9B04C78FA6071@MCC023.weinmann.com>
	 <CACQ1gAg0rE+X+uxRWbrPKhmdS1T0MG00cwwBbzWM+VwU4zaXmw@mail.gmail.com>
	 <BAF0C2081321BA469F9ADF648F97D9B04C78FA607C@MCC023.weinmann.com>
	 <CACQ1gAg=L7ru5J4C7OQN0r-c2VN3baKX1qqty8Z0ObS5Wk48yg@mail.gmail.com>
	 <BAF0C2081321BA469F9ADF648F97D9B04C78FA607E@MCC023.weinmann.com>
	 <CACQ1gAhJzy5tGSuejc3GqaqRxtHvkABOY-tODzedveeRXddvxQ@mail.gmail.com>
 <1362989331.5101.41.camel@sauron.fi.intel.com>
In-Reply-To: <1362989331.5101.41.camel@sauron.fi.intel.com>
Accept-Language: de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginalRecipient: RPFD:ricard.wanderlof@axis.com
X-OriginalRecipient: RPFD:richard.genoud@gmail.com
X-OriginalRecipient: RPFD:computersforpeace@gmail.com
X-OriginalRecipient: RPFD:artem.bityutskiy@linux.intel.com
X-OriginalRecipient: RPFD:linux-mtd@lists.infradead.org
X-OriginalId: qfr2BGD6Sq018236
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2BGVdWq008218

Hi Artem,

Thank you for your answer. I describe shortly what have I done for better understanding. We are using ubi for couple of years and with 2.6.38, 3.3 had no problems. In January 2013 I updated our developing state to 3.7 and in one week got two reports about loosing of device data. This problem could be cause by my software that tries to mount one by one ubi volumes on MTD5. If by any of these mounting an error happened, my SW runs ubiformat+ubimkvol+mount with loosing of whole device data. Till 3.7 this thing worked fine. Unfortunately I had no additional information what was wrong (I mean why mounting suddenly finished with error) and decided to run temporary klogd. Simultaneously updated to 3.8. In last time I heard nothing about of lost device data. Right now I read out kernel logs of 7 devices. In 2 devices I see strange "ecc unrecoverable error" messages. That messages appear only once in each of devices. I know that one of devices (mine) had 4 bad blocks in flash and it has 4 bad blocks now too. Could I ignore these messages, or not?

We are using atmel_nand driver with NAND_ECC_SOFT_BCH.

Best regards,
Sergey Velykokhatko





>From kernel log of device 1:

Mar  8 12:38:45 192 kern.notice kernel: [    9.906000] UBI: attaching mtd5 to ubi1
Mar  8 12:38:45 192 kern.err kernel: [   10.359000] ecc unrecoverable error
Mar  8 12:38:45 192 kern.warn kernel: [   10.363000] UBI warning: ubi_io_read: error -74 (ECC error) while reading 64 bytes from PEB 1110:0, read only 64 bytes, retry
Mar  8 12:38:45 192 kern.err kernel: [   10.374000] ecc unrecoverable error
Mar  8 12:38:45 192 kern.warn kernel: [   10.378000] UBI warning: ubi_io_read: error -74 (ECC error) while reading 64 bytes from PEB 1110:0, read only 64 bytes, retry
Mar  8 12:38:45 192 kern.err kernel: [   10.390000] ecc unrecoverable error
Mar  8 12:38:45 192 kern.warn kernel: [   10.393000] UBI warning: ubi_io_read: error -74 (ECC error) while reading 64 bytes from PEB 1110:0, read only 64 bytes, retry
Mar  8 12:38:45 192 kern.err kernel: [   10.405000] ecc unrecoverable error
Mar  8 12:38:45 192 kern.err kernel: [   10.408000] UBI error: ubi_io_read: error -74 (ECC error) while reading 64 bytes from PEB 1110:0, read 64 bytes
Mar  8 12:38:45 192 kern.warn kernel: [   10.418000] Backtrace:
Mar  8 12:38:45 192 kern.warn kernel: [   10.421000] [<c000c614>] (dump_backtrace+0x0/0x114) from [<c0315e80>] (dump_stack+0x20/0x24)
Mar  8 12:38:45 192 kern.warn kernel: [   10.429000]  r6:c3ac2000 r5:00000040 r4:ffffffb6 r3:c0460e34
Mar  8 12:38:45 192 kern.warn kernel: [   10.435000] [<c0315e60>] (dump_stack+0x0/0x24) from [<c021042c>] (ubi_io_read+0x1e8/0x2b4)
Mar  8 12:38:45 192 kern.warn kernel: [   10.443000] [<c0210244>] (ubi_io_read+0x0/0x2b4) from [<c021077c>] (ubi_io_read_ec_hdr+0x7c/0x22c)
Mar  8 12:38:45 192 kern.warn kernel: [   10.452000] [<c0210700>] (ubi_io_read_ec_hdr+0x0/0x22c) from [<c0215330>] (ubi_attach+0x118/0x13c4)
Mar  8 12:38:45 192 kern.warn kernel: [   10.461000] [<c0215218>] (ubi_attach+0x0/0x13c4) from [<c020a8c0>] (ubi_attach_mtd_dev+0x5a8/0xbd8)
Mar  8 12:38:45 192 kern.warn kernel: [   10.470000] [<c020a318>] (ubi_attach_mtd_dev+0x0/0xbd8) from [<c020b18c>] (ctrl_cdev_ioctl+0xe0/0x194)
Mar  8 12:38:45 192 kern.warn kernel: [   10.479000] [<c020b0ac>] (ctrl_cdev_ioctl+0x0/0x194) from [<c00d5a40>] (vfs_ioctl+0x38/0x4c)
Mar  8 12:38:45 192 kern.warn kernel: [   10.488000]  r7:40186f40 r6:00000000 r5:c38880a0 r4:be880bd8
Mar  8 12:38:45 192 kern.warn kernel: [   10.494000] [<c00d5a08>] (vfs_ioctl+0x0/0x4c) from [<c00d6608>] (do_vfs_ioctl+0x55c/0x5c4)
Mar  8 12:38:45 192 kern.warn kernel: [   10.502000] [<c00d60ac>] (do_vfs_ioctl+0x0/0x5c4) from [<c00d66b8>] (sys_ioctl+0x48/0x70)
Mar  8 12:38:45 192 kern.warn kernel: [   10.510000] [<c00d6670>] (sys_ioctl+0x0/0x70) from [<c0009480>] (ret_fast_syscall+0x0/0x44)
Mar  8 12:38:45 192 kern.warn kernel: [   10.518000]  r8:c00096e4 r7:00000036 r6:0000c8e0 r5:be880bd8 r4:00000003
Mar  8 12:38:45 192 kern.err kernel: [   10.525000] ecc unrecoverable error
Mar  8 12:38:45 192 kern.warn kernel: [   10.529000] UBI warning: ubi_io_read: error -74 (ECC error) while reading 512 bytes from PEB 1110:512, read only 512 bytes, retry
Mar  8 12:38:45 192 kern.err kernel: [   10.541000] ecc unrecoverable error
Mar  8 12:38:45 192 kern.warn kernel: [   10.545000] UBI warning: ubi_io_read: error -74 (ECC error) while reading 512 bytes from PEB 1110:512, read only 512 bytes, retry
Mar  8 12:38:45 192 kern.err kernel: [   10.557000] ecc unrecoverable error
Mar  8 12:38:45 192 kern.warn kernel: [   10.560000] UBI warning: ubi_io_read: error -74 (ECC error) while reading 512 bytes from PEB 1110:512, read only 512 bytes, retry
Mar  8 12:38:45 192 kern.err kernel: [   10.572000] ecc unrecoverable error
Mar  8 12:38:45 192 kern.err kernel: [   10.576000] UBI error: ubi_io_read: error -74 (ECC error) while reading 512 bytes from PEB 1110:512, read 512 bytes
Mar  8 12:38:45 192 kern.warn kernel: [   10.586000] Backtrace:
Mar  8 12:38:45 192 kern.warn kernel: [   10.589000] [<c000c614>] (dump_backtrace+0x0/0x114) from [<c0315e80>] (dump_stack+0x20/0x24)
Mar  8 12:38:45 192 kern.warn kernel: [   10.597000]  r6:c3ac2000 r5:00000200 r4:ffffffb6 r3:c0460e34
Mar  8 12:38:45 192 kern.warn kernel: [   10.603000] [<c0315e60>] (dump_stack+0x0/0x24) from [<c021042c>] (ubi_io_read+0x1e8/0x2b4)
Mar  8 12:38:45 192 kern.warn kernel: [   10.611000] [<c0210244>] (ubi_io_read+0x0/0x2b4) from [<c02109ac>] (ubi_io_read_vid_hdr+0x80/0x240)
Mar  8 12:38:45 192 kern.warn kernel: [   10.620000] [<c021092c>] (ubi_io_read_vid_hdr+0x0/0x240) from [<c0215504>] (ubi_attach+0x2ec/0x13c4)
Mar  8 12:38:45 192 kern.warn kernel: [   10.629000] [<c0215218>] (ubi_attach+0x0/0x13c4) from [<c020a8c0>] (ubi_attach_mtd_dev+0x5a8/0xbd8)
Mar  8 12:38:45 192 kern.warn kernel: [   10.638000] [<c020a318>] (ubi_attach_mtd_dev+0x0/0xbd8) from [<c020b18c>] (ctrl_cdev_ioctl+0xe0/0x194)
Mar  8 12:38:45 192 kern.warn kernel: [   10.648000] [<c020b0ac>] (ctrl_cdev_ioctl+0x0/0x194) from [<c00d5a40>] (vfs_ioctl+0x38/0x4c)
Mar  8 12:38:45 192 kern.warn kernel: [   10.656000]  r7:40186f40 r6:00000000 r5:c38880a0 r4:be880bd8
Mar  8 12:38:45 192 kern.warn kernel: [   10.662000] [<c00d5a08>] (vfs_ioctl+0x0/0x4c) from [<c00d6608>] (do_vfs_ioctl+0x55c/0x5c4)
Mar  8 12:38:45 192 kern.warn kernel: [   10.670000] [<c00d60ac>] (do_vfs_ioctl+0x0/0x5c4) from [<c00d66b8>] (sys_ioctl+0x48/0x70)
Mar  8 12:38:45 192 kern.warn kernel: [   10.678000] [<c00d6670>] (sys_ioctl+0x0/0x70) from [<c0009480>] (ret_fast_syscall+0x0/0x44)
Mar  8 12:38:45 192 kern.warn kernel: [   10.686000]  r8:c00096e4 r7:00000036 r6:0000c8e0 r5:be880bd8 r4:00000003
Mar  8 12:38:45 192 kern.err kernel: [   10.696000] ecc unrecoverable error
Mar  8 12:38:45 192 kern.warn kernel: [   10.699000] UBI warning: ubi_io_read: error -74 (ECC error) while reading 64 bytes from PEB 1116:0, read only 64 bytes, retry
Mar  8 12:38:45 192 kern.err kernel: [   10.711000] ecc unrecoverable error
Mar  8 12:38:45 192 kern.warn kernel: [   10.714000] UBI warning: ubi_io_read: error -74 (ECC error) while reading 64 bytes from PEB 1116:0, read only 64 bytes, retry
Mar  8 12:38:45 192 kern.err kernel: [   10.726000] ecc unrecoverable error
Mar  8 12:38:45 192 kern.warn kernel: [   10.730000] UBI warning: ubi_io_read: error -74 (ECC error) while reading 64 bytes from PEB 1116:0, read only 64 bytes, retry
Mar  8 12:38:45 192 kern.err kernel: [   10.741000] ecc unrecoverable error
Mar  8 12:38:45 192 kern.err kernel: [   10.745000] UBI error: ubi_io_read: error -74 (ECC error) while reading 64 bytes from PEB 1116:0, read 64 bytes
Mar  8 12:38:45 192 kern.warn kernel: [   10.755000] Backtrace:
Mar  8 12:38:45 192 kern.warn kernel: [   10.758000] [<c000c614>] (dump_backtrace+0x0/0x114) from [<c0315e80>] (dump_stack+0x20/0x24)
Mar  8 12:38:45 192 kern.warn kernel: [   10.766000]  r6:c3ac2000 r5:00000040 r4:ffffffb6 r3:c0460e34
Mar  8 12:38:45 192 kern.warn kernel: [   10.772000] [<c0315e60>] (dump_stack+0x0/0x24) from [<c021042c>] (ubi_io_read+0x1e8/0x2b4)
Mar  8 12:38:45 192 kern.warn kernel: [   10.780000] [<c0210244>] (ubi_io_read+0x0/0x2b4) from [<c021077c>] (ubi_io_read_ec_hdr+0x7c/0x22c)
Mar  8 12:38:45 192 kern.warn kernel: [   10.789000] [<c0210700>] (ubi_io_read_ec_hdr+0x0/0x22c) from [<c0215330>] (ubi_attach+0x118/0x13c4)
Mar  8 12:38:45 192 kern.warn kernel: [   10.798000] [<c0215218>] (ubi_attach+0x0/0x13c4) from [<c020a8c0>] (ubi_attach_mtd_dev+0x5a8/0xbd8)
Mar  8 12:38:45 192 kern.warn kernel: [   10.807000] [<c020a318>] (ubi_attach_mtd_dev+0x0/0xbd8) from [<c020b18c>] (ctrl_cdev_ioctl+0xe0/0x194)
Mar  8 12:38:45 192 kern.warn kernel: [   10.816000] [<c020b0ac>] (ctrl_cdev_ioctl+0x0/0x194) from [<c00d5a40>] (vfs_ioctl+0x38/0x4c)
Mar  8 12:38:45 192 kern.warn kernel: [   10.825000]  r7:40186f40 r6:00000000 r5:c38880a0 r4:be880bd8
Mar  8 12:38:45 192 kern.warn kernel: [   10.830000] [<c00d5a08>] (vfs_ioctl+0x0/0x4c) from [<c00d6608>] (do_vfs_ioctl+0x55c/0x5c4)
Mar  8 12:38:45 192 kern.warn kernel: [   10.839000] [<c00d60ac>] (do_vfs_ioctl+0x0/0x5c4) from [<c00d66b8>] (sys_ioctl+0x48/0x70)
Mar  8 12:38:45 192 kern.warn kernel: [   10.847000] [<c00d6670>] (sys_ioctl+0x0/0x70) from [<c0009480>] (ret_fast_syscall+0x0/0x44)
Mar  8 12:38:45 192 kern.warn kernel: [   10.855000]  r8:c00096e4 r7:00000036 r6:0000c8e0 r5:be880bd8 r4:00000003
Mar  8 12:38:45 192 kern.err kernel: [   10.862000] ecc unrecoverable error
Mar  8 12:38:45 192 kern.warn kernel: [   10.866000] UBI warning: ubi_io_read: error -74 (ECC error) while reading 512 bytes from PEB 1116:512, read only 512 bytes, retry
Mar  8 12:38:45 192 kern.err kernel: [   10.878000] ecc unrecoverable error
Mar  8 12:38:45 192 kern.warn kernel: [   10.881000] UBI warning: ubi_io_read: error -74 (ECC error) while reading 512 bytes from PEB 1116:512, read only 512 bytes, retry
Mar  8 12:38:45 192 kern.err kernel: [   10.894000] ecc unrecoverable error
Mar  8 12:38:45 192 kern.warn kernel: [   10.897000] UBI warning: ubi_io_read: error -74 (ECC error) while reading 512 bytes from PEB 1116:512, read only 512 bytes, retry
Mar  8 12:38:45 192 kern.err kernel: [   10.909000] ecc unrecoverable error
Mar  8 12:38:45 192 kern.err kernel: [   10.913000] UBI error: ubi_io_read: error -74 (ECC error) while reading 512 bytes from PEB 1116:512, read 512 bytes
Mar  8 12:38:45 192 kern.warn kernel: [   10.923000] Backtrace:
Mar  8 12:38:45 192 kern.warn kernel: [   10.926000] [<c000c614>] (dump_backtrace+0x0/0x114) from [<c0315e80>] (dump_stack+0x20/0x24)
Mar  8 12:38:45 192 kern.warn kernel: [   10.934000]  r6:c3ac2000 r5:00000200 r4:ffffffb6 r3:c0460e34
Mar  8 12:38:45 192 kern.warn kernel: [   10.940000] [<c0315e60>] (dump_stack+0x0/0x24) from [<c021042c>] (ubi_io_read+0x1e8/0x2b4)
Mar  8 12:38:45 192 kern.warn kernel: [   10.948000] [<c0210244>] (ubi_io_read+0x0/0x2b4) from [<c02109ac>] (ubi_io_read_vid_hdr+0x80/0x240)
Mar  8 12:38:45 192 kern.warn kernel: [   10.958000] [<c021092c>] (ubi_io_read_vid_hdr+0x0/0x240) from [<c0215504>] (ubi_attach+0x2ec/0x13c4)
Mar  8 12:38:45 192 kern.warn kernel: [   10.967000] [<c0215218>] (ubi_attach+0x0/0x13c4) from [<c020a8c0>] (ubi_attach_mtd_dev+0x5a8/0xbd8)
Mar  8 12:38:45 192 kern.warn kernel: [   10.976000] [<c020a318>] (ubi_attach_mtd_dev+0x0/0xbd8) from [<c020b18c>] (ctrl_cdev_ioctl+0xe0/0x194)
Mar  8 12:38:45 192 kern.warn kernel: [   10.985000] [<c020b0ac>] (ctrl_cdev_ioctl+0x0/0x194) from [<c00d5a40>] (vfs_ioctl+0x38/0x4c)
Mar  8 12:38:45 192 kern.warn kernel: [   10.994000]  r7:40186f40 r6:00000000 r5:c38880a0 r4:be880bd8
Mar  8 12:38:45 192 kern.warn kernel: [   10.999000] [<c00d5a08>] (vfs_ioctl+0x0/0x4c) from [<c00d6608>] (do_vfs_ioctl+0x55c/0x5c4)
Mar  8 12:38:45 192 kern.warn kernel: [   11.008000] [<c00d60ac>] (do_vfs_ioctl+0x0/0x5c4) from [<c00d66b8>] (sys_ioctl+0x48/0x70)
Mar  8 12:38:45 192 kern.warn kernel: [   11.016000] [<c00d6670>] (sys_ioctl+0x0/0x70) from [<c0009480>] (ret_fast_syscall+0x0/0x44)
Mar  8 12:38:45 192 kern.warn kernel: [   11.024000]  r8:c00096e4 r7:00000036 r6:0000c8e0 r5:be880bd8 r4:00000003
Mar  8 12:38:45 192 kern.err kernel: [   11.035000] ecc unrecoverable error
Mar  8 12:38:45 192 kern.warn kernel: [   11.039000] UBI warning: ubi_io_read: error -74 (ECC error) while reading 64 bytes from PEB 1126:0, read only 64 bytes, retry
Mar  8 12:38:45 192 kern.err kernel: [   11.050000] ecc unrecoverable error
Mar  8 12:38:45 192 kern.warn kernel: [   11.054000] UBI warning: ubi_io_read: error -74 (ECC error) while reading 64 bytes from PEB 1126:0, read only 64 bytes, retry
Mar  8 12:38:45 192 kern.err kernel: [   11.066000] ecc unrecoverable error
Mar  8 12:38:45 192 kern.warn kernel: [   11.069000] UBI warning: ubi_io_read: error -74 (ECC error) while reading 64 bytes from PEB 1126:0, read only 64 bytes, retry
Mar  8 12:38:45 192 kern.err kernel: [   11.081000] ecc unrecoverable error
Mar  8 12:38:45 192 kern.err kernel: [   11.084000] UBI error: ubi_io_read: error -74 (ECC error) while reading 64 bytes from PEB 1126:0, read 64 bytes
Mar  8 12:38:45 192 kern.warn kernel: [   11.094000] Backtrace:
Mar  8 12:38:45 192 kern.warn kernel: [   11.097000] [<c000c614>] (dump_backtrace+0x0/0x114) from [<c0315e80>] (dump_stack+0x20/0x24)
Mar  8 12:38:45 192 kern.warn kernel: [   11.105000]  r6:c3ac2000 r5:00000040 r4:ffffffb6 r3:c0460e34
Mar  8 12:38:45 192 kern.warn kernel: [   11.111000] [<c0315e60>] (dump_stack+0x0/0x24) from [<c021042c>] (ubi_io_read+0x1e8/0x2b4)
Mar  8 12:38:45 192 kern.warn kernel: [   11.119000] [<c0210244>] (ubi_io_read+0x0/0x2b4) from [<c021077c>] (ubi_io_read_ec_hdr+0x7c/0x22c)
Mar  8 12:38:45 192 kern.warn kernel: [   11.128000] [<c0210700>] (ubi_io_read_ec_hdr+0x0/0x22c) from [<c0215330>] (ubi_attach+0x118/0x13c4)
Mar  8 12:38:45 192 kern.warn kernel: [   11.137000] [<c0215218>] (ubi_attach+0x0/0x13c4) from [<c020a8c0>] (ubi_attach_mtd_dev+0x5a8/0xbd8)
Mar  8 12:38:45 192 kern.warn kernel: [   11.146000] [<c020a318>] (ubi_attach_mtd_dev+0x0/0xbd8) from [<c020b18c>] (ctrl_cdev_ioctl+0xe0/0x194)
Mar  8 12:38:45 192 kern.warn kernel: [   11.156000] [<c020b0ac>] (ctrl_cdev_ioctl+0x0/0x194) from [<c00d5a40>] (vfs_ioctl+0x38/0x4c)
Mar  8 12:38:45 192 kern.warn kernel: [   11.164000]  r7:40186f40 r6:00000000 r5:c38880a0 r4:be880bd8
Mar  8 12:38:45 192 kern.warn kernel: [   11.170000] [<c00d5a08>] (vfs_ioctl+0x0/0x4c) from [<c00d6608>] (do_vfs_ioctl+0x55c/0x5c4)
Mar  8 12:38:45 192 kern.warn kernel: [   11.178000] [<c00d60ac>] (do_vfs_ioctl+0x0/0x5c4) from [<c00d66b8>] (sys_ioctl+0x48/0x70)
Mar  8 12:38:45 192 kern.warn kernel: [   11.186000] [<c00d6670>] (sys_ioctl+0x0/0x70) from [<c0009480>] (ret_fast_syscall+0x0/0x44)
Mar  8 12:38:45 192 kern.warn kernel: [   11.194000]  r8:c00096e4 r7:00000036 r6:0000c8e0 r5:be880bd8 r4:00000003
Mar  8 12:38:45 192 kern.err kernel: [   11.201000] ecc unrecoverable error
Mar  8 12:38:45 192 kern.warn kernel: [   11.205000] UBI warning: ubi_io_read: error -74 (ECC error) while reading 512 bytes from PEB 1126:512, read only 512 bytes, retry
Mar  8 12:38:45 192 kern.err kernel: [   11.217000] ecc unrecoverable error
Mar  8 12:38:45 192 kern.warn kernel: [   11.221000] UBI warning: ubi_io_read: error -74 (ECC error) while reading 512 bytes from PEB 1126:512, read only 512 bytes, retry
Mar  8 12:38:45 192 kern.err kernel: [   11.233000] ecc unrecoverable error
Mar  8 12:38:45 192 kern.warn kernel: [   11.236000] UBI warning: ubi_io_read: error -74 (ECC error) while reading 512 bytes from PEB 1126:512, read only 512 bytes, retry
Mar  8 12:38:45 192 kern.err kernel: [   11.248000] ecc unrecoverable error
Mar  8 12:38:45 192 kern.err kernel: [   11.252000] UBI error: ubi_io_read: error -74 (ECC error) while reading 512 bytes from PEB 1126:512, read 512 bytes
Mar  8 12:38:45 192 kern.warn kernel: [   11.262000] Backtrace:
Mar  8 12:38:45 192 kern.warn kernel: [   11.265000] [<c000c614>] (dump_backtrace+0x0/0x114) from [<c0315e80>] (dump_stack+0x20/0x24)
Mar  8 12:38:45 192 kern.warn kernel: [   11.273000]  r6:c3ac2000 r5:00000200 r4:ffffffb6 r3:c0460e34
Mar  8 12:38:45 192 kern.warn kernel: [   11.279000] [<c0315e60>] (dump_stack+0x0/0x24) from [<c021042c>] (ubi_io_read+0x1e8/0x2b4)
Mar  8 12:38:45 192 kern.warn kernel: [   11.287000] [<c0210244>] (ubi_io_read+0x0/0x2b4) from [<c02109ac>] (ubi_io_read_vid_hdr+0x80/0x240)
Mar  8 12:38:45 192 kern.warn kernel: [   11.296000] [<c021092c>] (ubi_io_read_vid_hdr+0x0/0x240) from [<c0215504>] (ubi_attach+0x2ec/0x13c4)
Mar  8 12:38:45 192 kern.warn kernel: [   11.305000] [<c0215218>] (ubi_attach+0x0/0x13c4) from [<c020a8c0>] (ubi_attach_mtd_dev+0x5a8/0xbd8)
Mar  8 12:38:45 192 kern.warn kernel: [   11.314000] [<c020a318>] (ubi_attach_mtd_dev+0x0/0xbd8) from [<c020b18c>] (ctrl_cdev_ioctl+0xe0/0x194)
Mar  8 12:38:45 192 kern.warn kernel: [   11.324000] [<c020b0ac>] (ctrl_cdev_ioctl+0x0/0x194) from [<c00d5a40>] (vfs_ioctl+0x38/0x4c)
Mar  8 12:38:45 192 kern.warn kernel: [   11.332000]  r7:40186f40 r6:00000000 r5:c38880a0 r4:be880bd8
Mar  8 12:38:45 192 kern.warn kernel: [   11.338000] [<c00d5a08>] (vfs_ioctl+0x0/0x4c) from [<c00d6608>] (do_vfs_ioctl+0x55c/0x5c4)
Mar  8 12:38:45 192 kern.warn kernel: [   11.346000] [<c00d60ac>] (do_vfs_ioctl+0x0/0x5c4) from [<c00d66b8>] (sys_ioctl+0x48/0x70)
Mar  8 12:38:45 192 kern.warn kernel: [   11.354000] [<c00d6670>] (sys_ioctl+0x0/0x70) from [<c0009480>] (ret_fast_syscall+0x0/0x44)
Mar  8 12:38:45 192 kern.warn kernel: [   11.362000]  r8:c00096e4 r7:00000036 r6:0000c8e0 r5:be880bd8 r4:00000003
Mar  8 12:38:45 192 kern.notice kernel: [   12.026000] UBI: scanning is finished
Mar  8 12:38:45 192 kern.notice kernel: [   12.066000] UBI: attached mtd5 (name "config_data", size 345 MiB) to ubi1
Mar  8 12:38:45 192 kern.notice kernel: [   12.073000] UBI: PEB size: 131072 bytes (128 KiB), LEB size: 129024 bytes
Mar  8 12:38:45 192 kern.notice kernel: [   12.080000] UBI: min./max. I/O unit sizes: 2048/2048, sub-page size 512
Mar  8 12:38:45 192 kern.notice kernel: [   12.087000] UBI: VID header offset: 512 (aligned 512), data offset: 2048
Mar  8 12:38:45 192 kern.notice kernel: [   12.094000] UBI: good PEBs: 2763, bad PEBs: 4, corrupted PEBs: 0
Mar  8 12:38:45 192 kern.notice kernel: [   12.100000] UBI: user volume: 4, internal volumes: 1, max. volumes count: 128



>From kernel log of device 2:

Mar  8 16:02:30 (none) kern.notice kernel: [    1.690000] UBI: attaching mtd5 to ubi1
Mar  8 16:02:30 (none) kern.err kernel: [    2.064000] ecc unrecoverable error
Mar  8 16:02:30 (none) kern.warn kernel: [    2.068000] UBI warning: ubi_io_read: error -74 (ECC error) while reading 64 bytes from PEB 928:0, read only 64 bytes, retry
Mar  8 16:02:30 (none) kern.err kernel: [    2.068000] ecc unrecoverable error
Mar  8 16:02:30 (none) kern.warn kernel: [    2.072000] UBI warning: ubi_io_read: error -74 (ECC error) while reading 64 bytes from PEB 928:0, read only 64 bytes, retry
Mar  8 16:02:30 (none) kern.err kernel: [    2.072000] ecc unrecoverable error
Mar  8 16:02:30 (none) kern.warn kernel: [    2.076000] UBI warning: ubi_io_read: error -74 (ECC error) while reading 64 bytes from PEB 928:0, read only 64 bytes, retry
Mar  8 16:02:30 (none) kern.err kernel: [    2.076000] ecc unrecoverable error
Mar  8 16:02:30 (none) kern.err kernel: [    2.080000] UBI error: ubi_io_read: error -74 (ECC error) while reading 64 bytes from PEB 928:0, read 64 bytes
Mar  8 16:02:30 (none) kern.warn kernel: [    2.090000] Backtrace:
Mar  8 16:02:30 (none) kern.warn kernel: [    2.090000] [<c000c614>] (dump_backtrace+0x0/0x114) from [<c0315e80>] (dump_stack+0x20/0x24)
Mar  8 16:02:30 (none) kern.warn kernel: [    2.090000]  r6:c3a84000 r5:00000040 r4:ffffffb6 r3:c0460e34
Mar  8 16:02:30 (none) kern.warn kernel: [    2.090000] [<c0315e60>] (dump_stack+0x0/0x24) from [<c021042c>] (ubi_io_read+0x1e8/0x2b4)
Mar  8 16:02:30 (none) kern.warn kernel: [    2.090000] [<c0210244>] (ubi_io_read+0x0/0x2b4) from [<c021077c>] (ubi_io_read_ec_hdr+0x7c/0x22c)
Mar  8 16:02:30 (none) kern.warn kernel: [    2.090000] [<c0210700>] (ubi_io_read_ec_hdr+0x0/0x22c) from [<c0215330>] (ubi_attach+0x118/0x13c4)
Mar  8 16:02:30 (none) kern.warn kernel: [    2.090000] [<c0215218>] (ubi_attach+0x0/0x13c4) from [<c020a8c0>] (ubi_attach_mtd_dev+0x5a8/0xbd8)
Mar  8 16:02:30 (none) kern.warn kernel: [    2.091000] [<c020a318>] (ubi_attach_mtd_dev+0x0/0xbd8) from [<c020b18c>] (ctrl_cdev_ioctl+0xe0/0x194)
Mar  8 16:02:30 (none) kern.warn kernel: [    2.091000] [<c020b0ac>] (ctrl_cdev_ioctl+0x0/0x194) from [<c00d5a40>] (vfs_ioctl+0x38/0x4c)
Mar  8 16:02:30 (none) kern.warn kernel: [    2.091000]  r7:40186f40 r6:00000000 r5:c3888d20 r4:bec84bd8
Mar  8 16:02:30 (none) kern.warn kernel: [    2.091000] [<c00d5a08>] (vfs_ioctl+0x0/0x4c) from [<c00d6608>] (do_vfs_ioctl+0x55c/0x5c4)
Mar  8 16:02:30 (none) kern.warn kernel: [    2.091000] [<c00d60ac>] (do_vfs_ioctl+0x0/0x5c4) from [<c00d66b8>] (sys_ioctl+0x48/0x70)
Mar  8 16:02:30 (none) kern.warn kernel: [    2.091000] [<c00d6670>] (sys_ioctl+0x0/0x70) from [<c0009480>] (ret_fast_syscall+0x0/0x44)
Mar  8 16:02:30 (none) kern.warn kernel: [    2.091000]  r8:c00096e4 r7:00000036 r6:0000c8e0 r5:bec84bd8 r4:00000003
Mar  8 16:02:30 (none) kern.err kernel: [    2.092000] ecc unrecoverable error
Mar  8 16:02:30 (none) kern.warn kernel: [    2.095000] UBI warning: ubi_io_read: error -74 (ECC error) while reading 512 bytes from PEB 928:512, read only 512 bytes, retry
Mar  8 16:02:30 (none) kern.err kernel: [    2.096000] ecc unrecoverable error
Mar  8 16:02:30 (none) kern.warn kernel: [    2.099000] UBI warning: ubi_io_read: error -74 (ECC error) while reading 512 bytes from PEB 928:512, read only 512 bytes, retry
Mar  8 16:02:30 (none) kern.err kernel: [    2.100000] ecc unrecoverable error
Mar  8 16:02:30 (none) kern.warn kernel: [    2.103000] UBI warning: ubi_io_read: error -74 (ECC error) while reading 512 bytes from PEB 928:512, read only 512 bytes, retry
Mar  8 16:02:30 (none) kern.err kernel: [    2.104000] ecc unrecoverable error
Mar  8 16:02:30 (none) kern.err kernel: [    2.107000] UBI error: ubi_io_read: error -74 (ECC error) while reading 512 bytes from PEB 928:512, read 512 bytes
Mar  8 16:02:30 (none) kern.warn kernel: [    2.118000] Backtrace:
Mar  8 16:02:30 (none) kern.warn kernel: [    2.118000] [<c000c614>] (dump_backtrace+0x0/0x114) from [<c0315e80>] (dump_stack+0x20/0x24)
Mar  8 16:02:30 (none) kern.warn kernel: [    2.118000]  r6:c3a84000 r5:00000200 r4:ffffffb6 r3:c0460e34
Mar  8 16:02:30 (none) kern.warn kernel: [    2.118000] [<c0315e60>] (dump_stack+0x0/0x24) from [<c021042c>] (ubi_io_read+0x1e8/0x2b4)
Mar  8 16:02:30 (none) kern.warn kernel: [    2.118000] [<c0210244>] (ubi_io_read+0x0/0x2b4) from [<c02109ac>] (ubi_io_read_vid_hdr+0x80/0x240)
Mar  8 16:02:30 (none) kern.warn kernel: [    2.118000] [<c021092c>] (ubi_io_read_vid_hdr+0x0/0x240) from [<c0215504>] (ubi_attach+0x2ec/0x13c4)
Mar  8 16:02:30 (none) kern.warn kernel: [    2.118000] [<c0215218>] (ubi_attach+0x0/0x13c4) from [<c020a8c0>] (ubi_attach_mtd_dev+0x5a8/0xbd8)
Mar  8 16:02:30 (none) kern.warn kernel: [    2.118000] [<c020a318>] (ubi_attach_mtd_dev+0x0/0xbd8) from [<c020b18c>] (ctrl_cdev_ioctl+0xe0/0x194)
Mar  8 16:02:30 (none) kern.warn kernel: [    2.118000] [<c020b0ac>] (ctrl_cdev_ioctl+0x0/0x194) from [<c00d5a40>] (vfs_ioctl+0x38/0x4c)
Mar  8 16:02:30 (none) kern.warn kernel: [    2.118000]  r7:40186f40 r6:00000000 r5:c3888d20 r4:bec84bd8
Mar  8 16:02:30 (none) kern.warn kernel: [    2.118000] [<c00d5a08>] (vfs_ioctl+0x0/0x4c) from [<c00d6608>] (do_vfs_ioctl+0x55c/0x5c4)
Mar  8 16:02:30 (none) kern.warn kernel: [    2.118000] [<c00d60ac>] (do_vfs_ioctl+0x0/0x5c4) from [<c00d66b8>] (sys_ioctl+0x48/0x70)
Mar  8 16:02:30 (none) kern.warn kernel: [    2.118000] [<c00d6670>] (sys_ioctl+0x0/0x70) from [<c0009480>] (ret_fast_syscall+0x0/0x44)
Mar  8 16:02:30 (none) kern.warn kernel: [    2.118000]  r8:c00096e4 r7:00000036 r6:0000c8e0 r5:bec84bd8 r4:00000003
Mar  8 16:02:30 (none) kern.notice kernel: [    2.857000] UBI: scanning is finished
Mar  8 16:02:30 (none) kern.notice kernel: [    2.889000] UBI: attached mtd5 (name "config_data", size 345 MiB) to ubi1
Mar  8 16:02:30 (none) kern.notice kernel: [    2.890000] UBI: PEB size: 131072 bytes (128 KiB), LEB size: 129024 bytes
Mar  8 16:02:30 (none) kern.notice kernel: [    2.890000] UBI: min./max. I/O unit sizes: 2048/2048, sub-page size 512
Mar  8 16:02:30 (none) kern.notice kernel: [    2.890000] UBI: VID header offset: 512 (aligned 512), data offset: 2048
Mar  8 16:02:30 (none) kern.notice kernel: [    2.890000] UBI: good PEBs: 2763, bad PEBs: 4, corrupted PEBs: 0
Mar  8 16:02:30 (none) kern.notice kernel: [    2.890000] UBI: user volume: 4, internal volumes: 1, max. volumes count: 128
Mar  8 16:02:30 (none) kern.notice kernel: [    2.890000] UBI: max/mean erase counter: 95/39, WL threshold: 4096, image sequence number: 2041614926
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
