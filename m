Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338AbaLOOWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:22:30 -0500
Received: from mail-oi0-f51.google.com ([209.85.218.51]:39005 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaLOOW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:22:27 -0500
Message-ID: <548EEE9F.4030508@gmail.com>
Date: Mon, 15 Dec 2014 08:22:23 -0600
From: Dinh Nguyen <dinh.linux@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ley Foon Tan <lftan@altera.com>
CC: Jassi Brar <jassisinghbrar@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Suman Anna <s-anna@ti.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH (resend)] mailbox: Add Altera mailbox driver
References: <CAFiDJ58uQifY7th-mzvm2mjgJdw_MWmWFFhDPYT9TomOexiVNw@mail.gmail.com>
In-Reply-To: <CAFiDJ58uQifY7th-mzvm2mjgJdw_MWmWFFhDPYT9TomOexiVNw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/15/14, 12:22 AM, Ley Foon Tan wrote:
> On Fri, Dec 12, 2014 at 10:38 PM, Dinh Nguyen <dinh.linux@gmail.com> wrote:
> 
>>> +
>>> +#include <linux/kernel.h>
>>> +#include <linux/module.h>
>>> +#include <linux/device.h>
>>> +#include <linux/platform_device.h>
>>> +#include <linux/interrupt.h>
>>> +#include <linux/io.h>
>>> +#include <linux/of.h>
>>> +#include <linux/mailbox_controller.h>
>>
>> Alphabetize the headers.
> Okay.
> 
> 
>>> +static int altera_mbox_startup_sender(struct mbox_chan *chan)
>>> +{
>>> +     int ret;
>>> +     struct altera_mbox *mbox = to_altera_mbox(chan);
>>> +
>>> +     if (mbox->intr_mode) {
>>> +             ret = request_irq(mbox->irq, altera_mbox_tx_interrupt, 0,
>>
>> Use devm_request_irq, since you didn't have and don't need use free_irq
>> in the shutdown function.
> We want to free_irq when it shutdown. That means nobody requests for
> that mailbox (or channel) and request_irq() again if someone requests
> for a mailbox.
> 

But you didn't have any free_irq in the shutdown function. Use
devm_request_irq here, so you don't have to add them.

Dinh
