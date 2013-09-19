Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab3ISVLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 17:11:19 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:61970 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3ISVLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 17:11:17 -0400
Date: Thu, 19 Sep 2013 14:11:12 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hyun Kwon <hyunk@xilinx.com>
Subject: Re: [PATCH v2] clk: si570: Add a driver for SI570 oscillators
Message-ID: <20130919211112.GA11537@roeck-us.net>
References: <1379544219-23579-1-git-send-email-soren.brinkmann@xilinx.com>
 <20130919131712.GB24088@roeck-us.net>
 <6401b71c-8c18-4735-8b40-9692cd788336@VA3EHSMHS037.ehs.local>
 <20130919164438.GA7461@roeck-us.net>
 <86ee8eea-7a98-443b-a156-46f3db1f9678@CO1EHSMHS031.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86ee8eea-7a98-443b-a156-46f3db1f9678@CO1EHSMHS031.ehs.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 01:59:38PM -0700, Sören Brinkmann wrote:
> On Thu, Sep 19, 2013 at 09:44:38AM -0700, Guenter Roeck wrote:
> > On Thu, Sep 19, 2013 at 09:01:01AM -0700, Sören Brinkmann wrote:
> > > On Thu, Sep 19, 2013 at 06:17:12AM -0700, Guenter Roeck wrote:
> > > > On Wed, Sep 18, 2013 at 03:43:38PM -0700, Soren Brinkmann wrote:
> [...]
> > > > > +	if (of_property_read_bool(client->dev.of_node,
> > > > > +				"temperature-stability-7ppm"))
> > > > > +		data->div_offset = SI570_DIV_OFFSET_7PPM;
> > > > > +
> > > > Just noticed that you dropped platform data support. Doesn't matter much for me
> > > > right now, but in my previous company we used the chip on an x86 system which
> > > > does not support devicetree. Would be nice to keep it and derive platform data
> > > > from devicetree data if provided, like other drivers do it.
> > > I'll look into this. The issue I have with that is, I can hardly test it
> > > since we only use this on Zynq which uses DT. So, I'd rather prefer to
> > > not include it unless somebody volunteers to test it.
> > > 
> > Fair enough. I can not test it myself anymore, and my previous employer
> > now has a strict non-contributions-to-linux policy, so I guess they won't
> > test it either or at least not publish any test results. Leave it out.
> > 
> > > > The 7ppm option is only relevant for si570/si751 and not supported on
> > > > si598/si599. You should mention that in the bindings document and check for it.
> > > Right, I'll add a note in the doc. And ignore it for devices this does
> > > not apply.
> > > 
> > I would bail out, but that is your call.
> Correct me if I'm wrong, but in general drivers do not test for
> unsupported properties. So, in case we have one of the supported 59x
> device, we should not test whether a (unsupported) property is present,
> just to fail in that case, IMHO.
> 
Ok with me if that is the accepted way of handling this condition.

Guenter
