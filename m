Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbaDNRbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:31:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56454 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaDNRbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:31:02 -0400
Date: Mon, 14 Apr 2014 13:31:00 -0400 (EDT)
Message-Id: <20140414.133100.2108506432746999980.davem@davemloft.net>
To: zhen-hual@hp.com
Cc: kas@fi.muni.cz, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] driver/net: remove unused code in cosa module
From: David Miller <davem@davemloft.net>
In-Reply-To: <1397470116-19669-1-git-send-email-zhen-hual@hp.com>
References: <1397470116-19669-1-git-send-email-zhen-hual@hp.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 14 Apr 2014 10:31:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Li, Zhen-Hua" <zhen-hual@hp.com>
Date: Mon, 14 Apr 2014 18:08:36 +0800

> For the cosa module, CONFIG_COSA can only be checked as 'm',
> and cosa module can only be compiled as a module.

That's not true, it's "tristate" in drivers/net/wan/Kconfig so it
could be set to 'y' too.

But there is another reason to make this change, because for such
large timeout values only msleep() makes sense, udelay() could
overflow it's internal precision.

Please resubmit this with the proper reasoning and commit message.
