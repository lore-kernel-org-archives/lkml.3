Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbaGWOdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 10:33:31 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:36274 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbaGWOd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 10:33:29 -0400
Date: Wed, 23 Jul 2014 15:33:23 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, maxime.coquelin@st.com,
        patrice.chotard@st.com, srinivas.kandagatla@gmail.com,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, peppe.cavallaro@st.com
Subject: Re: [PATCH v2 1/3] usb: dwc3: add ST dwc3 glue layer to manage dwc3
 HC
Message-ID: <20140723143323.GA26565@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1404541530-27856-1-git-send-email-peter.griffin@linaro.org>
 <1404541530-27856-2-git-send-email-peter.griffin@linaro.org>
 <20140707124627.GG6407@lee--X1>
 <20140722091800.GB8233@griffinp-ThinkPad-X1-Carbon-2nd>
 <20140722145711.GC20588@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140722145711.GC20588@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

Thanks for reviewing, see my comments inline: -

> > > Just use {read,write}l_relaxed() directly.
> > 
> > Ok, unabstracted in v3
> 
> no, no... all other glues add their own local helpers for register
> access. This is good for tracing, it's very easy to add a tracepoint to
> this sort of function and get very low overhead tracing of every
> register access.

I've put the IO accessors back in for V3

> > They are just bit setting macros, I've converted them over to use BIT macro now,
> > so it no longer takes a parameter.
> 
> the macros are better, but make them upper case as everybody else.

Fixed in v3.


> > I've asked ST how this value was derirved and why. It came from validation. 
> > The docs don't mention that it is necessary, and removing it
> > seems to have no ill effects. So I've removed this udelay in v3.
> 
> make sure to test with many, many iterations just to make sure.

Yes will do, I've been booting my board all day, and so far no failures.

> > Ok. Do the DT folks have any comment on this?
> 
> look at the child's dr-mode property instead of adding your own.

Thanks for the hint, now using dr-mode binding in V3 :-)
 
> 
> > > > +	dwc3_data->glue_base = devm_request_and_ioremap(dev, res);
> 
> use devm_ioremap_resource()

Fixed in V3

> > Your right, this was wrong. It was some legacy code which is
> > unnecessary and I've removed this in v3.
> 
> if you're going for DT, why don't you create the parent and the child
> from DT as omap/exynos/qcom are doing ?

Now creating parent and child from DT like OMAP in v3

> > > > +	reset_control_assert(dwc3_data->rstc_pwrdn);
> > > > +
> > > > +	pinctrl_pm_select_sleep_state(dev);
> 
> pinctrl will select sleep and default states automatically for you.

I've left this in v3, as greping around I couldn't see how that could happen automatically.

Also I just double checked with linusw on irc who confirmed that the only state which is 
ever auto-selected is "default". All other states, as well as going back to default
state need to be explicitly called.

Hope thats ok.

regards,

Peter.
