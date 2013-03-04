Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867Ab3CDTzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 14:55:51 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:45771 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758118Ab3CDTzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 14:55:48 -0500
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: LKML <linux-kernel@vger.kernel.org>
Subject: [REGRESSION] [3.9-rc1] BUG: ktpacpi_nvramd/446 still has locks held!
Date: Mon, 4 Mar 2013 20:55:37 +0100
User-Agent: KMail/1.13.7 (Linux/3.9.0-rc1; KDE/4.8.4; x86_64; ; )
Cc: linux-acpi@vger.kernel.org, ibm-acpi@hmh.eng.br,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303042055.38040.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last known good: 3.8.0
Bad version: 3.9-rc1

[    6.116492] =====================================
[    6.116614] [ BUG: ktpacpi_nvramd/446 still has locks held! ]
[    6.116737] 3.9.0-rc1 #1 Not tainted
[    6.116821] -------------------------------------
[    6.116900] 1 lock held by ktpacpi_nvramd/446:
[    6.116973]  #0:  (&hotkey_thread_mutex){+.+...}, at: [<ffffffffa024e87e>] 
hotkey_kthread+0x1f/0x354 [thinkpad_acpi]
[    6.117193]
[    6.117193] stack backtrace:
[    6.117268] Pid: 446, comm: ktpacpi_nvramd Not tainted 3.9.0-rc1 #1
[    6.117381] Call Trace:
[    6.117445]  [<ffffffff810877ea>] debug_check_no_locks_held+0x8f/0x93
[    6.117600]  [<ffffffff8107d8ac>] set_freezable+0x3e/0x64
[    6.117703] input: ThinkPad Extra Buttons as 
/devices/platform/thinkpad_acpi/input/input5
[    6.117918]  [<ffffffffa024e890>] hotkey_kthread+0x31/0x354 [thinkpad_acpi]
[    6.118088]  [<ffffffffa024e85f>] ? issue_volchange.29885+0x54/0x54 
[thinkpad_acpi]
[    6.118250]  [<ffffffff8105e296>] kthread+0xac/0xb4
[    6.118356]  [<ffffffff8105e1ea>] ? __kthread_parkme+0x60/0x60
[    6.118491]  [<ffffffff814b243c>] ret_from_fork+0x7c/0xb0
[    6.118614]  [<ffffffff8105e1ea>] ? __kthread_parkme+0x60/0x60

Config:
http://mrutecki.pl/download/kernel/3.9.0-rc1/config-3.9.0-rc1

full dmesg:
http://mrutecki.pl/download/kernel/3.9.0-rc1/dmesg-3.9.0-rc1.txt

-- 
Maciej Rutecki
http://www.mrutecki.pl
