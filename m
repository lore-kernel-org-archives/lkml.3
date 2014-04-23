Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaDWIwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:52:50 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:37802 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaDWIwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:52:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140417104409.GL28725@lee--X1>
References: <1397659455-13638-1-git-send-email-linus.walleij@linaro.org>
	<1397659455-13638-4-git-send-email-linus.walleij@linaro.org>
	<20140417104409.GL28725@lee--X1>
Date: Wed, 23 Apr 2014 10:52:47 +0200
Message-ID: <CACRpkdayYN73f+sQfr3bgTygWvUPDeDVp3kdzF39gnc++nS=qQ@mail.gmail.com>
Subject: Re: [PATCH 3/6] mfd: stmpe: prope properly from the device tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silvio F <silvio.fricke@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 12:44 PM, Lee Jones <lee.jones@linaro.org> wrote:

>> +#ifdef CONFIG_OF
>
> Didn't you say that the only platform using this device is DT only? So
> why don't we make the driver depend on OF and get rid of this ugly
> #ifdeffery?

OK fixing.

>> +     {
>> +             .compatible = "st,stmpe2403",
>> +             .data = (void *)STMPE2403,
>> +     },
>> +     {},
>> +};
>
> If none of these stray over 80 chars, I think I'd like to see
> of_device_id tables as single line entries

OK.

>> +     if (partnum < 0)
>> +             partnum = id->driver_data;
>
> Should this be able to fail and for us to still carry on?

Actually yes, to stay compatible with elder device trees that use
the trick to just have the node name correspond to the I2C ID
instead of using compatible, this needs to be preserved. But I'll
add a small nag print about it.

Yours,
Linus Walleij
