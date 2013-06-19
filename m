Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965133Ab3FSSsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:48:08 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59250 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965018Ab3FSSsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:48:05 -0400
Message-ID: <51C1FBC5.1030109@ti.com>
Date: Wed, 19 Jun 2013 21:43:17 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Wolfram Sang <wsa@the-dreams.de>, Tony Lindgren <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 5/5] i2c: omap: remove omap_i2c_isr() hw irq handler
References: <1370630768-4077-1-git-send-email-grygorii.strashko@ti.com> <1370630768-4077-6-git-send-email-grygorii.strashko@ti.com> <20130607190750.GF15295@arwen.pp.htv.fi>
In-Reply-To: <20130607190750.GF15295@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On 06/07/2013 10:07 PM, Felipe Balbi wrote:
> Hi,
>
> On Fri, Jun 07, 2013 at 09:46:08PM +0300, Grygorii Strashko wrote:
>> The omap_i2c_isr() does the irq check and schedules threaded handler if any of
>> enabled IRQs is active, but currently the I2C IRQs are enabled just once,
>> when I2C IP is enabling (transfer started) and they aren't changed after that.
>> More over, now the I2C INTC IRQ is disabled when I2C IP is idled.
>> Thus, I2C IRQs will start coming only when we want that, and there is
>> no sense to have omap_i2c_isr() anymore:
> so ? we still want to check if this device generated IRQs in hardirq
> context. What if the IRQ line is shared ?
>
Pleas see, https://patchwork.kernel.org/patch/2689211/
[1/5] i2c: omap: fix spurious IRQs: disable/enable IRQ at INTC when idle

It covers shared IRQ problem

Sorry, for delayed reply - I've had problems with my e-mail.

- grygorii
