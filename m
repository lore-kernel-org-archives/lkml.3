Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbaDGTGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 15:06:18 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57096 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbaDGTGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 15:06:14 -0400
Date: Mon, 07 Apr 2014 15:06:11 -0400 (EDT)
Message-Id: <20140407.150611.1998010372710875030.davem@davemloft.net>
To: kumaran.4353@gmail.com
Cc: netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net IPv6]: Fix maximum IPv6 address limit violation
From: David Miller <davem@davemloft.net>
In-Reply-To: <533FEE9B.5090806@gmail.com>
References: <533FEE9B.5090806@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Balakumaran Kannan <kumaran.4353@gmail.com>
Date: Sat, 05 Apr 2014 17:22:59 +0530

> +#ifdef CONFIG_IPV6_PRIVACY
> +           /* When IPv6 privacy extension is enabled, there must
> +            * be two IPv6 address slots available.
> +            * - One for MAC based address
> +            * - Another for temporary address
> +            */
> +           if (max_addresses > 1)
> +               max_addresses--;
> +#endif
>             if (!max_addresses ||
>                 ipv6_count_addresses(in6_dev) < max_addresses)
>                 ifp = ipv6_add_addr(in6_dev, &addr, NULL,
> -- 
> 1.7.9.5
> 

Your claim is that you're shooting for accurate policy enforcement, but even
you patch doesn't do this.

You are not taking into account whether temporary addresses will even be
created.

An accurate implementation would duplicate all of the special checks that
manage_tempaddrs() does to determine whether a temporary address will be
created or not.  In particular, it needs to check if the device is even
configured to use tempaddrs.
