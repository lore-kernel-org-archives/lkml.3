Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750927Ab3HTJuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:50:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:1275 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab3HTJux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:50:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,919,1367996400"; 
   d="scan'208";a="390073062"
Date: Tue, 20 Aug 2013 11:50:48 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Michael Grzeschik <mgr@pengutronix.de>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] mc13xxx-ts: use zero as default value if no pdata was
 defined
Message-ID: <20130820095048.GC17521@zurbaran>
References: <1376396070-24507-1-git-send-email-m.grzeschik@pengutronix.de>
 <20130820013433.GE13324@zurbaran>
 <20130820093432.GC26693@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820093432.GC26693@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Tue, Aug 20, 2013 at 11:34:32AM +0200, Michael Grzeschik wrote:
> On Tue, Aug 20, 2013 at 03:34:33AM +0200, Samuel Ortiz wrote:
> > On Tue, Aug 13, 2013 at 02:14:30PM +0200, Michael Grzeschik wrote:
> > > In case of devicetree, we currently don't have a way to append pdata for
> > > the touchscreen. The current approach is to bail out in that case.
> > > This patch makes it possible to probe the touchscreen without pdata
> > > and use zero as default values for the atox and ato adc conversion.
> > Would that still make the touchscreen somehow functional ?
> 
> Yes, it still works. It just defaults to zero values in no pdata case.
> 
> > If that's the case, and if Dmitry is fine with the ts part of this
> > patch, could you please separate the mfd part of this patch into a
> > separate one ?
> 
> Why?
To avoid cross tree commits as much as possible.


> The purpose of this patch is to have both cases working, pdata and no
> pdata. 
I understood that part. But you can still split the patch in 2 as the ts
driver will not be probed without pdata until the mfd patch is merged
upstream.

> This patch is actually fixing the patch of Michael Thalmeier.
> There we changed the mfd and touch in one patch as well.
There was a build time dependency between the ts driver and the MFD
changes, so the patch had to be merged atomically.
That is not the case with your patch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
