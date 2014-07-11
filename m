Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbaGKUiO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 16:38:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57321 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbaGKUiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 16:38:08 -0400
Date: Fri, 11 Jul 2014 13:38:04 -0700 (PDT)
Message-Id: <20140711.133804.1326652193045308255.davem@davemloft.net>
To: khoroshilov@ispras.ru
Cc: kevin.curtis@farsite.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH v2] farsync: fix invalid memory accesses in
 fst_add_one() and fst_init_card()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1405032181-5342-1-git-send-email-khoroshilov@ispras.ru>
References: <20140708.162027.1804045121900039101.davem@davemloft.net>
	<1405032181-5342-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 11 Jul 2014 13:38:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Date: Thu, 10 Jul 2014 18:43:01 -0400

> There are several issues in fst_add_one() and fst_init_card():
> - invalid pointer dereference at card->ports[card->nports - 1] if
>   register_hdlc_device() fails for the first port in fst_init_card();
> - fst_card_array overflow at fst_card_array[no_of_cards_added]
>   because there is no checks for array overflow;
> - use after free because pointer to deallocated card is left in fst_card_array
>   if something fails after fst_card_array[no_of_cards_added] = card;
> - several leaks on failure paths in fst_add_one().
> 
> The patch fixes all the issues and makes code more readable.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Applied, thanks Alexey.
