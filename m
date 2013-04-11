Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762683Ab3DKHuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 03:50:18 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:60827 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab3DKHuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 03:50:17 -0400
Message-ID: <51666B33.4070702@free-electrons.com>
Date: Thu, 11 Apr 2013 09:50:11 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>, jimwall@q.com,
        brian@crystalfontz.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio: pca953x: fix irq_domain_add_simple usage
References: <1365010814-3263-1-git-send-email-alexandre.belloni@free-electrons.com> <CACRpkdY=gJMCQ-qskDwXFg9cQH02+fZ00zU+=2cRdHE71cT9hw@mail.gmail.com>
In-Reply-To: <CACRpkdY=gJMCQ-qskDwXFg9cQH02+fZ00zU+=2cRdHE71cT9hw@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Le 10/04/2013 22:54, Linus Walleij a écrit :
> On Wed, Apr 3, 2013 at 7:40 PM, Alexandre Belloni
> <alexandre.belloni@free-electrons.com> wrote:
> 
>> We actually have to pass chip as the host_data parameter of
>> irq_domain_add_simple() as later on, it is used to initialize chip_data
>> in pca953x_gpio_irq_map(). Failing to do so is leading to a NULL pointer
>> dereference after calling irq_data_get_irq_chip_data() in
>> pca953x_irq_mask(), pca953x_irq_unmask(), pca953x_irq_bus_lock(),
>> pca953x_irq_bus_sync_unlock() and pca953x_irq_set_type().
>>
>> Fixes regression introduced by commit
>> 0e8f2fdacf1d44651aa7e57063c76142d1f4988b (gpio: pca953x: use simple
>> irqdomain)
>>
>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>> ---
>>
>> This would probably be good to introduce that patch in the next 3.9 rc as the
>> regression leads to a lot of breakage (and cursing).
> 
> OK patch applied let's see if I get it to Torvalds in time.
> 
> Can I have some ACK from Maxime?

Sure,
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
