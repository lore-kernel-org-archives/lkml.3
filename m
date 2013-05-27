Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab3E0WR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 18:17:59 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43121 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757298Ab3E0WR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 18:17:57 -0400
Date: Mon, 27 May 2013 15:17:44 -0700 (PDT)
Message-Id: <20130527.151744.1526437556583356156.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: arnd@arndb.de, linuxppc-dev@lists.ozlabs.org,
        sebastian.hesselbarth@gmail.com, andrew@lunn.ch, jason@lakedaemon.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        buytenh@wantstofly.org, grant.likely@linaro.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: kirkwood: proper retain MAC address
 workaround on DT ethernet
From: David Miller <davem@davemloft.net>
In-Reply-To: <1369691406.3557.35.camel@pasglop>
References: <1369655404.3557.33.camel@pasglop>
	<2255648.0KEmXfjCx5@wuerfel>
	<1369691406.3557.35.camel@pasglop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 28 May 2013 07:50:06 +1000

> On Mon, 2013-05-27 at 14:47 +0200, Arnd Bergmann wrote:
>> On Monday 27 May 2013 21:50:04 Benjamin Herrenschmidt wrote:
>> > However, that wouldn't help much with the allocation/leak problem,
>> > though at least it would be easier to use. It could also *try* to re-use
>> > the current allocation if the new content is of smaller or equal size.
>> 
>> I thought that dtc tried to aggressively save space by folding identical
>> strings. If you tried to reuse a property that had its contents shared
>> with another one, you would get interesting results I guess.
> 
> It used to be only property names, unless that has changed in recent
> dtc. But that's a good point, we probably want a flag in struct property
> like we have for nodes, indicating whether it comes from the original
> fdt data pool or not.

This is similar to what the "OF_IS_DYNAMIC()" thing on sparc
indicates.
