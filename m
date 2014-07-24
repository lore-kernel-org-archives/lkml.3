Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561AbaGXQ4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 12:56:38 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:49131 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598AbaGXQ4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 12:56:36 -0400
Date: Thu, 24 Jul 2014 09:56:33 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: "Gupta, Pekon" <pekon@ti.com>
Cc: bpqw <bpqw@micron.com>, "ron@debian.org" <ron@debian.org>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "b32955@freescale.com" <b32955@freescale.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "ezequiel.garcia@free-electrons.com" 
	<ezequiel.garcia@free-electrons.com>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: Re: Subject: [PATCH 1/1] mtd:nand:fix nand_lock/unlock() function
Message-ID: <20140724165633.GF3711@ld-irv-0074>
References: <CB9F11E856CFD04BB18EC1C68F2598931B1112@NTXXIAMBX01.xacn.micron.com>
 <20140724012730.GA3711@ld-irv-0074>
 <20980858CB6D3A4BAE95CA194937D5E73EB068AB@DBDE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20980858CB6D3A4BAE95CA194937D5E73EB068AB@DBDE04.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 07:54:41AM +0000, Pekon Gupta wrote:
> >On Thu, Jul 24, 2014 at 01:00:01AM +0000, bpqw wrote:
> >I don't see any in-tree users of nand_{un,}lock(). I recently caught a
> >bug in nand_lock() via inspection (still need to send a fix), but I was
> >considering dropping the functions entirely.
> >
> >I presume you have some out-of-tree driver that uses these functions,
> >then?
> >
> Please don't drop nand_{unlock, lock} interfaces at-least for sometime.
> I remember there were some users trying to use these for secure
> applications. But due to lack of proper userland utility support they
> probably dropped the idea.

OK, I won't drop them yet.

> Good to have this added as part of mtd-utils package, and then let it live
> for some more time.

As you note, there's no user-space support. There's actually no one
using them even in the kernel, which is why I considered dropping them.
If you want to use them, find a proper way to use them then! (I'm not
sure: do they match with mtd_lock() / ioctl(MEMLOCK) interface?)

Brian
