Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab3E0UTD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 16:19:03 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40938 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756959Ab3E0UTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 16:19:01 -0400
Date: Mon, 27 May 2013 13:18:57 -0700 (PDT)
Message-Id: <20130527.131857.945196320286011406.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: sebastian.hesselbarth@gmail.com, buytenh@wantstofly.org,
        jason@lakedaemon.net, andrew@lunn.ch, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org
Subject: Re: [PATCH 1/2] ARM: kirkwood: proper retain MAC address
 workaround on DT ethernet
From: David Miller <davem@davemloft.net>
In-Reply-To: <1369655404.3557.33.camel@pasglop>
References: <1369647565.3557.28.camel@pasglop>
	<51A33447.80305@gmail.com>
	<1369655404.3557.33.camel@pasglop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Mon, 27 May 2013 21:50:04 +1000

> It would be handy to be able to just do something like
> 
> 	of_set_property(node, name, ptr, len);
> 
> However, that wouldn't help much with the allocation/leak problem,
> though at least it would be easier to use. It could also *try* to re-use
> the current allocation if the new content is of smaller or equal size.

And this is so much better of an interface because it allows the
OF implementation to decide how to deal with memory allocation
and freeing.
