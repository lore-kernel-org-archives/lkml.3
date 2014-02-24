Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbaBXXRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 18:17:53 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58577 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbaBXXRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 18:17:50 -0500
Date: Tue, 25 Feb 2014 00:17:48 +0100
From: Borislav Petkov <bp@alien8.de>
To: Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc: Francois Romieu <romieu@fr.zoreil.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: r8169: INFO: trying to register non-static key.
Message-ID: <20140224231748.GA18598@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get this on latest -rc4 + tip/master:

[    9.172287] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    9.178461] r8169 0000:02:00.0: can't disable ASPM; OS doesn't have ASPM control
[    9.186137] r8169 0000:02:00.0: irq 45 for MSI/MSI-X
[    9.195943] INFO: trying to register non-static key.
[    9.196031] the code is fine but needs lockdep annotation.
[    9.196031] turning off the locking correctness validator.
[    9.196031] CPU: 1 PID: 933 Comm: modprobe Not tainted 3.14.0-rc4+ #1
[    9.196031] Hardware name: Acer AOA150/        , BIOS v0.3309 10/06/2008
[    9.196031]  00000000 00000000 f5e49a48 c15aa25c c1c68b58 f5e49ac0 c10913fc c174bc50
[    9.196031]  0001488a 79da0cc3 00000000 00000006 f5efa6d0 c1a34240 00000001 f6eab240
[    9.196031]  f5e49aa8 c107a4e6 00000000 f6eab250 f5d43658 00000002 000d48ae 00000000
[    9.196031] Call Trace:
[    9.196031]  [<c15aa25c>] dump_stack+0x4b/0x75
[    9.196031]  [<c10913fc>] __lock_acquire+0x1a0c/0x1b70
[    9.196031]  [<c107a4e6>] ? sched_clock_local+0x46/0x150
[    9.196031]  [<c107a8a8>] ? sched_clock_cpu+0xc8/0x140
[    9.196031]  [<c1091bdb>] lock_acquire+0x8b/0x1b0
[    9.196031]  [<c14fab4b>] ? dev_get_stats+0x5b/0x100
[    9.196031]  [<f81f1db6>] rtl8169_get_stats64+0x66/0x240 [r8169]
[    9.196031]  [<c14fab4b>] ? dev_get_stats+0x5b/0x100
[    9.196031]  [<c14fab4b>] dev_get_stats+0x5b/0x100
[    9.196031]  [<c151163f>] rtnl_fill_ifinfo+0x4cf/0xb30
[    9.196031]  [<c1134c43>] ? ksize+0x13/0xa0
[    9.196031]  [<c14f1827>] ? __alloc_skb+0x77/0x250
[    9.196031]  [<c1511d12>] rtmsg_ifinfo+0x72/0xf0
[    9.196031]  [<c150531e>] register_netdevice+0x45e/0x4c0
[    9.196031]  [<c150539b>] register_netdev+0x1b/0x30
[    9.196031]  [<f81f3e8b>] rtl_init_one+0x69b/0xbd0 [r8169]
[    9.337799] uhci_hcd: USB Universal Host Controller Interface driver


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
