Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbaBZQGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:06:12 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38357 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbaBZQGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:06:10 -0500
Date: Wed, 26 Feb 2014 11:06:03 -0500 (EST)
Message-Id: <20140226.110603.1107468127601575254.davem@davemloft.net>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 10/16] atm: nicstar: remove
 interruptible_sleep_on_timeout
From: David Miller <davem@davemloft.net>
In-Reply-To: <1393412516-3762435-11-git-send-email-arnd@arndb.de>
References: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
	<1393412516-3762435-11-git-send-email-arnd@arndb.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2014 08:06:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 26 Feb 2014 12:01:50 +0100

> -		spin_unlock_irqrestore(&scq->lock, flags);
> -		interruptible_sleep_on_timeout(&scq->scqfull_waitq,
> -					       SCQFULL_TIMEOUT);
> -		spin_lock_irqsave(&scq->lock, flags);
> +		wait_event_interruptible_lock_irq_timeout(scq->scqfull_waitq,
> +				scq->tail != scq->next, scq->lock,
> +				SCQFULL_TIMEOUT);
>  

When a function call spans multiple lines, please place arguments for
those function calls starting at the first column after the openning
parenthesis.

Thank you.

