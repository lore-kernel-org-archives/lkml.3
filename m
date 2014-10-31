Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318AbaJaURQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:17:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43277 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbaJaURO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:17:14 -0400
Date: Fri, 31 Oct 2014 16:17:12 -0400 (EDT)
Message-Id: <20141031.161712.591711555593004517.davem@davemloft.net>
To: lsorense@csclub.uwaterloo.ca
Cc: linux-kernel@vger.kernel.org, hs@denx.de, mugunthanvnm@ti.com,
        netdev@vger.kernel.org
Subject: Re: drivers: net: cpsw: Fix broken loop condition in switch mode
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141031172854.GJ24110@csclub.uwaterloo.ca>
References: <20141031172854.GJ24110@csclub.uwaterloo.ca>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 Oct 2014 13:17:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Fri, 31 Oct 2014 13:28:54 -0400

> 0d961b3b52f566f823070ce2366511a7f64b928c (drivers: net: cpsw: fix buggy
> loop condition) accidentally fixed a loop comparison in too many places
> while fixing a real bug.
> 
> It was correct to fix the dual_emac mode section since there 'i' is used
> as an index into priv->slaves which is a 0 based array.
> 
> However the other two changes (which are only used in switch mode)
> are wrong since there 'i' is actually the ALE port number, and port 0
> is the host port, while port 1 and up are the slave ports.
> 
> Putting the loop condition back in the switch mode section fixes it.
> 
> A comment has been added to point out the intent clearly to avoid future
> confusion.  Also a comment is fixed that said the opposite of what was
> actually happening.
> 
> Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>
> Acked-by: Heiko Schocher <hs@denx.de>

Applied.
