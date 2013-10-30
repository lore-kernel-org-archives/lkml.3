Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab3J3GkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 02:40:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53450 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab3J3GkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 02:40:07 -0400
Date: Wed, 30 Oct 2013 02:40:03 -0400 (EDT)
Message-Id: <20131030.024003.1476890051483056287.davem@davemloft.net>
To: xiyou.wangcong@gmail.com
Cc: tdmackey@booleanhaiku.com, mchan@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bnx2: Use dev_kfree_skb_any() in bnx2_tx_int()
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAM_iQpXzJOxZ3MFNthKw5ye=WcxDWbiPaHuL=pHMz7D1R4nJ+w@mail.gmail.com>
References: <1383084998-22673-1-git-send-email-tdmackey@booleanhaiku.com>
	<20131029.224227.1700872646112764527.davem@davemloft.net>
	<CAM_iQpXzJOxZ3MFNthKw5ye=WcxDWbiPaHuL=pHMz7D1R4nJ+w@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 29 Oct 2013 23:40:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Tue, 29 Oct 2013 20:50:08 -0700

> Normally ->poll() is called in softirq context, while netpoll could
> be called in any context depending on its caller.

It still makes amends to make the execution context still looks
"compatible" as far as locking et al. is concerned.
