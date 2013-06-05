Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab3FEIgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 04:36:07 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37000 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab3FEIgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 04:36:04 -0400
Date: Wed, 05 Jun 2013 01:36:01 -0700 (PDT)
Message-Id: <20130605.013601.2203042571724866964.davem@davemloft.net>
To: gang.chen@asianux.com
Cc: David.Laight@ACULAB.COM, andy.shevchenko@gmail.com, edumazet@google.com,
        pshelar@nicira.com, mgorman@suse.de, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bhutchings@solarflare.com
Subject: Re: [PATCH v3] include/linux/skbuff.h: using '(__u16) ~0U' instead
 of '~0U'
From: David Miller <davem@davemloft.net>
In-Reply-To: <51AE8C3E.8060605@asianux.com>
References: <AE90C24D6B3A694183C094C60CF0A2F6026B7263@saturn3.aculab.com>
	<51AE89DE.60106@asianux.com>
	<51AE8C3E.8060605@asianux.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen Gang <gang.chen@asianux.com>
Date: Wed, 05 Jun 2013 08:54:22 +0800

> 
> Both 'transport_header' and 'mac_header' are __u16, which are
> never equal to '~0U'.
> 
> So need use '(__u16) ~0U' instead of '~0U'.
> 
> The related warning (with EXTRA_CFLAGS=-W ARCH=m68k for allmodconfig)
>   include/linux/skbuff.h:1587:2: warning: comparison is always true due to limited range of data type [-Wtype-limits]
>   ...
> 
> Use meaningful macro instead of hard code number, and better to
> initialize 'skb->transport_header' in __alloc_skb_head(), too.
> 
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Your patch doesn't apply to the tree because this has been fixed already
for several days by using "typeof(x) ~0U"
