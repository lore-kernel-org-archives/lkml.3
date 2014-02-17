Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbaBQPVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 10:21:23 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:41868 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbaBQPVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 10:21:22 -0500
Message-ID: <1392650400.17130.12.camel@iivanov-dev>
Subject: Re: [PATCH v2] spi: core: Validate lenght of the transfers in
 message
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gerhard Sittig <gsi@denx.de>
Date: Mon, 17 Feb 2014 17:20:00 +0200
In-Reply-To: <1392444566-23605-1-git-send-email-iivanov@mm-sol.com>
References: <1392444566-23605-1-git-send-email-iivanov@mm-sol.com>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, Please ignore this patch.

On Sat, 2014-02-15 at 08:09 +0200, Ivan T. Ivanov wrote:

> 
> +		/*
> +		 * SPI transfer length should be multiple of SPI word size
> +		 * where SPI word size should be power-of-two multiple
> +		 */
> +		if (xfer->bits_per_word <= 8)
> +			w_size = 1;
> +		else if (xfer->bits_per_word <= 16)
> +			w_size = 2;
> +		else
> +			w_size = 4;
> +
> +		n_words = xfer->len / w_size;
> +		/* No partial transfers accepted */
> +		if (!n_words || xfer->len % xfer->bits_per_word)

This should be
if (!n_words || xfer->len % w_size)


Regards,
Ivan

