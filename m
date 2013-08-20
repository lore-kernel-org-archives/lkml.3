Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467Ab3HTUGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 16:06:41 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:35657 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3HTUGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 16:06:39 -0400
Date: Tue, 20 Aug 2013 13:06:36 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Michael Grzeschik <mgr@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH] mc13xxx-ts: use zero as default value if no pdata was
 defined
Message-ID: <20130820200635.GA22769@core.coreip.homeip.net>
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

On Tue, Aug 20, 2013 at 11:34:32AM +0200, Michael Grzeschik wrote:
> On Tue, Aug 20, 2013 at 03:34:33AM +0200, Samuel Ortiz wrote:
> > Hi Michael,
> > 
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
> 
> The purpose of this patch is to have both cases working, pdata and no
> pdata.

My concern with allowing defaults with missing pdata or device tree data
is that it makes it easy for the integrator to miss the necessity of the
parameters and then start piling on driver workarounds. I have seen a
few examples of this happening, so I'd rather prefer an explicit values
if possible.

Thanks.

-- 
Dmitry
