Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbaGVPpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:45:14 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50819 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644AbaGVPpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:45:10 -0400
Date: Tue, 22 Jul 2014 16:45:03 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Peter Griffin <peter.griffin@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        peppe.cavallaro@st.com
Subject: Re: [PATCH v2 1/3] usb: dwc3: add ST dwc3 glue layer to manage dwc3
 HC
Message-ID: <20140722154503.GC23210@lee--X1>
References: <1404541530-27856-1-git-send-email-peter.griffin@linaro.org>
 <1404541530-27856-2-git-send-email-peter.griffin@linaro.org>
 <20140707124627.GG6407@lee--X1>
 <20140722091800.GB8233@griffinp-ThinkPad-X1-Carbon-2nd>
 <20140722145711.GC20588@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140722145711.GC20588@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > +static void st_dwc3_init(struct st_dwc3 *dwc3_data)
> > > > +{
> > > > +	u32 reg = st_dwc3_readl(dwc3_data->glue_base, USB2_CLKRST_CTRL);
> > > > +
> > > > +	reg |= aux_clk_en(1) | ext_cfg_reset_n(1) | xhci_revision(1);
> > > > +	reg &= ~sw_pipew_reset_n(1);
> > > 
> > > 1?  Better to add defines for these magic numbers.  What is 1 anyway?
> > 
> > They are just bit setting macros, I've converted them over to use BIT macro now,
> > so it no longer takes a parameter.
> 
> the macros are better, but make them upper case as everybody else.

When you say that the macros are better, what do you mean?

Defines do the job in a manner which is a great deal cleaner:

#define AUX_CLK_EN        BIT(0)
#define SW_PIPEW_RESET_N  BIT(4)
#define EXT_CFG_RESET_N   BIT(8)
#define XHCI_REVISION     BIT(12)

reg = AUX_CLK_EN | SW_PIPEW_RESET_N | XHCI_REVISION;
reg &= ~SW_PIPEW_RESET_N

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
