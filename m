Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbaFKWlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 18:41:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47767 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbaFKWlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 18:41:03 -0400
Date: Wed, 11 Jun 2014 15:41:02 -0700 (PDT)
Message-Id: <20140611.154102.358172856037880938.davem@davemloft.net>
To: ixaphire@qrator.net
Cc: steffen.klassert@secunet.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] ip_vti: fix sparse warnings for VTI_ISVTI
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140611150914.c3cb48bb8a1a760564f5db6e@qrator.net>
References: <20140611150914.c3cb48bb8a1a760564f5db6e@qrator.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Jun 2014 15:41:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Popov <ixaphire@qrator.net>
Date: Wed, 11 Jun 2014 15:09:14 +0400

> This patch fixes the following sparse warnings:
> 
> net/ipv4/ip_tunnel.c:245:53: warning: restricted __be16 degrades to integer
> net/ipv4/ip_vti.c:321:19: warning: incorrect type in assignment (different base types)
> net/ipv4/ip_vti.c:321:19:    expected restricted __be16 [addressable] [assigned] [usertype] i_flags
> net/ipv4/ip_vti.c:321:19:    got int
> net/ipv4/ip_vti.c:447:24: warning: incorrect type in assignment (different base types)
> net/ipv4/ip_vti.c:447:24:    expected restricted __be16 [usertype] i_flags
> net/ipv4/ip_vti.c:447:24:    got int
> 
> Since VTI_ISVTI is always used with ip_tunnel_parm->i_flags (which is __be16),
> we can __force cast VTI_ISVTI to __be16 in header file.
> 
> Signed-off-by: Dmitry Popov <ixaphire@qrator.net>

Applied.
