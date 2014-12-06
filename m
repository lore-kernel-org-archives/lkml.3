Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaLFFnx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 00:43:53 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60412 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaLFFnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 00:43:51 -0500
Date: Fri, 05 Dec 2014 21:48:18 -0800 (PST)
Message-Id: <20141205.214818.1275634074992727284.davem@davemloft.net>
To: ast@plumgrid.com
Cc: mingo@kernel.org, luto@amacapital.net, dborkman@redhat.com,
        hannes@stressinduktion.org, edumazet@google.com,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/6] allow eBPF programs to be attached to
 sockets
From: David Miller <davem@davemloft.net>
In-Reply-To: <1417475199-15950-1-git-send-email-ast@plumgrid.com>
References: <1417475199-15950-1-git-send-email-ast@plumgrid.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Dec 2014 21:43:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Mon,  1 Dec 2014 15:06:33 -0800

> V1->V2:
> 
> fixed comments in sample code to state clearly that packet data is accessed
> with LD_ABS instructions and not internal skb fields.
> Also replaced constants in:
> BPF_LD_ABS(BPF_B, 14 + 9 /* R0 = ip->proto */),
> with:
> BPF_LD_ABS(BPF_B, ETH_HLEN + offsetof(struct iphdr, protocol) /* R0 = ip->proto */),
> 
> V1 cover:
> 
> Introduce BPF_PROG_TYPE_SOCKET_FILTER type of eBPF programs that can be
> attached to sockets with setsockopt().
> Allow such programs to access maps via lookup/update/delete helpers.
> 
> This feature was previewed by bpf manpage in commit b4fc1a460f30("Merge branch 'bpf-next'")
> Now it can actually run.
> 
> 1st patch adds LD_ABS/LD_IND instruction verification and
> 2nd patch adds new setsockopt() flag.
> Patches 3-6 are examples in assembler and in C.
> 
> Though native eBPF programs are way more powerful than classic filters
> (attachable through similar setsockopt() call), they don't have skb field
> accessors yet. Like skb->pkt_type, skb->dev->ifindex are not accessible.
> There are sevaral ways to achieve that. That will be in the next set of patches.
> So in this set native eBPF programs can only read data from packet and
> access maps.
> 
> The most powerful example is sockex2_kern.c from patch 6 where ~200 lines of C
> are compiled into ~300 of eBPF instructions.
> It shows how quite complex packet parsing can be done.
> 
> LLVM used to build examples is at https://github.com/iovisor/llvm
> which is fork of llvm trunk that I'm cleaning up for upstreaming.

Series applied, thanks.
