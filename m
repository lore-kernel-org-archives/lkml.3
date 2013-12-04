Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881Ab3LDWr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 17:47:26 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:44442 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756177Ab3LDWrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 17:47:22 -0500
Date: Wed, 4 Dec 2013 17:47:15 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Glauber Costa <glommer@gmail.com>, netdev@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: 2e685cad5790 build warning
Message-ID: <20131204224715.GD21724@cmpxchg.org>
References: <20131204222943.GC21724@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131204222943.GC21724@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ botched linux-kernel address in the first try ]

On Wed, Dec 04, 2013 at 05:29:43PM -0500, Johannes Weiner wrote:
> Hi Eric,
> 
> commit 2e685cad57906e19add7189b5ff49dfb6aaa21d3
> Author: Eric W. Biederman <ebiederm@xmission.com>
> Date:   Sat Oct 19 16:26:19 2013 -0700
> 
>     tcp_memcontrol: Kill struct tcp_memcontrol
>     
>     Replace the pointers in struct cg_proto with actual data fields and kill
>     struct tcp_memcontrol as it is not fully redundant.
>     
>     This removes a confusing, unnecessary layer of abstraction.
>     
>     Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> triggers a build warning because it removed the only reference to a
> function but not the function itself:
> 
> linux/net/ipv4/tcp_memcontrol.c:9:13: warning: ‘memcg_tcp_enter_memory_pressure’ defined but not used [-Wunused-function]
>  static void memcg_tcp_enter_memory_pressure(struct sock *sk)
> 
> I can not see from the changelog why this function is no longer used,
> or who is supposed to now set cg_proto->memory_pressure which you
> still initialize etc.  Either way, the current state does not seem to
> make much sense.  The author would be the best person to double check
> such changes, but he wasn't copied on your patch, so I copied him now.
> 
> Apologies if this has been brought up before, I could not find any
> reference on LKML of either this patch or a report of this warning.
> 
> Thanks!
