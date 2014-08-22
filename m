Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818AbaHVRzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 13:55:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52630 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932487AbaHVRzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 13:55:38 -0400
Date: Fri, 22 Aug 2014 10:55:37 -0700 (PDT)
Message-Id: <20140822.105537.779696105209269317.davem@davemloft.net>
To: bebl@mageta.org
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hannes@redhat.com
Subject: Re: [PATCH v2] net: ipv6: fib: don't sleep inside atomic lock
From: David Miller <davem@davemloft.net>
In-Reply-To: <1408642668-5808-1-git-send-email-bebl@mageta.org>
References: <20140821143103.GA25021@kalium.Speedport_W723_V_Typ_A_1_01_001>
	<1408642668-5808-1-git-send-email-bebl@mageta.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 Aug 2014 10:55:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Block <bebl@mageta.org>
Date: Thu, 21 Aug 2014 19:37:48 +0200

> The function fib6_commit_metrics() allocates a piece of memory in mode
> GFP_KERNEL while holding an atomic lock from higher up in the stack, in
> the function __ip6_ins_rt(). This produces the following BUG:
 ...
> Fixing this by replacing the mode GFP_KERNEL with GFP_ATOMIC.
> 
> Signed-off-by: Benjamin Block <bebl@mageta.org>

Applied, thanks.
