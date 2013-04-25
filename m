Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab3DYNVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:21:09 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:54234 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab3DYNVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:21:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130425130922.GE14496@n2100.arm.linux.org.uk>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-5-git-send-email-lee.jones@linaro.org>
	<CACRpkdaauDYTdoBHGG9FO4kKqvCYyCrjY8EGWs5gAQWErGW6_A@mail.gmail.com>
	<20130425090612.GC4623@gmail.com>
	<CACRpkdbV8yEK0470q_-DWv6Q0hAG2wGntXFi5kaLUMgm9b=e-Q@mail.gmail.com>
	<20130425130922.GE14496@n2100.arm.linux.org.uk>
Date: Thu, 25 Apr 2013 15:21:06 +0200
Message-ID: <CACRpkdZj-3DbcX1LREGKf2RZs4FqbDn6sWkaZ-t67KUKJhZaow@mail.gmail.com>
Subject: Re: [PATCH 04/32] dmaengine: ste_dma40: Amalgamate DMA source and
 destination channel numbers
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Rabin Vincent <rabin@rab.in>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>, Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Per Forlin <per.forlin@stericsson.com>, Dan Williams <djbw@fb.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 3:09 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:

> There's a problem with device to device transfers though - you have to
> consider the rate at which the devices produce and consume data, and
> whether they both can cope with differing data rates.
>
> Take for instance your audio in to audio out idea - even if they are
> both operating at the same bits per sample and sample rate, if they are
> independently clocked, chances are that the clocks are not exactly the
> same, which means you will either underrun or overrun one of the FIFOs
> in the system.

This magically works for us, but yes, I think they had to use the same
clock (simplest solution, anyway).

It is/was a very real usecase, IIRC coming from roundtrip constraints
in the GSM 3GPP spec, wanting to keep the latency as low as possible.
With this scheme there is no more than a FIFO on each end of delay,
which is nice.

Yours,
Linus Walleij
