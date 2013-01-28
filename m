Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab3A1I2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 03:28:47 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:62449 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab3A1I2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 03:28:43 -0500
MIME-Version: 1.0
In-Reply-To: <CAOAMb1AsetjcNa_K6g=6K_s=0+tTH1aGLuX8emYrfgJOcx54cw@mail.gmail.com>
References: <CAOAMb1AsetjcNa_K6g=6K_s=0+tTH1aGLuX8emYrfgJOcx54cw@mail.gmail.com>
Date: Mon, 28 Jan 2013 09:28:42 +0100
Message-ID: <CACRpkdaECZ5qtUVS=28eDyzLWvxx=mP6dWML5mYs9kwqnhEoJQ@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: PL011: Add support for Rx DMA buffer polling
From: Linus Walleij <linus.walleij@linaro.org>
To: Chanho Min <chanho.min@lge.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>, linux-serial@vger.kernel.org,
        Chanho Min <chanho0207@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 9:15 AM, Chanho Min <chanho.min@lge.com> wrote:
> [Russell]
>>Well, I thought I had explained that I'd prefer to see the poll rate
>>adjusted with the baud rate, but maybe I wasn't explicit enough.
>>Instead, what we seem to have ended up with are two new entries in
>>platform data (which we're trying to get away from with DT):
>>
>>+       unsigned int dma_rx_poll_rate;
>>+       unsigned int dma_rx_poll_timeout;
>>
>>If this were to be done, then receive DMA could be used on the Versatile
>>PB platforms without having it suck CPU usage unnecessarily at slower
>>baud rates.
> This patch is working well on our pl011+ pl080 platform.
> If no data is received during time-out, no tick timer works.
> Do you want to adjust the poll rate with the baud rate additionally?

I'm not following, you wrote earlier in the thread:

>>Should we scale the polling interval according to baud
>>rate?
>
> It is also our concern, I will suggest the proper way.

We are waiting for you suggestion, i.e. a new patch iteration
taking this into account.

Yours,
Linus Walleij
