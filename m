Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab3H2TMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 15:12:18 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37117 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302Ab3H2TMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 15:12:16 -0400
Date: Thu, 29 Aug 2013 15:12:13 -0400 (EDT)
Message-Id: <20130829.151213.1901946252095108600.davem@davemloft.net>
To: avagin@openvz.org
Cc: netdev@vger.kernel.org, gorcunov@openvz.org, linux-kernel@vger.kernel.org,
        xemul@parallels.com, eric.dumazet@gmail.com, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net
Subject: Re: [PATCH] tcp: don't apply tsoffset if rcv_tsecr is zero
From: David Miller <davem@davemloft.net>
In-Reply-To: <1377591715-1742-1-git-send-email-avagin@openvz.org>
References: <1377591715-1742-1-git-send-email-avagin@openvz.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 29 Aug 2013 12:12:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Vagin <avagin@openvz.org>
Date: Tue, 27 Aug 2013 12:21:55 +0400

> From: Andrew Vagin <avagin@openvz.org>
> 
> The zero value means that tsecr is not valid, so it's a special case.
> 
> tsoffset is used to customize tcp_time_stamp for one socket.
> tsoffset is usually zero, it's used when a socket was moved from one
> host to another host.
> 
> Currently this issue affects logic of tcp_rcv_rtt_measure_ts. Due to
> incorrect value of rcv_tsecr, tcp_rcv_rtt_measure_ts sets rto to
> TCP_RTO_MAX.
> 
> Reported-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Signed-off-by: Andrey Vagin <avagin@openvz.org>

Applied and queued up for -stable.
