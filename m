Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab3LLU1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:27:36 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:12647 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751526Ab3LLU1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:27:34 -0500
Date: Thu, 12 Dec 2013 20:24:17 -0800
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Stephen Boyd <sboyd@codeaurora.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/3] pinctrl: Add msm8x74 configuration
Message-ID: <20131213042416.GL11990@sonymobile.com>
References: <1386295805-13708-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1386295805-13708-3-git-send-email-bjorn.andersson@sonymobile.com>
 <52A24E08.706@codeaurora.org>
 <20131210084140.GF11990@sonymobile.com>
 <52A7C4BB.6000701@codeaurora.org>
 <CACRpkdY9Z71VcS6ERiaDbg9P7qPEK_jCVXLvoCDx6YztYCnR2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CACRpkdY9Z71VcS6ERiaDbg9P7qPEK_jCVXLvoCDx6YztYCnR2Q@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 12 Dec 11:15 PST 2013, Linus Walleij wrote:

> On Wed, Dec 11, 2013 at 2:49 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
...
> > I don't follow what Linus is recommending. How could
> > .gpio_request_enable()/.gpio_disable_free() help us here?
> 
> That removes the need to define a single group for each pin that
> can be used as GPIO.

For the TLMM chip the pin can not be used as GPIO when another function is
selected for the pin. And upon leaving a state with a function defined the
choosen mux is disabled, turning the pin back to a GPIO pin.
So I don't think this is applicable for us, any unused pin is a GPIO pin.


The reason why there are 1 pingroup per pin is because a pingroup represent
a configurable entity, i.e. a config register in the TLMM chip; which is one
per pin for the GPIO pins.

Regards,
Bjorn
