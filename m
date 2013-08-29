Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab3H2TMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 15:12:10 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37102 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab3H2TMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 15:12:08 -0400
Date: Thu, 29 Aug 2013 15:12:05 -0400 (EDT)
Message-Id: <20130829.151205.2070859347984247313.davem@davemloft.net>
To: avagin@openvz.org
Cc: netdev@vger.kernel.org, gorcunov@openvz.org, linux-kernel@vger.kernel.org,
        xemul@parallels.com, eric.dumazet@gmail.com, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net
Subject: Re: [PATCH] tcp: initialize rcv_tstamp for restored sockets
From: David Miller <davem@davemloft.net>
In-Reply-To: <1377591640-1660-1-git-send-email-avagin@openvz.org>
References: <1377591640-1660-1-git-send-email-avagin@openvz.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 29 Aug 2013 12:12:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Vagin <avagin@openvz.org>
Date: Tue, 27 Aug 2013 12:20:40 +0400

> From: Andrew Vagin <avagin@openvz.org>
> 
> u32 rcv_tstamp;     /* timestamp of last received ACK */
> 
> Its value used in tcp_retransmit_timer, which closes socket
> if the last ack was received more then TCP_RTO_MAX ago.
> 
> Currently rcv_tstamp is initialized to zero and if tcp_retransmit_timer
> is called before receiving a first ack, the connection is closed.
> 
> This patch initializes rcv_tstamp to a timestamp, when a socket was
> restored.
> 
> Reported-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Signed-off-by: Andrey Vagin <avagin@openvz.org>

Applied and queued up for -stable.
