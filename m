Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab3BVTGY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 14:06:24 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:61473 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783Ab3BVTGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 14:06:21 -0500
MIME-Version: 1.0
In-Reply-To: <1361555907-19840-12-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
	<1361555907-19840-12-git-send-email-nick.dyer@itdev.co.uk>
Date: Fri, 22 Feb 2013 11:06:21 -0800
X-Google-Sender-Auth: 2pi81XuuETepjWSPS90O3JqwSM0
Message-ID: <CANLzEkusmqAFSybWd+xbLYbUu+5rcih7AW024eCpZ7AFb-+UCw@mail.gmail.com>
Subject: Re: [PATCH 11/40] Input: atmel_mxt_ts - Bootloader addresses for mXT1664/mXT1188S
From: Benson Leung <bleung@chromium.org>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        "Bowens, Alan" <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Olof Johansson <olofj@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is disappointing that Atmel decided to change the bootloader
address scheme for the 1664S family. Unfortunately, this ifdef won't
work for situations where there are more than one Atmel device of a
different kind on a system using this same driver.

For the Chromebook Pixel, we use the same atmel_mxt_ts driver for a
1664S device and a 224SL.

The 1664S has the pair 0x26 and 0x4a, while the 224SL has 0x25 and 0x4b.

Benson

On Fri, Feb 22, 2013 at 9:57 AM, Nick Dyer <nick.dyer@itdev.co.uk> wrote:
> The mXT1664S family chips use different mappings for bootloader addresses.
>
> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
> ---
>  drivers/input/touchscreen/atmel_mxt_ts.c |    5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index 16af68d..903ff54 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -281,12 +281,17 @@ struct mxt_i2c_address_pair {
>  };
>
>  static const struct mxt_i2c_address_pair mxt_i2c_addresses[] = {
> +#ifdef BOOTLOADER_1664_1188
> +       { 0x26, 0x4a },
> +       { 0x27, 0x4b },
> +#else
>         { 0x24, 0x4a },
>         { 0x25, 0x4b },
>         { 0x26, 0x4c },
>         { 0x27, 0x4d },
>         { 0x34, 0x5a },
>         { 0x35, 0x5b },
> +#endif
>  };
>
>  static bool mxt_object_readable(unsigned int type)
> --
> 1.7.10.4
>



--
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
