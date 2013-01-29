Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab3A2K5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 05:57:37 -0500
Received: from mail-ia0-f176.google.com ([209.85.210.176]:60102 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab3A2K5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 05:57:35 -0500
MIME-Version: 1.0
In-Reply-To: <CAOAMb1CCoOWgab7NYYYRVjoQBoBx4XDeeLOBjJ4RzsBwRpXv6Q@mail.gmail.com>
References: <CAOAMb1AsetjcNa_K6g=6K_s=0+tTH1aGLuX8emYrfgJOcx54cw@mail.gmail.com>
	<CACRpkdaECZ5qtUVS=28eDyzLWvxx=mP6dWML5mYs9kwqnhEoJQ@mail.gmail.com>
	<CAOAMb1CCoOWgab7NYYYRVjoQBoBx4XDeeLOBjJ4RzsBwRpXv6Q@mail.gmail.com>
Date: Tue, 29 Jan 2013 11:57:35 +0100
Message-ID: <CACRpkdZw_Bvz86PeNyoSjFR=O0_KkM6uJBYZ-ZhVy_g0SKun7w@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: PL011: Add support for Rx DMA buffer polling
From: Linus Walleij <linus.walleij@linaro.org>
To: Chanho Min <chanho.min@lge.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>, linux-serial@vger.kernel.org,
        Chanho Min <chanho0207@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 3:41 AM, Chanho Min <chanho.min@lge.com> wrote:
> On Mon, Jan 28, 2013 at 5:28 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Mon, Jan 28, 2013 at 9:15 AM, Chanho Min <chanho.min@lge.com> wrote:
>>> [Russell]
>>>>Well, I thought I had explained that I'd prefer to see the poll rate
>>>>adjusted with the baud rate, but maybe I wasn't explicit enough.
>>>>Instead, what we seem to have ended up with are two new entries in
>>>>platform data (which we're trying to get away from with DT):
>>>>
>>>>+       unsigned int dma_rx_poll_rate;
>>>>+       unsigned int dma_rx_poll_timeout;
>
>>>>Should we scale the polling interval according to baud
>>>>rate?
>>>
>>> It is also our concern, I will suggest the proper way.
>
> It was thought a way to reduce unnecessary cpu usage,
> but, now we add dma_rx_poll_timeout to stop polling during idle.

During idle I guess any system want to set the UART into
IRQ mode? So it will wake up on some event on the
UART, whatever it may be.

Then it can use DMA polling post-wakeup?

> I thought it is preferred  the poll rate is decided by it's user than
> auto scale.

What do you mean by "user" here? Userspace? Or
"platform data parameter"?

I can se three usecases:

- Console or serial TTY
- Modem (as in 33k8 modem, needing RTS/CTS HW handshaking)
- Peripheral (like high-speed bluetooth chips) needing low-latency

The kernel already knows if the port is a console or TTY.

What you need to know is if it is one of the other two usecases.

> because The required response to tty can be differ from platform to platform.
> Some platform need fast response even if more cpu usage is needed,
> but other platform will be enough to handle  with slow response.

Not platform I think. Per usecase.

Are you not actually thinking about things like the above?
These are usecase requirements, not platform requirements.

For example I thing it is magnitude better idea to encode
something like an enum for these usecases that some
bool is_platform_foo_bt_uart or whatever the alternative
would be.

Yours,
Linus Walleij
