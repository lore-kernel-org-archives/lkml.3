Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab3APN30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 08:29:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54851 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753161Ab3APN3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 08:29:25 -0500
Date: Wed, 16 Jan 2013 22:29:19 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] regmap: debugfs: Fix last entry store in the offset cache
Message-ID: <20130116132918.GH25480@opensource.wolfsonmicro.com>
References: <1358342651-19690-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358342651-19690-1-git-send-email-p.zabel@pengutronix.de>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 02:24:11PM +0100, Philipp Zabel wrote:

> -	/* Close the last entry off if we didn't scan beyond it */
> -	if (c) {
> -		c->max = p - 1;
> -		list_add_tail(&c->list,
> -			      &map->debugfs_off_cache);

Oh, ffs.  I actually fixed this but the cherry pick went wrong.

> -	} else {
> -		return base;
> +		/* Close the last entry off if we didn't scan beyond it */
> +		if (c) {
> +			c->max = p - 1;
> +			list_add_tail(&c->list,
> +				      &map->debugfs_off_cache);
> +		} else {
> +			return base;
> +		}

No, the else clause just needs deleting.
