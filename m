Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559AbbAOGHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 01:07:22 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:53624 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbbAOGHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 01:07:20 -0500
Date: Wed, 14 Jan 2015 22:07:13 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Scott Branden <sbranden@broadcom.com>
Cc: Jonathan Richardson <jonathar@broadcom.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com, devicetree@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 1/2] Input: touchscreen-iproc: Add Broadcom iProc
 touchscreen driver
Message-ID: <20150115060713.GA2694@dtor-ws>
References: <jonathar@broadcom.com>
 <1419027470-7969-1-git-send-email-jonathar@broadcom.com>
 <1419027470-7969-2-git-send-email-jonathar@broadcom.com>
 <20150115010256.GC9134@dtor-ws>
 <54B753C7.6000006@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B753C7.6000006@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 09:44:39PM -0800, Scott Branden wrote:
> On 15-01-14 05:02 PM, Dmitry Torokhov wrote:
> >Hi Jonathan,
> >
> >On Fri, Dec 19, 2014 at 02:17:49PM -0800, Jonathan Richardson wrote:
> >>+	if (of_property_read_u32(np, "scanning_period", &val) >= 0) {
> >>+		if (val < 1 || val > 256) {
> >>+			dev_err(dev, "scanning_period must be [1-256]\n");
> >>+			return -EINVAL;
> >>+		}
> >>+		priv->cfg_params.scanning_period = val;
> >>+	}
> >>+
> >>+	if (of_property_read_u32(np, "debounce_timeout", &val) >= 0) {
> >>+		if (val < 0 || val > 255) {
> >>+			dev_err(dev, "debounce_timeout must be [0-255]\n");
> >>+			return -EINVAL;
> >>+		}
> >>+		priv->cfg_params.debounce_timeout = val;
> >>+	}
> >>+
> >>+	if (of_property_read_u32(np, "settling_timeout", &val) >= 0) {
> >>+		if (val < 0 || val > 11) {
> >>+			dev_err(dev, "settling_timeout must be [0-11]\n");
> >>+			return -EINVAL;
> >>+		}
> >>+		priv->cfg_params.settling_timeout = val;
> >>+	}
> >>+
> >>+	if (of_property_read_u32(np, "touch_timeout", &val) >= 0) {
> >>+		if (val < 0 || val > 255) {
> >>+			dev_err(dev, "touch_timeout must be [0-255]\n");
> >>+			return -EINVAL;
> >>+		}
> >>+		priv->cfg_params.touch_timeout = val;
> >>+	}
> >>+
> >>+	if (of_property_read_u32(np, "average_data", &val) >= 0) {
> >>+		if (val < 0 || val > 8) {
> >>+			dev_err(dev, "average_data must be [0-8]\n");
> >>+			return -EINVAL;
> >>+		}
> >>+		priv->cfg_params.average_data = val;
> >>+	}
> >>+
> >>+	if (of_property_read_u32(np, "fifo_threshold", &val) >= 0) {
> >>+		if (val < 0 || val > 31) {
> >>+			dev_err(dev, "fifo_threshold must be [0-31]\n");
> >>+			return -EINVAL;
> >>+		}
> >>+		priv->cfg_params.fifo_threshold = val;
> >>+	}
> >
> >I think these are dveice specific and thus should have "brcm," prefix.
> I'm confused as to why we need the brcm prefix?  Other device tree
> bindings we have for other drivers do not need such prefix.

Properties that are not standard on the system (reg, interrupts,
clkocks, etc) or subsystem level customarily carry the vendor prefix so
that they do not clash with newly added global or subsystem properties.

>  Is this
> convention documented somewhere?

Not sure. I glanced through Documentation/devicetree and do not see it
spelled out. Device tree overlords, what say you?

> >
> >>+
> >>+	priv->ts_rotation = TS_ROTATION_0;
> >>+	if (of_property_read_u32(np, "ts-rotation", &val) >= 0) {
> >>+		priv->ts_rotation = val;
> >>+		dev_dbg(dev, "ts rotation [%d] degrees\n",
> >>+			90 * priv->ts_rotation);
> >>+	}
> >
> >This I am not quite sure about - if we want rotation or swap+invert. You
> >are CCed on another email (tsc2007) that talks about need of generic
> >touchscreen transforms in input core/of bindings.
> Does such generic binding exist today?  If not, I would like to go
> with this implementation and update to the new binding if/when it
> exists?

Not yet but there several people interested. I think we have enough time
till 3.20 to hash it out properly.

Thanks.

-- 
Dmitry
