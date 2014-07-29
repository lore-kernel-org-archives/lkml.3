Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaG2SON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 14:14:13 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:64181 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaG2SOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 14:14:09 -0400
MIME-Version: 1.0
In-Reply-To: <1406375969-4453-1-git-send-email-przemo@firszt.eu>
References: <1406375969-4453-1-git-send-email-przemo@firszt.eu>
Date: Tue, 29 Jul 2014 14:14:07 -0400
Message-ID: <CAN+gG=FGkPRCoGOq91b3rzN2RZMTmeHy5fRcJu2xcdvHF3-aWg@mail.gmail.com>
Subject: Re: [PATCH 1/2] Input - Wacom: Fix transfer header problem
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Przemo Firszt <przemo@firszt.eu>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pinglinux@gmail.com>,
        Jason Gerecke <killertofu@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2014 at 7:59 AM, Przemo Firszt <przemo@firszt.eu> wrote:
> Header of transfer of image is different depending on connection type.
> That patch should be probably merged with 462c52a8cbcc62c
> Input - wacom: Check for bluetooth protocol while setting OLEDs
>
> Signed-off-by: Przemo Firszt <przemo@firszt.eu>
> ---

Thanks Przemo. I'll merge this one in the v3 of the wacom/BT/USB merge.
I'll let you add your s-o-b line once the patches will be on the list (soonish).

Cheers,
Benjamin

>  drivers/hid/wacom_sys.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
> index 42f139f..51437e2 100644
> --- a/drivers/hid/wacom_sys.c
> +++ b/drivers/hid/wacom_sys.c
> @@ -19,6 +19,7 @@
>
>  #define WAC_CMD_LED_CONTROL    0x20
>  #define WAC_CMD_ICON_START     0x21
> +#define WAC_CMD_ICON_BT_XFER   0x26
>  #define WAC_CMD_ICON_XFER      0x23
>  #define WAC_CMD_RETRIES                10
>
> @@ -550,7 +551,7 @@ static int wacom_led_putimage(struct wacom *wacom, int button_id,
>         if (retval < 0)
>                 goto out;
>
> -       buf[0] = WAC_CMD_ICON_XFER;
> +       buf[0] = len == 256 ? WAC_CMD_ICON_BT_XFER : WAC_CMD_ICON_XFER;
>         buf[1] = button_id & 0x07;
>         for (i = 0; i < 4; i++) {
>                 buf[2] = i;
> --
> 1.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
