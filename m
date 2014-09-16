Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbaIPUy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:54:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58390 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596AbaIPUyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:54:55 -0400
Date: Tue, 16 Sep 2014 16:54:52 -0400 (EDT)
Message-Id: <20140916.165452.1747695341192703967.davem@davemloft.net>
To: ast@plumgrid.com
Cc: mingo@kernel.org, torvalds@linux-foundation.org, luto@amacapital.net,
        dborkman@redhat.com, hannes@stressinduktion.org, chema@google.com,
        edumazet@google.com, a.p.zijlstra@chello.nl, pablo@netfilter.org,
        hpa@zytor.com, akpm@linux-foundation.org, keescook@chromium.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 net-next 03/11] bpf: add
 lookup/update/delete/iterate methods to BPF maps
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAMEtUuxp6709mdygiQyCqwjv-0kF-CbNOzCCZmKw_mUckF4NZA@mail.gmail.com>
References: <1410808721-27493-4-git-send-email-ast@plumgrid.com>
	<20140916.151606.448751391205382097.davem@davemloft.net>
	<CAMEtUuxp6709mdygiQyCqwjv-0kF-CbNOzCCZmKw_mUckF4NZA@mail.gmail.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 16 Sep 2014 13:54:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Tue, 16 Sep 2014 13:44:12 -0700

> the union indeed changes alignment from patch #1 to #3,
> but, imo, it is not a problem, since kernel does:

It changes the alignment of the datastructures in userspace.

> I haven't thought of 'aligned_u64' for this case.
> For counters and masks it would be perfect, but here user is
> passing real pointers to key and value, so they have to
> be 'void __user *', otherwise user would need to type cast
> them, which I want to avoid.

The cost of the compat layer must be considered and weighted
against this cast, which I think is really no big deal.

> I think compat layer is a better option.

It's overhead you'll have to support forever, I think you should
reconsider.

All of the "ugly casting" will be hidden, or can be hidden, in the
syscall wrappers and/or interfaces in userspace.
