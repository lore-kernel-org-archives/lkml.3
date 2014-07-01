Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963AbaGAPhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 11:37:53 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:36211 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756675AbaGAPhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 11:37:51 -0400
MIME-Version: 1.0
In-Reply-To: <1404219616-1788-3-git-send-email-mpappas@fastmail.fm>
References: <1404219616-1788-1-git-send-email-mpappas@fastmail.fm> <1404219616-1788-3-git-send-email-mpappas@fastmail.fm>
From: Ben Chan <benchan@chromium.org>
Date: Tue, 1 Jul 2014 08:37:31 -0700
X-Google-Sender-Auth: lcVDRx3a51AxoWxreYWgWyZT0Y8
Message-ID: <CAC5Y2nNhQvDve4SiV7Eat9t_82S3S26sU+p4R=vGQ2hk4tdAMg@mail.gmail.com>
Subject: Re: [PATCH] staging: gdm72xx: move T_CAPABILITY bit definitions to hci.h
To: Michalis Pappas <mpappas@fastmail.fm>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2014 at 6:00 AM, Michalis Pappas <mpappas@fastmail.fm> wrote:
> Signed-off-by: Michalis Pappas <mpappas@fastmail.fm>
> ---
>  drivers/staging/gdm72xx/gdm_wimax.c | 10 +++-------
>  drivers/staging/gdm72xx/hci.h       |  6 ++++++
>  2 files changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
> index 63a760b..1fc64a9 100644
> --- a/drivers/staging/gdm72xx/gdm_wimax.c
> +++ b/drivers/staging/gdm72xx/gdm_wimax.c
> @@ -600,10 +600,6 @@ static void gdm_wimax_prepare_device(struct net_device *dev)
>         u16 len = 0;
>         u32 val = 0;
>
> -       #define BIT_MULTI_CS    0
> -       #define BIT_WIMAX               1
> -       #define BIT_QOS                 2
> -       #define BIT_AGGREGATION 3
>
>         /* GetInformation mac address */
>         len = 0;
> @@ -612,12 +608,12 @@ static void gdm_wimax_prepare_device(struct net_device *dev)
>         hci->length = H2B(len);
>         gdm_wimax_send(nic, hci, HCI_HEADER_SIZE+len);
>
> -       val = (1<<BIT_WIMAX) | (1<<BIT_MULTI_CS);
> +       val = (1 << T_CAPABILITY_BIT_WIMAX) | (1 << T_CAPABILITY_BIT_MULTI_CS);
>         #if defined(CONFIG_WIMAX_GDM72XX_QOS)
> -       val |= (1<<BIT_QOS);
> +       val |= (1 << T_CAPABILITY_BIT_QOS);
>         #endif
>         #if defined(CONFIG_WIMAX_GDM72XX_WIMAX2)
> -       val |= (1<<BIT_AGGREGATION);
> +       val |= (1 << T_CAPABILITY_BIT_AGGREGATION);
>         #endif

[Ben] We can simply the code by defining these constants as bitmasks
instead, e.g.

T_CAPABILITY_MULTI_CS  (1 << 0)
T_CAPABILITY_WIMAX  (1 << 1)
T_CAPABILITY_QOS  (1 << 2)
T_CAPABILITY_AGGREGATION  (1 << 3)

>         /* Set capability */
> diff --git a/drivers/staging/gdm72xx/hci.h b/drivers/staging/gdm72xx/hci.h
> index 059ba00..0cdd1fc 100644
> --- a/drivers/staging/gdm72xx/hci.h
> +++ b/drivers/staging/gdm72xx/hci.h
> @@ -198,6 +198,12 @@
>  #define T_FFTSIZE                      (0xda   | (4 << 16))
>  #define T_DUPLEX_MODE                  (0xdb   | (4 << 16))
>
> +/* T_CAPABILITY */
> +#define T_CAPABILITY_BIT_MULTI_CS      0
> +#define T_CAPABILITY_BIT_WIMAX         1
> +#define T_CAPABILITY_BIT_QOS           2
> +#define T_CAPABILITY_BIT_AGGREGATION   3
> +
>  struct hci_s {
>         unsigned short cmd_evt;
>         unsigned short length;
> --
> 1.8.4
>
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
