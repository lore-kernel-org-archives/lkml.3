Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbbAWKQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:16:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768AbbAWKQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 05:16:06 -0500
Message-ID: <54C21F59.3000100@redhat.com>
Date: Fri, 23 Jan 2015 11:15:53 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexei Starovoitov <ast@plumgrid.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/2] bpf: rcu lock must not be held when calling copy_to_user()
References: <1421975469-13035-1-git-send-email-ast@plumgrid.com> <1421975469-13035-2-git-send-email-ast@plumgrid.com>
In-Reply-To: <1421975469-13035-2-git-send-email-ast@plumgrid.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2015 02:11 AM, Alexei Starovoitov wrote:
> BUG: sleeping function called from invalid context at mm/memory.c:3732
> in_atomic(): 0, irqs_disabled(): 0, pid: 671, name: test_maps
> 1 lock held by test_maps/671:
>   #0:  (rcu_read_lock){......}, at: [<0000000000264190>] map_lookup_elem+0xe8/0x260
> Call Trace:
> ([<0000000000115b7e>] show_trace+0x12e/0x150)
>   [<0000000000115c40>] show_stack+0xa0/0x100
>   [<00000000009b163c>] dump_stack+0x74/0xc8
>   [<000000000017424a>] ___might_sleep+0x23a/0x248
>   [<00000000002b58e8>] might_fault+0x70/0xe8
>   [<0000000000264230>] map_lookup_elem+0x188/0x260
>   [<0000000000264716>] SyS_bpf+0x20e/0x840
>
> Fix it by allocating temporary buffer to store map element value.
>
> Fixes: db20fd2b0108 ("bpf: add lookup/update/delete/iterate methods to BPF maps")
> Reported-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>

Looks good to me.

Acked-by: Daniel Borkmann <dborkman@redhat.com>
