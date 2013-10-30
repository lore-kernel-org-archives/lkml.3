Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab3J3Cmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 22:42:31 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52287 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3J3Cm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 22:42:29 -0400
Date: Tue, 29 Oct 2013 22:42:27 -0400 (EDT)
Message-Id: <20131029.224227.1700872646112764527.davem@davemloft.net>
To: tdmackey@booleanhaiku.com
Cc: mchan@broadcom.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bnx2: Use dev_kfree_skb_any() in bnx2_tx_int()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1383084998-22673-1-git-send-email-tdmackey@booleanhaiku.com>
References: <1383084998-22673-1-git-send-email-tdmackey@booleanhaiku.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 29 Oct 2013 19:42:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Mackey <tdmackey@booleanhaiku.com>
Date: Tue, 29 Oct 2013 15:16:38 -0700

> Using dev_kfree_skb_any() will resolve the below issue when a
> netconsole message is transmitted in an irq.
 ...
> Signed-off-by: David Mackey <tdmackey@booleanhaiku.com>

This is absolutely not the correct fix.

The netpoll facility must invoke ->poll() in an environment which
is compatible, locking and interrupt/soft-interrupt wise, as that
in which it is normally called.

Therefore, bnx2_tx_int(), which is invoked from the driver's ->poll()
method, should not need to use dev_kfree_skb_any().  The real problem
is somewhere else.
