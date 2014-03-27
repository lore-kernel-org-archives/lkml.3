Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbaC0OC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 10:02:27 -0400
Received: from sessmg20.ericsson.net ([193.180.251.50]:61271 "EHLO
	sessmg20.mgmt.ericsson.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755743AbaC0OCZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 10:02:25 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Mar 2014 10:02:24 EDT
X-AuditID: c1b4fb32-b7f4c8e0000012f5-30-53342bea6363
From: Celestino Martinez Lopez <celestino.martinez.lopez@ericsson.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Kernel oops without Backtrace
Thread-Topic: Kernel oops without Backtrace
Thread-Index: Ac9JwxM7mz47HoZfR3ee3zAHivSO/A==
Date: Thu, 27 Mar 2014 13:47:21 +0000
Message-ID: <79ECA39DE9A8974383B3B752D91CED3219E13C35@ESESSMB107.ericsson.se>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [153.88.183.18]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsUyM+Jvje4rbZNgg5PXxC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG5pn3GAue2lXsuLKYpYHxrlYXIweHhICJRMN/mS5GTiBTTOLC
	vfVsXYxcHEICJxglDuxrg3KWMErMuP+QCaSBTcBNYukLfZAGEQFHiR0Hv7KB2MICahIHty1n
	h4hrS2zY+J0NwtaTeLHvLyuIzSKgKtF58xQbyBheAV+Jm1NDQMKMQHu/n1rDBGIzC4hL3Hoy
	nwniHgGJJXvOM0PYohIvH/9jhbAVJT6+2scIUa8jsWD3JzYIW1ti2cLXYPW8AoISJ2c+YZnA
	KDwLydhZSFpmIWmZhaRlASPLKkbJ4tTi4tx0IwO93PTcEr3Uoszk4uL8PL3i1E2MwCA/uOW3
	0Q7Gk3vsDzFKc7AoifNeZ60JEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cBouK5l7nKx02HL
	E1S3T2zY6GbdorBjQf2tE0aqslo9htWnfyotF2pJfRB6WmvxxS7e9BXnk4XXn9TpelhdGKq1
	1spH6dn5pt9JSf+Dvl++quj+01kkq+XWryfrzeecLnn56maBibO62GXladoL53ioTc622r5z
	naJ+gJL8XZ3ia3tvV09iZ1FSYinOSDTUYi4qTgQAp3/1eEACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I am running a SUSE linux 3.0.13-0.27 and after printing an opps the system hangs (though it only happened once).
In the opps there is only Code: information, no stack trace or processor registers.
Analyzing the code most of the cores are in intel_idle function, but there is also appears native_read_tsc and delay_tsc.

Any help would be more than welcome.

Attached the console output:

[2718229.308036] Stack:
[2718229.334021] Call Trace:
[2718229.365203] Code: 01 e8 5d 41 5c c3 0f 1f 40 00 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 48 8d 74 24 2c bf
[2718229.592831] Stack:
[2718229.618815] Call Trace:
[2718229.619910] Leftover inexact backtrace:
[2718229.619910]
[2718229.619911]  <IRQ>
[2718229.619913]  <EOI>
[2718229.619914] Code: 98 45 89 ef 48 89 04 24 eb 16 66 0f 1f 44 00 00 f3 90 65 44 8b 34 25 70 c5 00 00 45 39 fe 75 2b 66 66 90 0f
ae e8 e8 cd 9a db ff
[2718229.620741] Stack:
[2718229.620748] Call Trace:
[2718229.620761] Code: 01 e8 5d 41 5c c3 0f 1f 40 00 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 48 8d 74 24 2c bf
[2718229.620825] Stack:
[2718229.620833] Call Trace:
[2718229.620842] Code: 01 e8 5d 41 5c c3 0f 1f 40 00 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 48 8d 74 24 2c bf
[2718229.621012] Stack:
[2718229.621020] Call Trace:
[2718229.621036] Code: 01 e8 5d 41 5c c3 0f 1f 40 00 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 48 8d 74 24 2c bf
[2718229.621115] Stack:
[2718229.621122] Call Trace:
[2718229.621132] Code: 01 e8 5d 41 5c c3 0f 1f 40 00 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 48 8d 74 24 2c bf
[2718229.621205] Stack:
[2718229.621212] Call Trace:
[2718229.621222] Code: 01 e8 5d 41 5c c3 0f 1f 40 00 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 48 8d 74 24 2c bf
[2718229.621422] Stack:
[2718229.621429] Call Trace:
[2718229.621446] Code: 01 e8 5d 41 5c c3 0f 1f 40 00 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 48 8d 74 24 2c bf
[2718229.621551] Stack:
[2718229.621564] Call Trace:
[2718229.621579] Code: 01 e8 5d 41 5c c3 0f 1f 40 00 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 48 8d 74 24 2c bf
[4194339.646298] Stack:
[4194339.672279] Call Trace:
[4194339.704539] Leftover inexact backtrace:
[4194339.704539]
[4194339.772037]  <IRQ>
[4194339.796922]  <EOI>
[4194339.826073] Code: 70 e4 71 c3 0f 1f 80 00 00 00 00 40 0f b6 c6 e6 70 40 0f b6 c7 e6 71 c3 0f 1f 00 0f 31 89 c1 48 89 d0 48 c1
e0 20 89 ca 48 09 d0 <c3> 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 83 ec 18 48
[4194340.054808] Stack:
[4194340.080786] Call Trace:
[4194340.111957] Code: 01 e8 5d 41 5c c3 0f 1f 40 00 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 48 8d 74 24 2c bf
[4194340.339554] Stack:
[4194340.365534] Call Trace:
[4194340.396700] Code: 01 e8 5d 41 5c c3 0f 1f 40 00 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 48 8d 74 24 2c bf
[4194340.624288] Stack:
[4194340.650267] Call Trace:
[4194340.681435] Code: 01 e8 5d 41 5c c3 0f 1f 40 00 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 48 8d 74 24 2c bf
[4194340.909073] Stack:
[4194340.935054] Call Trace:
[4194340.966222] Code: 01 e8 5d 41 5c c3 0f 1f 40 00 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 48 8d 74 24 2c bf
[4194341.193816] Stack:
[4194341.219796] Call Trace:
[4194341.250969] Code: 01 e8 5d 41 5c c3 0f 1f 40 00 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 48 8d 74 24 2c bf
[4194341.478549] Stack:
[4194341.504530] Call Trace:
[4194341.535696] Code: 01 e8 5d 41 5c c3 0f 1f 40 00 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 48 8d 74 24 2c bf
[4194341.763335] Stack:
BIOS Date: 12/27/10 16:47 e8 5d 41 5c c3 0f 1f 40 00 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 0         621551] Stack:


