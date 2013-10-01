Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab3JARNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 13:13:16 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:53178 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab3JARNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 13:13:12 -0400
MIME-Version: 1.0
In-Reply-To: <20130927074950.GA25098@xps8300>
References: <1380069549-9176-1-git-send-email-tim.kryger@linaro.org>
	<20130925114232.GA26259@xps8300>
	<CAAYSxhpXNj4Jo9puhc56EkaXKEg=XjNYG_iwX0FDgpLyySWiZg@mail.gmail.com>
	<20130927074950.GA25098@xps8300>
Date: Tue, 1 Oct 2013 10:13:11 -0700
Message-ID: <CAAYSxhqMGOspc7Y1QEa68W2ADpf-k33SOH4nHWhnis_71cyKsQ@mail.gmail.com>
Subject: Re: [PATCH] serial: 8250_dw: Improve unwritable LCR workaround
From: Tim Kryger <tim.kryger@linaro.org>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 12:49 AM, Heikki Krogerus
<heikki.krogerus@linux.intel.com> wrote:

> OK. The LCR issue is only a problem when the UART is configured with
> the busy functionality (UART_16550_COMPATIBLE == NO). Otherwise LRC is
> always accessible and this is not necessary.

Reading through the latest DW databook, I believe you are correct.

> We need a flag for the UART_16550_COMPATIBLE configuration, and
> use this WA based on that.

If I adjust the workaround to force the UART idle only when an LCR
write was ignored rather than doing it prior to any LCR write, would
that address your concerns?
