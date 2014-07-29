Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbaG2WrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 18:47:10 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49939 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbaG2WrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 18:47:08 -0400
Date: Tue, 29 Jul 2014 15:47:07 -0700 (PDT)
Message-Id: <20140729.154707.2014852273209594700.davem@davemloft.net>
To: himangi774@gmail.com
Cc: samuel@sortiz.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH] net: irda: delete double assignment
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140728152812.GA3000@himangi-Dell>
References: <20140728152812.GA3000@himangi-Dell>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Jul 2014 15:47:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>
Date: Mon, 28 Jul 2014 20:58:12 +0530

> @@ -621,7 +621,6 @@ void irlap_send_rd_frame(struct irlap_cb *self)
>  
>  	frame = (struct rd_frame *)skb_put(tx_skb, 2);
>  
> -	frame->caddr = self->caddr;
>  	frame->caddr = RD_RSP | PF_BIT;
>  

This doesn't look correct to me.

I think both lines should be kept, and the second line should be
changed to assign those bits to frame->control.

This is consistent with other parts of the file that make use of the PF_BIT.
