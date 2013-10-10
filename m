Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab3JJQLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:11:33 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:51140 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411Ab3JJQLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 12:11:30 -0400
MIME-Version: 1.0
In-Reply-To: <20131010160018.GA29913@atomide.com>
References: <20131003054104.8941.88857.stgit@localhost>
	<20131003054221.8941.87801.stgit@localhost>
	<5256AA7F.8030005@ti.com>
	<20131010160018.GA29913@atomide.com>
Date: Thu, 10 Oct 2013 18:11:29 +0200
Message-ID: <CACRpkdaG-PQA39XSjKUgM9TyeD7srgm_8s+NazrDKJ0gmNLcwg@mail.gmail.com>
Subject: Re: [PATCH 4/6] pinctrl: single: Add support for wake-up interrupts
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Roger Quadros <rogerq@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Prakash Manjunathappa <prakash.pm@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 6:00 PM, Tony Lindgren <tony@atomide.com> wrote:
> * Roger Quadros <rogerq@ti.com> [131010 06:32]:
>>
>> I tried testing this with the USB EHCI driver, but I'm not getting wake up interrupts
>> while the system is still running and only the EHCI controller is runtime suspended.
>>
>> It seems we need to somehow call _reconfigure_io_chain() to update the daisy chain
>> whenever the pad wakeup_enable bit is changed.
>
> Sounds like this is on omap3? Have you tried calling pcs_soc->rearm() in the
> pcs_irq_handle() like the comments there suggest? At least for me that keeps
> the wake-up interrupts continuously running on omap3 instead of just idle modes.

If the rearm() function is calling this _reconfigure_io_chain my comments
on the fact that this is something that should be handled by the pin
control driver still apply I think ....

Yours,
Linus Walleij
