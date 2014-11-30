Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaK3E5v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 23:57:51 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54850 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbaK3E5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 23:57:49 -0500
Date: Sat, 29 Nov 2014 21:01:58 -0800 (PST)
Message-Id: <20141129.210158.2021042941461629799.davem@davemloft.net>
To: ast@plumgrid.com
Cc: mingo@kernel.org, luto@amacapital.net, dborkman@redhat.com,
        hannes@stressinduktion.org, edumazet@google.com,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/6] samples: bpf: example of stateful socket
 filtering
From: David Miller <davem@davemloft.net>
In-Reply-To: <1417066951-1999-4-git-send-email-ast@plumgrid.com>
References: <1417066951-1999-1-git-send-email-ast@plumgrid.com>
	<1417066951-1999-4-git-send-email-ast@plumgrid.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Nov 2014 20:57:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Wed, 26 Nov 2014 21:42:28 -0800

> this socket filter example does:
> - creates arraymap in kernel with key 4 bytes and value 8 bytes
> 
> - loads eBPF program:
>   r0 = skb[14 + 9]; // load one byte of ip->proto
 ...
> +		BPF_LD_ABS(BPF_B, 14 + 9 /* R0 = ip->proto */),

I do not want anything having to do with fixed offsets from
the skb.

Nothing should know where things are in the SKB structure,
especially user facing things.

That's why we have explicit BPF operations for fetching
specific SKB members, so that the layout is completely
transparent to the entity generating BPF programs.

Besides retaining the flexibility of changing the SKB
layout arbitrarily without breaking bpf programs, there
are also security considerations from allowing bpf
programs to load arbitrary offsets.

Sorry, I do not like this patch series at all.
