Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbaKMJAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 04:00:49 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:47542 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbaKMJAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 04:00:47 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-b2-5464733cdfc2
Message-id: <5464733B.5060505@samsung.com>
Date: Thu, 13 Nov 2014 12:00:43 +0300
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [BUG] index is out of range for nfnl_group2type[]
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t/xy7o2xSkhBvM3alv83dnObDHnfAuL
	xYPNF1ktLvdNY7a4vGsOm8WxBWIWE9adYrGY/uYqswOHx+mmjSweW1beZPJ4+/sEk8fSSQuZ
	PD5vkgtgjeKySUnNySxLLdK3S+DKeHHIumAGT8WWcxeZGxifcnUxcnJICJhI7D7zhxXCFpO4
	cG89G4gtJLCUUeLvzWAIu5lJ4s6fOhCbV0BL4urJa4wgNouAqsSOpw+YQWw2AT2Jf7O2g/WK
	CkRIXFkzhxGiXlDix+R7LF2MXBwiAisYJfZPP8gK4jAL9DFKrL6zDqxKWMBK4vL2Y0CTOIAS
	6hJTpuSChJkF5CU2r3nLPIGRbxaSWbMQqmYhqVrAyLyKUTS1NLmgOCk911CvODG3uDQvXS85
	P3cTIyRwv+xgXHzM6hCjAAejEg/vB+6UECHWxLLiytxDjBIczEoivE06QCHelMTKqtSi/Pii
	0pzU4kOMTBycUg2Mqsa2qyb/WvlF42b5jfww78sTNrouO7g78ENGvs5jVYnU1XKdN/iq/4sx
	2mhs+rBVbw1PHFfGhPQD/HILnZn0zzTPfNc01SN9huf7vs5XVzxFJYRfHt7nbr67yrfiNZvw
	u9KztUc+z9T5611Xxiny+UKIQ+ydPy2Bi1jMUj9sTxE4UnLXiMFeiaU4I9FQi7moOBEAgGH8
	JToCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI I've spotted this:

[  180.202810] ================================================================================
[  180.203600] UBSan: Undefined behaviour in ../net/netfilter/nfnetlink.c:467:28
[  180.204249] index 9 is out of range for type 'int [9]'
[  180.204697] CPU: 0 PID: 1771 Comm: trinity-main Not tainted 3.18.0-rc4-mm1+ #122
[  180.205365] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
[  180.206498]  0000000000000018 0000000000000000 0000000000000009 ffff88007bdf7da8
[  180.207220]  ffffffff82b0ef5f 0000000000000092 ffffffff845ae2e0 ffff88007bdf7db8
[  180.207887]  ffffffff8199e489 ffff88007bdf7e18 ffffffff8199ea22 0000003900000000
[  180.208639] Call Trace:
[  180.208857] dump_stack (lib/dump_stack.c:52)
[  180.209370] ubsan_epilogue (lib/ubsan.c:174)
[  180.209849] __ubsan_handle_out_of_bounds (lib/ubsan.c:400)
[  180.210512] nfnetlink_bind (net/netfilter/nfnetlink.c:467)
[  180.210986] netlink_bind (net/netlink/af_netlink.c:1483)
[  180.211495] SYSC_bind (net/socket.c:1541)
[  180.211940] ? security_socket_setsockopt (security/security.c:1208)
[  180.212541] ? SyS_setsockopt (net/socket.c:1920 net/socket.c:1900)
[  180.213057] ? SyS_write (fs/read_write.c:276 fs/read_write.c:588 fs/read_write.c:577)
[  180.213506] SyS_bind (net/socket.c:1527)
[  180.213919] system_call_fastpath (arch/x86/kernel/entry_64.S:423)
[  180.214479] ================================================================================


