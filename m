Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597Ab3KRUSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 15:18:04 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49621 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab3KRUSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 15:18:01 -0500
Date: Mon, 18 Nov 2013 15:17:56 -0500 (EST)
Message-Id: <20131118.151756.1326189931009402407.davem@davemloft.net>
To: govindarajulu90@gmail.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, IvDoorn@gmail.com, sbhatewara@vmware.com,
        samuel@sortiz.org, chas@cmf.nrl.navy.mil, roland@kernel.org,
        isdn@linux-pingi.de, jcliburn@gmail.com, benve@cisco.com,
        ssujith@cisco.com, jeffrey.t.kirsher@intel.com,
        jesse.brandeburg@intel.com, shahed.shaikh@qlogic.com, joe@perches.com,
        apw@canonical.com
Subject: Re: [PATCH net-next 02/13] driver: net: remove unnecessary skb
 NULL check before calling dev_kfree_skb_irq
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.03.1311190055150.10646@gmail.com>
References: <20131104.151230.1978898006990867916.davem@davemloft.net>
	<alpine.LNX.2.03.1311111537020.2363@cisco.com>
	<alpine.LNX.2.03.1311190055150.10646@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 18 Nov 2013 12:18:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Govindarajulu Varadarajan <govindarajulu90@gmail.com>
Date: Tue, 19 Nov 2013 00:56:48 +0530 (IST)

> Did you have a chance to look at this? Let me know how you want me to
> fix this.

I said clearly that I don't want this change to be made, because in many
cases the "= NULL" assignment in the driver is desirable to elide when it
isn't necessary because the value is already NULL.  Therefore the NULL
check in dev_kfree_skb_irq() is basically coming for free.

Yes there are other cases, but it really doesn't matter enough to justify
your change.

Thanks.
