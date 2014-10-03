Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434AbaJCWGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:06:08 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60091 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbaJCWGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:06:02 -0400
Date: Fri, 03 Oct 2014 15:08:07 -0700 (PDT)
Message-Id: <20141003.150807.1695488392631084970.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next] r8152: nway reset after setting eee
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-54-Taiwan-albertk@realtek.com>
References: <1394712342-15778-54-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Oct 2014 15:06:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Thu, 2 Oct 2014 16:01:22 +0800

> @@ -3480,6 +3480,9 @@ rtl_ethtool_set_eee(struct net_device *net, struct ethtool_eee *edata)
>  
>  	ret = tp->rtl_ops.eee_set(tp, edata);
>  
> +	if (ret == 0)
> +		ret = mii_nway_restart(&tp->mii);

Please test this canonically as "if (!ret)" and delete the empty line between the function
call and the return value test.

Thank you.
