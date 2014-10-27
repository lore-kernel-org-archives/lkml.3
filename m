Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaJ0Tq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:46:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50351 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbaJ0Tq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:46:27 -0400
Date: Mon, 27 Oct 2014 15:46:21 -0400 (EDT)
Message-Id: <20141027.154621.543894481047212079.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] ipx: replace long unsigned int by
 unsigned long
From: David Miller <davem@davemloft.net>
In-Reply-To: <1414433133-29161-1-git-send-email-fabf@skynet.be>
References: <1414433133-29161-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Oct 2014 12:46:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Mon, 27 Oct 2014 19:05:33 +0100

> @@ -90,7 +90,7 @@ static int ipx_seq_route_show(struct seq_file *seq, void *v)
>  	seq_printf(seq, "%08lX   ", (unsigned long int)ntohl(rt->ir_net));
>  	if (rt->ir_routed)
>  		seq_printf(seq, "%08lX     %02X%02X%02X%02X%02X%02X\n",
> -			   (long unsigned int)ntohl(rt->ir_intrfc->if_netnum),
> +			   (unsigned long)ntohl(rt->ir_intrfc->if_netnum),

How about we kill the silly cast altogether and use plain %08X?

Thanks.
