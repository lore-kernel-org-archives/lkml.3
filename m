Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490AbaKRUkC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 15:40:02 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:56651 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076AbaKRUj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 15:39:59 -0500
Date: Tue, 18 Nov 2014 15:39:53 -0500 (EST)
Message-Id: <20141118.153953.1397340325201477025.davem@davemloft.net>
To: ast@plumgrid.com
Cc: mingo@kernel.org, luto@amacapital.net, dborkman@redhat.com,
        hannes@stressinduktion.org, edumazet@google.com,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/7] implementation of eBPF maps
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415929010-9361-1-git-send-email-ast@plumgrid.com>
References: <1415929010-9361-1-git-send-email-ast@plumgrid.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Nov 2014 12:39:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Thu, 13 Nov 2014 17:36:43 -0800

> v1->v2:
> renamed flags for MAP_UPDATE_ELEM command to be more concise,
> clarified commit logs and improved comments in patches 1,3,7
> per discussions with Daniel
>  
> Old v1 cover:
> 
> this set of patches adds implementation of HASH and ARRAY types of eBPF maps
> which were described in manpage in commit b4fc1a460f30("Merge branch 'bpf-next'")
> 
> The difference vs previous version of these patches from August:
> - added 'flags' attribute to BPF_MAP_UPDATE_ELEM
> - in HASH type implementation removed per-map kmem_cache.
>   I was doing kmem_cache_create() for every map to enable selective slub
>   debugging to check for overflows and leaks. Now it's not needed, so just
>   use normal kmalloc() for map elements.
> - added ARRAY type which was mentioned in manpage, but wasn't public yet
> - added map testsuite and removed temporary bits from test_stubs
> 
> Note, eBPF programs cannot be attached to events yet.
> It will come in the next set.

Series applied, thanks Alexei.
