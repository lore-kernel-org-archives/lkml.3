Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837Ab3HTUIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 16:08:21 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46412 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab3HTUIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 16:08:19 -0400
Date: Tue, 20 Aug 2013 13:08:18 -0700 (PDT)
Message-Id: <20130820.130818.1803264305462032520.davem@davemloft.net>
To: avagin@openvz.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net
Subject: Re: [PATCH] tcp: set timestamps for restored skb-s
From: David Miller <davem@davemloft.net>
In-Reply-To: <1376665476-9683-1-git-send-email-avagin@openvz.org>
References: <1376665476-9683-1-git-send-email-avagin@openvz.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 20 Aug 2013 13:08:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Vagin <avagin@openvz.org>
Date: Fri, 16 Aug 2013 19:04:36 +0400

> When the repair mode is turned off, the write queue seqs are
> updated so that the whole queue is considered to be 'already sent.
> 
> The "when" field must be set for such skb. It's used in tcp_rearm_rto
> for example. If the "when" field isn't set, the retransmit timeout can
> be calculated incorrectly and a tcp connected can stop for two minutes
> (TCP_RTO_MAX).
> 
> Acked-by: Pavel Emelyanov <xemul@parallels.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> Cc: James Morris <jmorris@namei.org>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: Patrick McHardy <kaber@trash.net>
> Signed-off-by: Andrey Vagin <avagin@openvz.org>

Applied and queued up for -stable, thanks.
