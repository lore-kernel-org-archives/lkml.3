Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422660AbaDPOqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 10:46:43 -0400
Received: from www.meduna.org ([92.240.244.38]:46810 "EHLO meduna.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161422AbaDPOql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 10:46:41 -0400
Message-ID: <534E97C8.5090407@meduna.org>
Date: Wed, 16 Apr 2014 16:46:32 +0200
From: Stanislav Meduna <stano@meduna.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: zbr@ioremap.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
Subject: w1-gpio: sleeping function called from invalid context
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authenticated-User: stano@meduna.org
X-Authenticator: dovecot_plain
X-Spam-Score: -6.9
X-Spam-Score-Int: -68
X-Exim-Version: 4.72 (build at 25-Oct-2012 18:35:58)
X-Date: 2014-04-16 16:46:37
X-Connected-IP: 95.105.163.217:18759
X-Message-Linecount: 46
X-Body-Linecount: 33
X-Message-Size: 2618
X-Body-Size: 2068
X-Received-Count: 1
X-Recipient-Count: 3
X-Local-Recipient-Count: 3
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

trying 1-wire with rt-patched Linux 3.12.15-rt25+ and lock debugging:

[   12.055550] BUG: sleeping function called from invalid context at /home/stano/Kernels/linux-3.12-rt/kernel/rtmutex.c:673
[   12.055573] in_atomic(): 0, irqs_disabled(): 128, pid: 92, name: w1_bus_master1
[   12.055588] 2 locks held by w1_bus_master1/92:
[   12.055675]  #0:  (&dev->mutex){+.+...}, at: [<c0233560>] w1_process+0xbc/0xe0
[   12.055729]  #1:  (&dev->bus_mutex){+.+...}, at: [<c0232a50>] w1_search+0x78/0x1e8
[   12.055741] irq event stamp: 374
[   12.055787] hardirqs last  enabled at (373): [<c02e04cc>] _raw_spin_unlock_irqrestore+0x6c/0x74
[   12.055815] hardirqs last disabled at (374): [<c0234598>] w1_touch_bit+0x50/0xc4
[   12.055860] softirqs last  enabled at (0): [<c001bacc>] copy_process+0x37c/0x1178
[   12.055876] softirqs last disabled at (0): [<  (null)>]   (null)
[   12.055899] CPU: 0 PID: 92 Comm: w1_bus_master1 Not tainted 3.12.15-rt25+ #66
[   12.055973] [<c00151bc>] (unwind_backtrace+0x0/0xf4) from [<c0012c00>] (show_stack+0x10/0x14)
[   12.056020] [<c0012c00>] (show_stack+0x10/0x14) from [<c02df920>] (rt_spin_lock+0x20/0x60)
[   12.056080] [<c02df920>] (rt_spin_lock+0x20/0x60) from [<c01bc98c>] (gpiod_direction_output+0x50/0x2fc)
[   12.056122] [<c01bc98c>] (gpiod_direction_output+0x50/0x2fc) from [<c02345ac>] (w1_touch_bit+0x64/0xc4)
[   12.056156] [<c02345ac>] (w1_touch_bit+0x64/0xc4) from [<c0234794>] (w1_write_8+0x54/0x7c)
[   12.056196] [<c0234794>] (w1_write_8+0x54/0x7c) from [<c0232a78>] (w1_search+0xa0/0x1e8)
[   12.056239] [<c0232a78>] (w1_search+0xa0/0x1e8) from [<c0233414>] (w1_search_process_cb+0x50/0xe0)
[   12.056280] [<c0233414>] (w1_search_process_cb+0x50/0xe0) from [<c0233570>] (w1_process+0xcc/0xe0)
[   12.056334] [<c0233570>] (w1_process+0xcc/0xe0) from [<c003cf24>] (kthread+0xa0/0xa8)
[   12.056379] [<c003cf24>] (kthread+0xa0/0xa8) from [<c000f3e0>] (ret_from_fork+0x14/0x34)

This happens reproducibly on any access.

Please Cc: me when replying

Thanks
-- 
                                                 Stano
