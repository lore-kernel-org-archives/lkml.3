Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484Ab3GZEax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 00:30:53 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:34762 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab3GZEar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 00:30:47 -0400
MIME-Version: 1.0
In-Reply-To: <1374691051-28544-4-git-send-email-sboyd@codeaurora.org>
References: <1374691051-28544-1-git-send-email-sboyd@codeaurora.org>
	<1374691051-28544-4-git-send-email-sboyd@codeaurora.org>
Date: Thu, 25 Jul 2013 20:30:46 -0800
Message-ID: <CAJAp7Og1jwyAn0sGbb_1Bk5_fvBWa1AuDNsRV1b17S0Tijk9kg@mail.gmail.com>
Subject: Re: [PATCH 3/4] msm_serial: Make baud_code detection more dynamic
From: Bjorn Andersson <bjorn@kryo.se>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 10:37 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> [snip]
> +       unsigned int i, divisor;
> +       const struct msm_baud_map *entry;
> +       static const struct msm_baud_map table[] = {
> +               { 1536, 0x00,  1 },
> +               {  768, 0x11,  1 },
> +               {  384, 0x22,  1 },
> +               {  192, 0x33,  1 },
> +               {   96, 0x44,  1 },
> +               {   48, 0x55,  1 },
> +               {   32, 0x66,  1 },
> +               {   24, 0x77,  1 },
> +               {   16, 0x88,  1 },
> +               {   12, 0x99,  6 },
> +               {    8, 0xaa,  6 },
> +               {    6, 0xbb,  6 },
> +               {    4, 0xcc,  6 },
> +               {    3, 0xdd,  8 },
> +               {    2, 0xee, 16 },
> +               {    1, 0xff, 31 },
> +       };
> +
> +       divisor = uart_get_divisor(port, baud);
> +
> +       for (i = 0, entry = table; i < ARRAY_SIZE(table); i++, entry++)
> +               if (entry->divisor <= divisor)
> +                       break;
> +
> +       return entry; /* Default to smallest divider */

Shouldn't matter, but you're not defaulting to the smallest divider.
Your are defaulting to an undefined value, as `entry` will be off the
array once i == ARRAY_SIZE().

Regards,
Bjorn
