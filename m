Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512Ab3GZUtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:49:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36642 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759967Ab3GZUsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:46 -0400
Date: Fri, 26 Jul 2013 13:48:41 -0700 (PDT)
Message-Id: <20130726.134841.350005683675289021.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: bhutchings@solarflare.com, oliver@neukum.org, grundler@google.com,
        freddy@asix.com.tw, netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, louis@asix.com.tw, allan@asix.com.tw
Subject: Re: [PATCH] usbnet: do not pretend to support SG/TSO
From: David Miller <davem@davemloft.net>
In-Reply-To: <1374624954.3449.61.camel@edumazet-glaptop>
References: <1374623813.3449.52.camel@edumazet-glaptop>
	<1374624310.3449.53.camel@edumazet-glaptop>
	<1374624954.3449.61.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 26 Jul 2013 13:48:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 23 Jul 2013 17:15:54 -0700

> From: Eric Dumazet <edumazet@google.com>
> 
> usbnet doesn't support yet SG, so drivers should not advertise SG or TSO
> capabilities, as they allow TCP stack to build large TSO packets that 
> need to be linearized and might use order-5 pages.
> 
> This adds an extra copy overhead and possible allocation failures.
> 
> Current code ignore skb_linearize() return code so crashes are even
> possible.
> 
> Best is to not pretend SG/TSO is supported, and add this again when/if
> usbnet really supports SG for devices who could get a performance gain.
> 
> Based on a prior patch from Freddy Xin <freddy@asix.com.tw>
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks Eric.
