Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272Ab3HREWb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 00:22:31 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40510 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750771Ab3HREW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 00:22:29 -0400
Message-ID: <1376799747.2027.11.camel@joe-AO722>
Subject: Re: [PATCH v2 02/14] crypto: omap-aes: Add useful debug macros
From: Joe Perches <joe@perches.com>
To: Joel Fernandes <joelf@ti.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Greer <mgreer@animalcreek.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Date: Sat, 17 Aug 2013 21:22:27 -0700
In-Reply-To: <1376793755-30478-3-git-send-email-joelf@ti.com>
References: <1376793755-30478-1-git-send-email-joelf@ti.com>
	 <1376793755-30478-3-git-send-email-joelf@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-08-17 at 21:42 -0500, Joel Fernandes wrote:
> When DEBUG is enabled, these macros can be used to print variables in integer
> and hex format, and clearly display which registers, offsets and values are
> being read/written , including printing the names of the offsets and their values.
> 
> Note:
> This patch results in a checkpatch error that cannot be fixed.
> ERROR: Macros with multiple statements should be enclosed in a do - while loop
> +#define omap_aes_read(dd, offset)                                      \
> +       __raw_readl(dd->io_base + offset);                              \
> +       pr_debug("omap_aes_read(" #offset ")\n");
> 
> Using do-while loop will break a lot of code such as:
> ret = omap_aes_read(..);

That's where you use a statement expression macro

#define omap_aes_read(dd, offset)					\
({									\
	pr_debug("omap_aes_read("omap_aes_read(" #offset ")\n");	\
	__raw_readl((dd)->iobase + offset);				\
})


