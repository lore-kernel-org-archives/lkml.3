Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab3LPT7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 14:59:13 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:58860 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab3LPT7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 14:59:12 -0500
Date: Mon, 16 Dec 2013 11:59:10 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 1/7] Input: pmic8xxx-pwrkey - Pass input device
 directly to interrupt
Message-ID: <20131216195910.GQ21983@codeaurora.org>
References: <1386718996-3733-1-git-send-email-sboyd@codeaurora.org>
 <1386718996-3733-2-git-send-email-sboyd@codeaurora.org>
 <20131215112103.GA14818@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131215112103.GA14818@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15, Dmitry Torokhov wrote:
> Hi Stephen,
> 
> On Tue, Dec 10, 2013 at 03:43:10PM -0800, Stephen Boyd wrote:
> > Instead of passing the pointer to the container structure just
> > pass the input device here. This saves a dereference in the fast
> > path.
> > 
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > ---
> >  drivers/input/misc/pmic8xxx-pwrkey.c | 22 ++++++++--------------
> >  1 file changed, 8 insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/input/misc/pmic8xxx-pwrkey.c b/drivers/input/misc/pmic8xxx-pwrkey.c
> > index ce3c426..233b216 100644
> > --- a/drivers/input/misc/pmic8xxx-pwrkey.c
> > +++ b/drivers/input/misc/pmic8xxx-pwrkey.c
> > @@ -32,26 +32,21 @@
> >   * @key_press_irq: key press irq number
> >   */
> >  struct pmic8xxx_pwrkey {
> > -	struct input_dev *pwr;
> 
> This causes compile errors as you need pwrkey->pwr in remove() to
> unregister input device. I'll fix it up.
> 

Ah sorry. I forgot to send the patch before this that converts it
to devm.

> >  	err = devm_request_irq(&pdev->dev, key_press_irq, pwrkey_press_irq,
> > -		IRQF_TRIGGER_RISING, "pmic8xxx_pwrkey_press", pwrkey);
> > +		IRQF_TRIGGER_RISING, "pmic8xxx_pwrkey_press", pwr);

As you can see here because this driver isn't currently using
devm_request_irq().

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
