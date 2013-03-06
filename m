Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab3CFEuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 23:50:10 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60751 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab3CFEuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 23:50:08 -0500
Date: Tue, 05 Mar 2013 23:50:06 -0500 (EST)
Message-Id: <20130305.235006.1904081547083683406.davem@davemloft.net>
To: paolo.valente@unimore.it
Cc: jhs@mojatatu.com, shemminger@vyatta.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, fchecconi@gmail.com, rizzo@iet.unipi.it
Subject: Re: [PATCH BUGFIX 0/6] pkt_sched: fix little service anomalies and
 possible crashes of qfq+
From: David Miller <davem@davemloft.net>
In-Reply-To: <1362506702-4985-1-git-send-email-paolo.valente@unimore.it>
References: <20130226.173700.882998504986475149.davem@davemloft.net>
	<1362506702-4985-1-git-send-email-paolo.valente@unimore.it>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 05 Mar 2013 20:50:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo valente <paolo.valente@unimore.it>
Date: Tue,  5 Mar 2013 19:04:56 +0100

> Split, and inserted a detailed description of both the problem and the fix
> in each patch.

Series applied, thanks.

Although two topics for possibly resolving later:

1) That 1ULL bit mask fix is quite expensive on 32-bit, it would
   probably be cheaper to test for that case using a helper function
   that nops out on 64-bit.  Although this is not so important.

2) That static inline forward declaration is ugly, better to remove
   the inline tag (let the compiler handle it) or move the function
   above all the call sites.
