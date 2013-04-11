Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab3DKUCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:02:39 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38691 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab3DKUCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:02:38 -0400
Date: Thu, 11 Apr 2013 16:02:31 -0400 (EDT)
Message-Id: <20130411.160231.1367130064866607872.davem@davemloft.net>
To: dp@highloadlab.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] tcp: incoming connections might use wrong route
 under synflood
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130411225507.427b369046e53d03222b8fd3@highloadlab.com>
References: <20130411225507.427b369046e53d03222b8fd3@highloadlab.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 11 Apr 2013 13:02:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Popov <dp@highloadlab.com>
Date: Thu, 11 Apr 2013 22:55:07 +0400

> There is a bug in cookie_v4_check (net/ipv4/syncookies.c):
> 	flowi4_init_output(&fl4, 0, sk->sk_mark, RT_CONN_FLAGS(sk),
> 			   RT_SCOPE_UNIVERSE, IPPROTO_TCP,
> 			   inet_sk_flowi_flags(sk),
> 			   (opt && opt->srr) ? opt->faddr : ireq->rmt_addr,
> 			   ireq->loc_addr, th->source, th->dest);
> 
> Here we do not respect sk->sk_bound_dev_if, therefore wrong dst_entry may be
> taken. This dst_entry is used by new socket (get_cookie_sock -> 
> tcp_v4_syn_recv_sock), so its packets may take the wrong path.
> 
> Signed-off-by: Dmitry Popov <dp@highloadlab.com>

Applied.
