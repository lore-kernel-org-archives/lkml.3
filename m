Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbaJBBbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 21:31:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38717 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbaJBBbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 21:31:13 -0400
Date: Wed, 01 Oct 2014 21:31:10 -0400 (EDT)
Message-Id: <20141001.213110.1976557946620505084.davem@davemloft.net>
To: ast@plumgrid.com
Cc: mingo@kernel.org, torvalds@linux-foundation.org, luto@amacapital.net,
        dborkman@redhat.com, hannes@stressinduktion.org, chema@google.com,
        edumazet@google.com, a.p.zijlstra@chello.nl, pablo@netfilter.org,
        hpa@zytor.com, akpm@linux-foundation.org, keescook@chromium.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] bpf: add search pruning optimization and
 tests
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412041802-24858-1-git-send-email-ast@plumgrid.com>
References: <1412041802-24858-1-git-send-email-ast@plumgrid.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Oct 2014 18:31:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Mon, 29 Sep 2014 18:50:00 -0700

> patch #1 commit log explains why eBPF verifier has to examine some
> instructions multiple times and describes the search pruning optimization
> that improves verification speed for branchy programs and allows more
> complex programs to be verified successfully.
> This patch completes the core verifier logic.
> 
> patch #2 adds more verifier tests related to branches and search pruning
> 
> I'm still working on Andy's 'bitmask for stack slots' suggestion. It will be
> done on top of this patch.
> 
> The current verifier algorithm is brute force depth first search with
> state pruning. If anyone can come up with another algorithm that demonstrates
> better results, we'll replace the algorithm without affecting user space.
> 
> Note verifier doesn't guarantee that all possible valid programs are accepted.
> Overly complex programs may still be rejected.
> Verifier improvements/optimizations will guarantee that if a program
> was passing verification in the past, it will still be passing.

Series applied, thanks.
