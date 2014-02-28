Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbaB1TOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 14:14:15 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:53499 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaB1TOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 14:14:12 -0500
Date: Fri, 28 Feb 2014 13:11:29 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Josh Cartwright <joshc@codeaurora.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 7/9] devicetree: bindings: Document PM8921/8058 keypads
Message-ID: <20140228191129.GH7308@joshc.qualcomm.com>
References: <1393552520-9068-1-git-send-email-sboyd@codeaurora.org>
 <1393552520-9068-8-git-send-email-sboyd@codeaurora.org>
 <20140228135527.GF7308@joshc.qualcomm.com>
 <20140228183708.GF2487@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140228183708.GF2487@codeaurora.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 10:37:08AM -0800, Stephen Boyd wrote:
> On 02/28, Josh Cartwright wrote:
> > On Thu, Feb 27, 2014 at 05:55:18PM -0800, Stephen Boyd wrote:
> > > +
> > > +EXAMPLE
> > > +
> > > +	keypad {
> > > +		compatible = "qcom,pm8921-keypad";
> > > +		interrupt-parent = <&pmicintc>;
> > > +		interrupts = <74 1>, <75 1>;
> > > +		linux,keymap = <
> > > +			MATRIX_KEY(0, 0, KEY_VOLUMEUP)
> > > +			MATRIX_KEY(0, 1, KEY_VOLUMEDOWN)
> > > +			MATRIX_KEY(0, 2, KEY_CAMERA_FOCUS)
> > > +			MATRIX_KEY(0, 3, KEY_CAMERA)
> > > +			>;
> > > +		keypad,num-rows = <1>;
> > > +		keypad,num-columns = <5>;
> > > +		debounce = <15>;
> > > +		scan-delay = <32>;
> > > +		row-hold = <91500>;
> > > +	};
> >
> > It odd to me that these newly created bindings don't have 'reg'
> > properties, even though the device clearly has a register region.
> >
> > I suppose it makes sense from a "port over from platform data to DT"
> > perspective, as these drivers have just assumed the location of their
> > registers to be fixed; however I suspect things will need to be changed
> > if/when we hope to share these drivers with pm8841/pm8941 and beyond...
> >
>
> Agreed. I would love it if the platform OF code would create
> IORESOURCE_REG resources for any reg properties that aren't
> translatable to CPU addresses. That way we don't have to pick out the
> reg property from DT with special OF code (like you've done in
> rtc-pm8xxx).

Yes, I agree this would be nice.  The rtc-pm8xxx register parsing magic
is misplaced/ugly.  I'll see about taking a crack at this and seeing
what it looks like.

> I'll throw the reg property into the binding so that in
> the future we can support the register moving around (although at the
> moment the driver will ignore it).

Great, I think this sounds good.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
