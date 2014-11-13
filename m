Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575AbaKMKZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:25:55 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:51797 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469AbaKMKZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 05:25:51 -0500
Date: Thu, 13 Nov 2014 10:25:40 +0000
From: Lee Jones <lee.jones@linaro.org>
To: "R, Vignesh" <vigneshr@ti.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, "Balbi, Felipe" <balbi@ti.com>,
        "Griffis, Brad" <bgriffis@ti.com>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jan Kardell <jan.kardell@telliq.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [PATCH v3 3/6] mfd: ti_am335x_tscadc: Remove unwanted
 reg_se_cache save
Message-ID: <20141113102540.GJ24004@x1>
References: <1415694844-11230-1-git-send-email-vigneshr@ti.com>
 <1415694844-11230-4-git-send-email-vigneshr@ti.com>
 <20141111122623.GA24004@x1>
 <71C24A547111EA4E84AE759B748D9EAE4B976C@DBDE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <71C24A547111EA4E84AE759B748D9EAE4B976C@DBDE04.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2014, R, Vignesh wrote:
> On Tue, 11 Nov 2014, Vignesh R wrote:
> > In one shot mode, sequencer automatically disables all enabled steps 
> > at the end of each cycle. (both ADC steps and TSC steps) Hence these 
> > steps need not be saved in reg_se_cache for clearing these steps at a 
> > later stage.
> > Also, when ADC wakes up Sequencer should not be busy executing any of 
> > the config steps except for the charge step. Previously charge step 
> > was 1 ADC clock cycle and hence it was ignored.
> > 
> > Signed-off-by: Vignesh R <vigneshr@ti.com>
> > ---

[...]

> > -	tsadc->reg_se_cache |= val;
> 
> You didn't answer my question about this?
> I did reply to the question in the previous thread.  
> 
> Previously, TSC did not reliably re-enable its steps as the TSC irq handler received 
> false pen up events. Hence, in order to use TSC after ADC operation, it was necessary to
>  save and re-enable TSC steps (basically, to keep TSC steps enabled always).
> The change was more of a workaround to overcome limitation of TSC irq handler. With 
> this series of patches, TSC irq handler is very reliable and the workaround is no longer required.

Okay, thanks for the explanation.

By the way, your mailer doesn't appear to quote previous messages.  Is
there any way to fix that?

> >  	am335x_tscadc_need_adc(tsadc);
> >  
> >  	tscadc_writel(tsadc, REG_SE, val);
> > diff --git a/include/linux/mfd/ti_am335x_tscadc.h 
> > b/include/linux/mfd/ti_am335x_tscadc.h
> > index c99be5dc0f5c..fcce182e4a35 100644
> > --- a/include/linux/mfd/ti_am335x_tscadc.h
> > +++ b/include/linux/mfd/ti_am335x_tscadc.h
> > @@ -128,6 +128,7 @@
> >  
> >  /* Sequencer Status */
> >  #define SEQ_STATUS BIT(5)
> > +#define CHARGE_STEP		0x11
> >  
> >  #define ADC_CLK			3000000
> >  #define TOTAL_STEPS		16
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
