Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbaILHJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 03:09:25 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:49353 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbaILHJX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 03:09:23 -0400
Date: Fri, 12 Sep 2014 09:09:18 +0200
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Bryan Wu <cooloney@gmail.com>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH 2/2] leds: trigger: gpio: make ledtrig-gpio useable with
 GPIO drivers requiring threaded irqs
Message-ID: <20140912090918.6e860198@ipc1.ka-ro>
In-Reply-To: <CAK5ve-+BCvfHZ-JrYD_48KYzaZGE0as=eMe0+XPbgh5DfH9qRw@mail.gmail.com>
References: <1410248433-24005-1-git-send-email-LW@KARO-electronics.de>
	<1410248433-24005-3-git-send-email-LW@KARO-electronics.de>
	<CAK5ve-+BCvfHZ-JrYD_48KYzaZGE0as=eMe0+XPbgh5DfH9qRw@mail.gmail.com>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Bryan Wu wrote:
> On Tue, Sep 9, 2014 at 12:40 AM, Lothar Waßmann <LW@karo-electronics.de> wrote:
> > When trying to use the LED GPIO trigger with e.g. the PCA953x GPIO
> > driver, request_irq() fails with -EINVAL, because the GPIO driver
> > requires a nested interrupt handler.
> >
> > Use request_any_context_irq() to be able to use any GPIO driver as LED
> > trigger.
> >
> 
> Hmmm, what about use request_thread_irq() and put the gpio_trig_work()
> in as the thread_func.
> 
> Felipe, can you take a look at this?
> 
> Also in the first patch:
> Actually in gpio_trig_irq(), it said:
> /* just schedule_work since gpio_get_value can sleep */
>         schedule_work(&gpio_data->work);
> 
> Then that means we need to call gpio_get_value_can_sleep() in the
> gpio_trig_work() instead of gpio_get_value(), right?
> 
That's exactly what my first patch does!


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
