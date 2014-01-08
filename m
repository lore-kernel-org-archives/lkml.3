Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017AbaAHTNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 14:13:54 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:55091 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755902AbaAHTNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 14:13:49 -0500
Date: Wed, 8 Jan 2014 12:13:39 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: boris brezillon <b.brezillon@overkiz.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, dev@linux-sunxi.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 3/9] of: mtd: add NAND timings retrieval support
Message-ID: <20140108191339.GB12358@obsidianresearch.com>
References: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com>
 <1389190924-26226-4-git-send-email-b.brezillon@overkiz.com>
 <20140108183418.GA12358@obsidianresearch.com>
 <52CDA032.3010804@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CDA032.3010804@overkiz.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 08:00:02PM +0100, boris brezillon wrote:
> Hello Jason,
> 
> Le 08/01/2014 19:34, Jason Gunthorpe a ?crit :
> >On Wed, Jan 08, 2014 at 03:21:58PM +0100, Boris BREZILLON wrote:
> >
> >>+int of_get_nand_timings(struct device_node *np, struct nand_timings *timings)
> >>+{
> >>+	memset(timings, 0, sizeof(*timings));
> >>+	of_property_read_u32(np, "tCLS-min", &timings->tCLS_min);
> >>+	of_property_read_u32(np, "tCLH-min", &timings->tCLH_min);
> >>+	of_property_read_u32(np, "tCS-min", &timings->tCS_min);
> >[..]
> >
> >A while ago when discussing another controller it was pointed out
> >these values are all auto-probable directly from the NAND via a ONFI
> >defined GET FEATURE @0x01 query, and adding these timings to the DT
> >was NAK'd..
> >
> >Basically you set the interface to the slowest ONFI timing mode, do
> >the GET FEATURE to the NAND chip and then increase the interface speed
> >to the highest mutually supported ONFI mode.
> 
> >Is there some reason you need to encode this in the DT?
> 
> What if the NAND does not support the ONFI interface (and this is
> exactly the case for the NAND available on the cubietruck board:
> H27UCG8T2ATR).

Sounds like a good reason to me! 

You might want to check if you can boil down the DT timings from the
huge list to just an ONFI mode number..

I'd echo Rob's comments, the property needs to include the units
in the name, and I strongly recommend picoseconds for these
values.

Also, you might want to check that the ONFI names for these parameters
are used, not a vendor specific name to try and avoid confusion.

Jason
