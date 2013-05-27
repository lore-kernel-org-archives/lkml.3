Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815Ab3E0Vwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 17:52:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:59322 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757650Ab3E0Vwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 17:52:36 -0400
Message-ID: <1369691406.3557.35.camel@pasglop>
Subject: Re: [PATCH 1/2] ARM: kirkwood: proper retain MAC address workaround
 on DT ethernet
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@lists.ozlabs.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        andrew@lunn.ch, jason@lakedaemon.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, buytenh@wantstofly.org,
        grant.likely@linaro.org, David Miller <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 28 May 2013 07:50:06 +1000
In-Reply-To: <2255648.0KEmXfjCx5@wuerfel>
References: <1369253042-15082-1-git-send-email-sebastian.hesselbarth@gmail.com>
	 <51A33447.80305@gmail.com> <1369655404.3557.33.camel@pasglop>
	 <2255648.0KEmXfjCx5@wuerfel>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-27 at 14:47 +0200, Arnd Bergmann wrote:
> On Monday 27 May 2013 21:50:04 Benjamin Herrenschmidt wrote:
> > However, that wouldn't help much with the allocation/leak problem,
> > though at least it would be easier to use. It could also *try* to re-use
> > the current allocation if the new content is of smaller or equal size.
> 
> I thought that dtc tried to aggressively save space by folding identical
> strings. If you tried to reuse a property that had its contents shared
> with another one, you would get interesting results I guess.

It used to be only property names, unless that has changed in recent
dtc. But that's a good point, we probably want a flag in struct property
like we have for nodes, indicating whether it comes from the original
fdt data pool or not.

Cheers,
Ben.


