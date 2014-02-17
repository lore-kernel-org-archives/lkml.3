Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaBQHnC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 02:43:02 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:60924 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbaBQHnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 02:43:00 -0500
Message-ID: <1392622898.17130.8.camel@iivanov-dev>
Subject: Re: [PATCH v2] spi: core: Validate lenght of the transfers in
 message
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Gerhard Sittig <gsi@denx.de>
Cc: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 17 Feb 2014 09:41:38 +0200
In-Reply-To: <20140216142512.GR4524@book.gsilab.sittig.org>
References: <1392444566-23605-1-git-send-email-iivanov@mm-sol.com>
	 <20140216142512.GR4524@book.gsilab.sittig.org>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, 

On Sun, 2014-02-16 at 15:25 +0100, Gerhard Sittig wrote: 
> On Sat, Feb 15, 2014 at 08:09 +0200, Ivan T. Ivanov wrote:
> > 
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > 
> > SPI transfer lenght should be a power-of-two multiple
> > of eight bits.
> 
> Please re-check for "lenght" typos in subjects and commit logs
> (code comments appear to be correct already).

Thanks, will correct them.

> 
> 
> The commit message still confuses me.  You don't check that the
> length of an SPI transfer has a power-of-two length in bytes.
> 
> Instead what the check implements is IIUC
> - pad "odd" bits-per-word settings before the check to full 1/2/4
>   byte length specs (this is the power-of-two thing)
> - the total length of the SPI transfer cannot be empty (which I'd
>   consider an optimization, not a violation, and may need a
>   separate discussion)

I am not sure that I understand this one. I will say "the total
length of the SPI transfer _should not_ be empty". There is no
check for this currently.

> - the total length of the SPI transfer must be such that each
>   "word" must be provided within a full 1/2/4 byte entity, with
>   padding bits if the bits-per-word is "odd"
> 
> Is this a misunderstanding on my side?  A terminology thing?  To
> me, the "SPI transfer" is the total payload and may have any
> arbitrary length.  What you check for is a constraint on the
> transfer's length derived from or based on the "word length"
> ('word' in SPI context).
> 
> So the code may be appropriate, yet the description may need an
> update, to not have the next person ask the same questions again.
> 

I just forgot to update commit message. Will try to be more
careful next time.

Regards,
Ivan

> 
> virtually yours
> Gerhard Sittig


