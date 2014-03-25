Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbaCYUhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 16:37:53 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:58029 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbaCYUhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 16:37:51 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdY3ctcLNhpSWtuqj=d48_fqDyNzG9nGAorpAbwjAnOJUw@mail.gmail.com>
References: <1395345324-18299-1-git-send-email-bigeasy@linutronix.de>
	<1395345324-18299-2-git-send-email-bigeasy@linutronix.de>
	<CACRpkdY3ctcLNhpSWtuqj=d48_fqDyNzG9nGAorpAbwjAnOJUw@mail.gmail.com>
Date: Tue, 25 Mar 2014 21:37:50 +0100
Message-ID: <CACRpkdbu6LKLntP2J=ypLTrAYscvzf5WjPYb-E+RKH_vAPEYHg@mail.gmail.com>
Subject: Re: [PATCH 1/3] gpio: dwapb: drop irq_setup_generic_chip()
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jamie Iles <jamie@jamieiles.com>
Cc: Alan Tull <atull@altera.com>, Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aha Jamie not even on the original thread. Here.

On Tue, Mar 25, 2014 at 9:37 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Mar 20, 2014 at 8:55 PM, Sebastian Andrzej Siewior
> <bigeasy@linutronix.de> wrote:
>
>> This looks kinda wrong I didn't manage to fully test it.
>> The driver calls irq_alloc_domain_generic_chips() which creates a gc and
>> adds it to gc_list. The driver later then calls irq_setup_generic_chip()
>> which also initializes the gc and adds it to the gc_list() and this
>> corrupts the list.
>> I can't find a single chip in tree which uses both functions so I think
>> that irq_setup_generic_chip() can be dropped.
>>
>> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>
> Jamie: comments?
>
> Can you instead of this try to use my new generic gpiolib
> irqchip helpers that I just merged to the GPIO tree?
>
> Yours,
> Linus Walleij
