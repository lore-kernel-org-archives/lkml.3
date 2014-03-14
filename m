Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbaCNKmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 06:42:31 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:59549 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175AbaCNKm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 06:42:28 -0400
Date: Fri, 14 Mar 2014 10:42:22 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Gabriel Fernandez <gabriel.fernandez@st.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        kernel@stlinux.com, Giuseppe Condorelli <giuseppe.condorelli@st.com>
Subject: Re: [PATCH 1/5] drivers: input: keyboard: st-keyscan: add keyscan
 driver
Message-ID: <20140314104222.GB3432@lee--X1>
References: <1393990772-9567-1-git-send-email-gabriel.fernandez@st.com>
 <1393990772-9567-2-git-send-email-gabriel.fernandez@st.com>
 <20140310114819.GO14976@lee--X1>
 <5322D63D.5030403@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5322D63D.5030403@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >Sorry for the delay. It was a hectic week last week.
> >
> >As promised:
> >
> >>This patch adds ST Keyscan driver to use the keypad hw a subset
> >>of ST boards provide. Specific board setup will be put in the
> >>given dt.
> >>
> >>Signed-off-by: Giuseppe Condorelli <giuseppe.condorelli@st.com>
> >>Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
> >Are you sure these are in the correct order?
> ok i change the order

I'm not saying they are in the wrong order, I'm just asking. Who wrote
the patch? Has it changed since?

> >>+- linux,keymap: The keymap for keys as described in the binding document
> >>+  devicetree/bindings/input/matrix-keymap.txt.
> >>+
> >>+- keypad,num-rows: Number of row lines connected to the keypad controller.
> >>+
> >>+- keypad,num-columns: Number of column lines connected to the keypad
> >>+  controller.
> >>+
> >>+- st,debounce_us: Debouncing interval time in microseconds
> >I'm sure there will be a shared binding for de-bounce.
> >
> >If not, there certainly should be.
> 
> you want to refer to "debounce-interval" ?

That sounds more generic, but if it's not documented as such, then
please consider doing so.

> >+Example:
> >+
> >+keyscan: keyscan@fe4b0000 {
> >+	compatible = "st,keypad";
> >Is there any way we can make this more specific to _this_ IP?
> for my knowledge this IP is the same for stixxxx platform.

So st,stix-keypad, or st,sti4x-keypad?

I'm just thinking about future proofing the architecture. What if ST
released stj which has a different keypad IP?

> >>+struct keyscan_priv {
> >>+	void __iomem *base;
> >>+	int irq;
> >>+	struct clk *clk;
> >>+	struct input_dev *input_dev;
> >>+	struct keypad_platform_data *config;
> >>+	unsigned int last_state;
> >>+	u32 keycodes[ST_KEYSCAN_MAXKEYS];
> >Seems odd to limit this. Can't the information come from DT
> >i.e. keypad,num-rows and keypad,num-columns?
> >
> i 'll rename 'num_out_pads' into 'n_rows' and 'num_in_pads' into
> 'n_cols'

That's not quite what I meant, I mean can't ST_KEY_MAXKEYS be more
dynamic and be obtained from (keypad,num-rows * keypad,num-columns)?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
