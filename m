Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaKQIQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 03:16:22 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:47729 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaKQIQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 03:16:20 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-da-5469aed2dc61
Message-id: <5469AED1.3000000@samsung.com>
Date: Mon, 17 Nov 2014 11:16:17 +0300
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] index is out of range for nfnl_group2type[]
References: <5464733B.5060505@samsung.com> <20141114174438.GA10644@salvia>
In-reply-to: <20141114174438.GA10644@salvia>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t/xa7qX1mWGGExsZrL4u7Od2WLO+RYW
	iwebL7JaXO6bxmxxedccNotjC8QsJqw7xWIx/c1VZgcOj9NNG1k8tqy8yeTx9vcJJo+lkxYy
	eXzeJBfAGsVlk5Kak1mWWqRvl8CVsf1yK3PBM76KdVMusTQwPuXpYuTkkBAwkdi78y4LhC0m
	ceHeerYuRi4OIYGljBI7Jr5nhXCamSTerZsPVsUroCVxaO4aRhCbRUBVYv77LnYQm01AT+Lf
	rO1sILaoQITElTVzGCHqBSV+TL4H1isioC3RfqOVBWQos0Avk8Si9Y1gCWEBO4n1P2azgthC
	Al4S1zc8BBvKKaAjMXd/H1CcA6hBT+L+RS2QMLOAvMTmNW+ZJzAKzEKyYhZC1SwkVQsYmVcx
	iqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihAT7lx2Mi49ZHWIU4GBU4uF90JcZIsSaWFZcmXuI
	UYKDWUmEd/1qoBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZGm1ffy1Knx/wR/dxQkdtSmm51Jjpo
	N1PbBZ8du03rXllOWJN4cJGpz6e3jzdNt7ny90bOjhLW19sYQhY+uvV97VLhx675CW+PSNfl
	zPTcmldjuK9i941Cpzd86x+8UFI7H/1Q/N2rR+taPZ0ZlplWvV9/P/FNiqmLw/zkON7Dm6eU
	fvrYc8eAT4mlOCPRUIu5qDgRAMHLv1xUAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2014 08:44 PM, Pablo Neira Ayuso wrote:
> On Thu, Nov 13, 2014 at 12:00:43PM +0300, Andrey Ryabinin wrote:
>> FYI I've spotted this:
>>
>> [  180.202810] ================================================================================
>> [  180.203600] UBSan: Undefined behaviour in ../net/netfilter/nfnetlink.c:467:28
>> [  180.204249] index 9 is out of range for type 'int [9]'
>> [  180.204697] CPU: 0 PID: 1771 Comm: trinity-main Not tainted 3.18.0-rc4-mm1+ #122
>> [  180.205365] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
>> [  180.206498]  0000000000000018 0000000000000000 0000000000000009 ffff88007bdf7da8
>> [  180.207220]  ffffffff82b0ef5f 0000000000000092 ffffffff845ae2e0 ffff88007bdf7db8
>> [  180.207887]  ffffffff8199e489 ffff88007bdf7e18 ffffffff8199ea22 0000003900000000
>> [  180.208639] Call Trace:
>> [  180.208857] dump_stack (lib/dump_stack.c:52)
>> [  180.209370] ubsan_epilogue (lib/ubsan.c:174)
>> [  180.209849] __ubsan_handle_out_of_bounds (lib/ubsan.c:400)
>> [  180.210512] nfnetlink_bind (net/netfilter/nfnetlink.c:467)
>> [  180.210986] netlink_bind (net/netlink/af_netlink.c:1483)
>> [  180.211495] SYSC_bind (net/socket.c:1541)
>> [  180.211940] ? security_socket_setsockopt (security/security.c:1208)
>> [  180.212541] ? SyS_setsockopt (net/socket.c:1920 net/socket.c:1900)
>> [  180.213057] ? SyS_write (fs/read_write.c:276 fs/read_write.c:588 fs/read_write.c:577)
>> [  180.213506] SyS_bind (net/socket.c:1527)
>> [  180.213919] system_call_fastpath (arch/x86/kernel/entry_64.S:423)
>> [  180.214479] ================================================================================
> 
> Thanks for reporting. I think the attached patch fixes this problem.
> 

Yep, It's gone away after applying your patch.

Thanks,
Andrey.