Press Ctrl+S to enter the Setup Menu..
Press Ctrl+S to enter the Setup Menu.
01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 0
Copyright(c) 2011 LSI Corporation
PCI SLOT ID  LUN VENDOR    PRODUCT                       REVISION CAPACITY
1            0   LSI       Virtual Drive                 RAID1    285148MB     01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 0Initia<Ctrl><H> for WebBIOS or press <Ctrl><Y> for Preboot CLI
PXE 2.1 Build 086 (WfM 2.0)                                                     01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 0                                                          REVISION
CAPACITY
nd on the host adapter.
Auto-detecting USB Mass Storage Devices ..
s fo

CPU : Intel(R) Xeon(R) CPU           X                                          01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 0QPI Operational Speed
b6 c7 e6 71 c3 0f 1f 00 0f 31 89 c1 48 89 d0 48 c1
e0 20 89 ca 48 09 d0 <c3> 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 0                                   8.00.16
01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1 01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e
0f 1f 84 00 00 00 00 0
tializing USB Controllers .. Done.
008F
95 Watts
Press any key to continue.
Press any key to continue.                          95 Watts
Press any key to continue.         8.00.16                                      01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 0Press any key to continue.
Press any key to continue.
Press any key to continue.
Press any key to continue.                                                      01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 0Press any key to continue.
Press any key to continue.
Press any key to continue.

GNU GRUB  version 0.97  (613K lower / 2087424K upper memory)

+-------------------------------------------------------------------------+
Use the ^ and v keys to select which entry is highlighted.
Press enter to boot the selected OS, 'e' to edit the
|                                                                         |
|                                                                         |
| SUSE Linux Enterprise Server 11 SP2 - 3.0.13-0.27                       |
Booting 'SUSE Linux Enterprise Server 11 SP2 - 3.0.13-0.27'


