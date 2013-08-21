Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760Ab3HULvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 07:51:09 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:36025 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751463Ab3HULvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 07:51:07 -0400
Date: Wed, 21 Aug 2013 21:50:52 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Joel Fernandes <joelf@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Mark Greer <mgreer@animalcreek.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v2 00/14] crypto: omap-aes: Improve DMA, add PIO mode and
 support for AM437x
Message-ID: <20130821115051.GE23287@gondor.apana.org.au>
References: <1376793755-30478-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376793755-30478-1-git-send-email-joelf@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 17, 2013 at 09:42:21PM -0500, Joel Fernandes wrote:
> Following patch series rewrites the DMA code to be cleaner and faster. Earlier,
> only a single SG was used for DMA purpose, and the SG-list passed from the
> crypto layer was being copied and DMA'd one entry at a time. This turns out to
> be quite inefficient and lot of code, we replace it with much simpler approach
> that directly passes the SG-list from crypto to the DMA layers for cases where
> possible. For all cases where such a direct passing of SG list is not possible,
> we create a new SG-list and do the copying. This is still better than before, as
> we create an SG list as big as needed and not just 1-element list.
> 
> We also add PIO mode support to the driver, and switch to it whenever the DMA
> channel allocation is not available. This also has shown to give good performance
> for small blocks as shown below.
> 
> Tests have been performed on AM335x, OMAP4 and AM437x SoCs.
> 
> Below is a sample run on AM335x SoC (beaglebone board), showing
> performance improvement (20% for 8K blocks):

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
