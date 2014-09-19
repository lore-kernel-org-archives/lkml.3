Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbaISJGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 05:06:42 -0400
Received: from mail1.windriver.com ([147.11.146.13]:47498 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaISJGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 05:06:40 -0400
Message-ID: <541BF219.4050307@windriver.com>
Date: Fri, 19 Sep 2014 17:06:33 +0800
From: yzhu1 <Yanjun.Zhu@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: <cjb@laptop.org>, LKML <linux-kernel@vger.kernel.org>
CC: "Wu, Kuaikuai" <Kuaikuai.Wu@windriver.com>, zhuyj <zyjzyj2000@gmail.com>
Subject: access nand flash and mmc card at the same time on xlp board, there
 will be many io errors and system will hung
Content-Type: multipart/mixed;
	boundary="------------060305020701050507030800"
X-Originating-IP: [128.224.162.201]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------060305020701050507030800
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit

Hi, Chris

I run a tests on a xlp208 board. This kernel is 3.17-rc5.
The script are as below.
-------------Begin-------------------
mkfs.ext3 /dev/mmcblk1p1
mount /dev/mmcblk1p1 /mnt
cd /mnt
cp -Rf /root/nand_sd_test /mnt
cd /mnt/nand_sd_test
-------------End---------------------

After several minutes, the following errors will appear.
Would you like give me some advice about this error?

Thanks a lot.
Zhu Yanjun

-----------------------------ErrorMessage------------------------------
16777216 bytes (17 MB) copied, 34.5951 s, 485 kB/s
mmc1: Timeout waiting for hardware interrupt.
mmc1: Timeout waiting for hardware interrupt.
mmc1: Timeout waiting for hardware interrupt.
mmcblk1: error -145 sending status command, retrying
mmc1: Timeout waiting for hardware interrupt.
mmcblk1: error -145 sending status command, retrying
mmc1: Timeout waiting for hardware interrupt.
mmcblk1: error -145 sending status command, aborting
end_request: I/O error, dev mmcblk1, sector 3460800
Buffer I/O error on device mmcblk1p1, logical block 432598
lost page write due to I/O error on mmcblk1p1
end_request: I/O error, dev mmcblk1, sector 3460808
Buffer I/O error on device mmcblk1p1, logical block 432599
lost page write due to I/O error on mmcblk1p1
end_request: I/O error, dev mmcblk1, sector 3460816
Buffer I/O error on device mmcblk1p1, logical block 432600
lost page write due to I/O error on mmcblk1p1
end_request: I/O error, dev mmcblk1, sector 3460824
Buffer I/O error on device mmcblk1p1, logical block 432601
lost page write due to I/O error on mmcblk1p1
end_request: I/O error, dev mmcblk1, sector 3460832
Buffer I/O error on device mmcblk1p1, logical block 432602
lost page write due to I/O error on mmcblk1p1
end_request: I/O error, dev mmcblk1, sector 3460840
Buffer I/O error on device mmcblk1p1, logical block 432603
lost page write due to I/O error on mmcblk1p1
end_request: I/O error, dev mmcblk1, sector 3460848
Buffer I/O error on device mmcblk1p1, logical block 432604
lost page write due to I/O error on mmcblk1p1
end_request: I/O error, dev mmcblk1, sector 3460856
Buffer I/O error on device mmcblk1p1, logical block 432605
lost page write due to I/O error on mmcblk1p1
end_request: I/O error, dev mmcblk1, sector 3460864
Buffer I/O error on device mmcblk1p1, logical block 432606
lost page write due to I/O error on mmcblk1p1

mmc1: Timeout waiting for hardware interrupt.
------------[ cut here ]------------
WARNING: at /linux/drivers/mmc/host/sdhci.c:996 
sdhci_send_command+0xd78/0xe68()
Modules linked in:
CPU: 6 PID: 0 Comm: swapper/6 Not tainted 
3.10.38-ltsi-WR6.0.0.11_standard #1
Stack : c0000000f83ff820 ffffffffc02a290c 0000000000000001 0000000000000e1b
   ffffffffc0d00000 ffffffffc0e005a0 0000000000000004 0000000000000001
   c0000000f83ff860 ffffffffc02a270c 000000000000004d ffffffffc0d00000
   c0000000f83ff880 ffffffffc02a2d7c 0000000000000000 0000000000000000
   0000000000000000 ffffffffc1050000 ffffffffc104d008 ffffffffc1050000
   ffffffffc0b62fc0 ffffffffc0cfab37 ffffffffc104d008 c0000000f8217b28
           0000000000000000 0000000000000006 c0000000f92e2508 
c0000000f92e23c0
   c0000000f83ff900 c0000000f83ff810 c0000000f83ff928 ffffffffc02a008c
   c0000000f83ff960 ffffffffc02a48c8 c0000000f8217788 ffffffffc0b62fc0
   0000000000000006 ffffffffc0274c30 0000000000000000 0000000000000000
   ...
Call Trace:
[<ffffffffc0274c30>] show_stack+0xd8/0xf8
[<ffffffffc02a008c>] warn_slowpath_common+0x8c/0xc8
[<ffffffffc0880868>] sdhci_send_command+0xd78/0xe68
[<ffffffffc0881380>] sdhci_finish_data+0x180/0x3d0
[<ffffffffc08818f0>] sdhci_timeout_timer+0xb0/0x120
[<ffffffffc02b45c8>] call_timer_fn+0x58/0x1a0
[<ffffffffc02b4a00>] run_timer_softirq+0x1f8/0x2d0
[<ffffffffc02aa6a0>] __do_softirq+0x150/0x340
[<ffffffffc02aa9f0>] do_softirq+0xb8/0xc0
[<ffffffffc02aada4>] irq_exit+0xf4/0x110
[<ffffffffc026f160>] ret_from_irq+0x0/0x4
[<ffffffffc026f400>] __r4k_wait+0x20/0x40
[<ffffffffc02f85a8>] cpu_startup_entry+0x190/0x2f8
[<ffffffffc0a33438>] nlm_boot_secondary_cpus+0x44/0x54
---[ end trace 7070d5fae37308f2 ]---

--------------060305020701050507030800
Content-Type: application/zip; name="nand_sd_test.zip"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="nand_sd_test.zip"

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
--------------060305020701050507030800--
