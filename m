Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbaILS6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 14:58:05 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:51391 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbaILS6C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:58:02 -0400
MIME-Version: 1.0
In-Reply-To: <20140912090918.6e860198@ipc1.ka-ro>
References: <1410248433-24005-1-git-send-email-LW@KARO-electronics.de>
 <1410248433-24005-3-git-send-email-LW@KARO-electronics.de>
 <CAK5ve-+BCvfHZ-JrYD_48KYzaZGE0as=eMe0+XPbgh5DfH9qRw@mail.gmail.com> <20140912090918.6e860198@ipc1.ka-ro>
From: Bryan Wu <cooloney@gmail.com>
Date: Fri, 12 Sep 2014 11:57:40 -0700
Message-ID: <CAK5ve-+jhyM_rYU_TeFojmFc1BZdEpgoYw2OBXgMv6LOGA7U8g@mail.gmail.com>
Subject: Re: [PATCH 2/2] leds: trigger: gpio: make ledtrig-gpio useable with
 GPIO drivers requiring threaded irqs
To: =?UTF-8?Q?Lothar_Wa=C3=9Fmann?= <LW@karo-electronics.de>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 12:09 AM, Lothar Waßmann <LW@karo-electronics.de> wrote:
> Hi,
>
> Bryan Wu wrote:
>> On Tue, Sep 9, 2014 at 12:40 AM, Lothar Waßmann <LW@karo-electronics.de> wrote:
>> > When trying to use the LED GPIO trigger with e.g. the PCA953x GPIO
>> > driver, request_irq() fails with -EINVAL, because the GPIO driver
>> > requires a nested interrupt handler.
>> >
>> > Use request_any_context_irq() to be able to use any GPIO driver as LED
>> > trigger.
>> >
>>
>> Hmmm, what about use request_thread_irq() and put the gpio_trig_work()
>> in as the thread_func.
>>
>> Felipe, can you take a look at this?
>>
>> Also in the first patch:
>> Actually in gpio_trig_irq(), it said:
>> /* just schedule_work since gpio_get_value can sleep */
>>         schedule_work(&gpio_data->work);
>>
>> Then that means we need to call gpio_get_value_can_sleep() in the
>> gpio_trig_work() instead of gpio_get_value(), right?
>>
> That's exactly what my first patch does!
>

Yeah, exactly. I'm just curious about the comment here.

-Bryan

>
> Lothar Waßmann
> --
> ___________________________________________________________
>
> Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
> Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
> Geschäftsführer: Matthias Kaussen
> Handelsregistereintrag: Amtsgericht Aachen, HRB 4996
>
> www.karo-electronics.de | info@karo-electronics.de
> ___________________________________________________________
