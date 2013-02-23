Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab3BWGTB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 01:19:01 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:41663 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870Ab3BWGTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 01:19:00 -0500
Message-ID: <51285F51.5040902@linaro.org>
Date: Sat, 23 Feb 2013 07:18:57 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: john.stultz@linaro.org, tglx@linutronix.de, linus.walleij@stericsson.com,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        patches@linaro.org
Subject: Re: [PATCH] clocksource : nomadik-mtu : fix missing irq initialization
References: <1361547870-32638-1-git-send-email-daniel.lezcano@linaro.org> <CACRpkdYUC4UoZN0ZLcu4S=oma-vd46fbAqQNTFgisG24OPubVA@mail.gmail.com>
In-Reply-To: <CACRpkdYUC4UoZN0ZLcu4S=oma-vd46fbAqQNTFgisG24OPubVA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 06:21 PM, Linus Walleij wrote:
> On Fri, Feb 22, 2013 at 4:44 PM, Daniel Lezcano
> <daniel.lezcano@linaro.org> wrote:
> 
>> This patch fix the clock device irq field which is not initialized.
>>
>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> 
> Makes perfect sense:
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Sorry that I might have missed some background here or just be
> out-of-track with things, how did this driver work for years without
> the irq assigned? Or was this field recently introduced?

The irq is assigned through:

setup_irq(irq, &nmdk_timer_irq);

two lines above but the clockevent's irq field was not set.

I did not investigate a lot, but at the first glance it worked because
the code path used by the default kernel configuration (CONFIG_NO_HZ)
does not use this field.

But when using the dynamic irq affinity [1], I noticed it was set to 0.

[1] http://www.spinics.net/lists/arm-kernel/msg226371.html

Thanks
  -- Daniel


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

