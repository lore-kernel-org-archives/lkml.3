Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab3A2ClK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 21:41:10 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:34320 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab3A2ClJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 21:41:09 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdaECZ5qtUVS=28eDyzLWvxx=mP6dWML5mYs9kwqnhEoJQ@mail.gmail.com>
References: <CAOAMb1AsetjcNa_K6g=6K_s=0+tTH1aGLuX8emYrfgJOcx54cw@mail.gmail.com>
	<CACRpkdaECZ5qtUVS=28eDyzLWvxx=mP6dWML5mYs9kwqnhEoJQ@mail.gmail.com>
Date: Tue, 29 Jan 2013 11:41:07 +0900
X-Google-Sender-Auth: rTFMKmQ2WO9PKpcOiAr-hqbEfAA
Message-ID: <CAOAMb1CCoOWgab7NYYYRVjoQBoBx4XDeeLOBjJ4RzsBwRpXv6Q@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: PL011: Add support for Rx DMA buffer polling
From: Chanho Min <chanho.min@lge.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>, linux-serial@vger.kernel.org,
        Chanho Min <chanho0207@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 5:28 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Mon, Jan 28, 2013 at 9:15 AM, Chanho Min <chanho.min@lge.com> wrote:
>> [Russell]
>>>Well, I thought I had explained that I'd prefer to see the poll rate
>>>adjusted with the baud rate, but maybe I wasn't explicit enough.
>>>Instead, what we seem to have ended up with are two new entries in
>>>platform data (which we're trying to get away from with DT):
>>>
>>>+       unsigned int dma_rx_poll_rate;
>>>+       unsigned int dma_rx_poll_timeout;

>>>Should we scale the polling interval according to baud
>>>rate?
>>
>> It is also our concern, I will suggest the proper way.

It was thought a way to reduce unnecessary cpu usage,
but, now we add dma_rx_poll_timeout to stop polling during idle.
I thought it is preferred  the poll rate is decided by it's user than
auto scale.
because The required response to tty can be differ from platform to platform.
Some platform need fast response even if more cpu usage is needed,
but other platform will be enough to handle  with slow response.

Any opinion will be appreciated.

Thanks
Chanho
