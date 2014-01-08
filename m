Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbaAHSeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 13:34:46 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:59243 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbaAHSem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 13:34:42 -0500
Date: Wed, 8 Jan 2014 11:34:18 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, dev@linux-sunxi.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 3/9] of: mtd: add NAND timings retrieval support
Message-ID: <20140108183418.GA12358@obsidianresearch.com>
References: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com>
 <1389190924-26226-4-git-send-email-b.brezillon@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389190924-26226-4-git-send-email-b.brezillon@overkiz.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 03:21:58PM +0100, Boris BREZILLON wrote:

> +int of_get_nand_timings(struct device_node *np, struct nand_timings *timings)
> +{
> +	memset(timings, 0, sizeof(*timings));
> +	of_property_read_u32(np, "tCLS-min", &timings->tCLS_min);
> +	of_property_read_u32(np, "tCLH-min", &timings->tCLH_min);
> +	of_property_read_u32(np, "tCS-min", &timings->tCS_min);
[..]

A while ago when discussing another controller it was pointed out
these values are all auto-probable directly from the NAND via a ONFI
defined GET FEATURE @0x01 query, and adding these timings to the DT
was NAK'd..

Basically you set the interface to the slowest ONFI timing mode, do
the GET FEATURE to the NAND chip and then increase the interface speed
to the highest mutually supported ONFI mode.

Is there some reason you need to encode this in the DT?

Jason
