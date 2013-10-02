Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab3JBMUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 08:20:48 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:50580 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754053Ab3JBMUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 08:20:44 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19JqESGEGAZTBJ8Shzl+yXfHFsZLERkcRA=
Date: Wed, 2 Oct 2013 08:20:41 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Miller <davem@davemloft.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] net: mv643xx_eth: fix orphaned statistics timer
 crash
Message-ID: <20131002122041.GJ31178@titan.lakedaemon.net>
References: <1380711442-24735-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1380711442-24735-3-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380711442-24735-3-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 12:57:21PM +0200, Sebastian Hesselbarth wrote:
> The periodic statistics timer gets started at port _probe() time, but
> is stopped on _stop() only. In a modular environment, this can cause
> the timer to access already deallocated memory, if the module is unloaded
> without starting the eth device. To fix this, we add the timer right
> before the port is started, instead of at _probe() time.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: David Miller <davem@davemloft.net>
> Cc: Lennert Buytenhek <buytenh@wantstofly.org>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: netdev@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/net/ethernet/marvell/mv643xx_eth.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Jason Cooper <jason@lakedaemon.net>

Introduced by:

  4ff3495a mv643xx_eth: enforce frequent hardware statistics polling

which also goes all the way back to v2.6.28

thx,

Jason.
