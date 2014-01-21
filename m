Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbaAUW5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 17:57:55 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:60196 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaAUW5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 17:57:52 -0500
Date: Tue, 21 Jan 2014 15:57:40 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: boris brezillon <b.brezillon@overkiz.com>
Cc: devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-doc@vger.kernel.org, dev@linux-sunxi.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 3/9] of: mtd: add NAND timings retrieval support
Message-ID: <20140121225740.GP18269@obsidianresearch.com>
References: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com>
 <1389190924-26226-4-git-send-email-b.brezillon@overkiz.com>
 <20140108183418.GA12358@obsidianresearch.com>
 <52CDA032.3010804@overkiz.com>
 <20140108191339.GB12358@obsidianresearch.com>
 <52CE5F82.6070802@overkiz.com>
 <20140109173505.GB8899@obsidianresearch.com>
 <52D6A48D.4080302@overkiz.com>
 <52D6BF45.80407@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52D6BF45.80407@overkiz.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 06:03:01PM +0100, boris brezillon wrote:

> >>Pick a mode value that fits all the parameters of the connected
> >>non-ONFI flash.
> >>
> >>This would be instead of defining each parameter
> >>individually.. Provide some helpers to convert from a onfi mode number
> >>to all the onfi defined timing parameters so that drivers can
> >>configure the HW..
> >
> >Are you suggesting we should provide a function that converts these
> >modes into a nand_timings struct, or just use the timing modes and
> >let the NAND controller drivers configure its IP accordingly ?

Either seems reasonable to me, but passing the ONFI mode directly from
the NAND core to the driver seems a little safer..

The NAND core can provide a helper function to xlate the mode number
to the timing struct to help drivers that need broken out timing.

> >I found the ONFI timing tables in this document:
> >
> >www.*onfi*.org/~/media/*ONFI*/specs/*onfi*_3_1_spec.pdf‎ (chapter 4.16).
> >
> >I suppose my nand_timings struct should use the names described
> >page 110-111 (at least if we decide to use nand_timings and not
> >nand_timing_modes), right ?

Yah, I think follow the standard. The standard has timing diagrams
that show what all these parameters actually are.

> After taking a closer look at this document, the only parameter
> available in my nand_timings struct that is not defined in the
> standard is tR_max (data transfer from cell to register).

Maybe it can be derived from the other parameters? The ONFI values
seemed pretty comprehensive to me.

I think the mvebu driver was similar, not all of the ONFI values were
used and some translation was needed.

Jason
