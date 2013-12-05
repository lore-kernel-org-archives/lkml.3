Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab3LEVb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 16:31:58 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:58116 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab3LEVb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 16:31:56 -0500
Date: Thu, 05 Dec 2013 16:31:54 -0500 (EST)
Message-Id: <20131205.163154.324738047755911916.davem@davemloft.net>
To: ben@decadent.org.uk
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, edumazet@google.com,
        ast@plumgrid.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH 3.12 07/19] tcp: gso: fix truesize tracking
From: David Miller <davem@davemloft.net>
In-Reply-To: <1385616317.23855.75.camel@deadeye.wl.decadent.org.uk>
References: <20131118183644.030738675@linuxfoundation.org>
	<20131118183646.248381899@linuxfoundation.org>
	<1385616317.23855.75.camel@deadeye.wl.decadent.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 05 Dec 2013 13:31:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>
Date: Thu, 28 Nov 2013 05:25:17 +0000

> On Mon, 2013-11-18 at 10:37 -0800, Greg Kroah-Hartman wrote:
>> 3.12-stable review patch.  If anyone has any objections, please let me know.
>> 
>> ------------------
>> 
>> From: Eric Dumazet <edumazet@google.com>
>> 
>> [ Upstream commit 0d08c42cf9a71530fef5ebcfe368f38f2dd0476f ]
>> 
>> commit 6ff50cd55545 ("tcp: gso: do not generate out of order packets")
>> had an heuristic that can trigger a warning in skb_try_coalesce(),
>> because skb->truesize of the gso segments were exactly set to mss.
> [...]
> 
> That commit went in 3.10, but this fix hasn't been applied to 3.10.y.
> 
> David, this code moved from net/ipv4/tcp.c to tcp_offload.c after 3.10
> and this patch applies textually after adjusting the filename.  Please
> consider including it in the next batch of stable fixes for 3.10.

Ok, integrating this one right now, thanks.
