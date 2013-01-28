Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab3A1IP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 03:15:29 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:44043 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab3A1IP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 03:15:26 -0500
MIME-Version: 1.0
Date: Mon, 28 Jan 2013 17:15:23 +0900
X-Google-Sender-Auth: aZa1D2si_lxjqo__DfVnXggnxlc
Message-ID: <CAOAMb1AsetjcNa_K6g=6K_s=0+tTH1aGLuX8emYrfgJOcx54cw@mail.gmail.com>
Subject: RE: [PATCH v2] ARM: PL011: Add support for Rx DMA buffer polling
From: Chanho Min <chanho.min@lge.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        linux-serial@vger.kernel.org, Chanho Min <chanho0207@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Well, I thought I had explained that I'd prefer to see the poll rate
>adjusted with the baud rate, but maybe I wasn't explicit enough.
>Instead, what we seem to have ended up with are two new entries in
>platform data (which we're trying to get away from with DT):
>
>+       unsigned int dma_rx_poll_rate;
>+       unsigned int dma_rx_poll_timeout;
>
>If this were to be done, then receive DMA could be used on the Versatile
>PB platforms without having it suck CPU usage unnecessarily at slower
>baud rates.
This patch is working well on our pl011+ pl080 platform.
If no data is received during time-out, no tick timer works.
Do you want to adjust the poll rate with the baud rate additionally?
