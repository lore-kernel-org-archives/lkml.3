Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaCYHzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 03:55:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:49553 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaCYHzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 03:55:00 -0400
Message-ID: <53313652.5010306@linutronix.de>
Date: Tue, 25 Mar 2014 08:54:58 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>
CC: atull@altera.com, Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dinguyen@altera.com, delicious.quinoa@gmail.com
Subject: Re: [PATCH 7/7] gpio: dwapb: use d->mask instead od BIT(bit)
References: <1395505004-22650-1-git-send-email-bigeasy@linutronix.de> <1395505004-22650-8-git-send-email-bigeasy@linutronix.de> <CAAVeFu+WQCpo=LEZqdAhpMcO1PLqUzfcVKTafnwe=BiLGLjFZQ@mail.gmail.com>
In-Reply-To: <CAAVeFu+WQCpo=LEZqdAhpMcO1PLqUzfcVKTafnwe=BiLGLjFZQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2014 03:17 AM, Alexandre Courbot wrote:
>> diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
>> index 3c9cdda..ebfcf5c 100644
>> --- a/drivers/gpio/gpio-dwapb.c
>> +++ b/drivers/gpio/gpio-dwapb.c
>> @@ -126,7 +126,7 @@ static void dwapb_irq_disable(struct irq_data *d)
>>
>>         irq_gc_lock(igc);
>>         val = readl(gpio->regs + GPIO_INTEN);
>> -       val &= ~BIT(d->hwirq);
>> +       val &= d->mask;
> 
> Shouldn't that be ~d->mask here?

Yes, indeed. Thanks for catching this.

Sebastian
