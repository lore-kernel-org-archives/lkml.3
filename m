Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaD1AF3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 20:05:29 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:49160 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaD1AF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 20:05:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140426155315.GA4745@acer>
References: <20140426155315.GA4745@acer>
Date: Mon, 28 Apr 2014 09:05:28 +0900
Message-ID: <CAHb8M2B-xkTyBhaOsC=75UL8gVUd-uTtg5twmTAXRWge_7E+8g@mail.gmail.com>
Subject: Re: [PATCH next-20140424] staging/cxt1e1: sparse warning corrections
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Sami Laine <laine.j.sami@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-04-27 0:53 GMT+09:00 Sami Laine <laine.j.sami@gmail.com>:
> From: Sami Laine <laine.j.sami@gmail.com>
do not include this line on your patch. it is not necessary.
>
> Corrected sparse static declaration warnings.
>
> Signed-off-by: Sami Laine <laine.j.sami@gmail.com>
> ---
> diff --git a/drivers/staging/cxt1e1/hwprobe.c b/drivers/staging/cxt1e1/hwprobe.c
> index cc2151e..2899258 100644
> --- a/drivers/staging/cxt1e1/hwprobe.c
> +++ b/drivers/staging/cxt1e1/hwprobe.c
> @@ -40,10 +40,10 @@ struct net_device * __init c4_add_dev(hdw_info_t *, int, unsigned long,
>                                       unsigned long, int, int);
>
>
> -struct s_hdw_info hdw_info[MAX_BOARDS];
> +static struct s_hdw_info hdw_info[MAX_BOARDS];
hdw_info is used in other files with "extern".

>
>
> -void __init
> +static void __init
>  show_two(hdw_info_t *hi, int brdno)
>  {
>         ci_t       *ci;
> @@ -88,7 +88,7 @@ show_two(hdw_info_t *hi, int brdno)
>  }
>
>
> -void __init
> +static void __init
>  hdw_sn_get(hdw_info_t *hi, int brdno)
This function is used in "linux.c"
>  {
>         /* obtain hardware EEPROM information */
> @@ -145,7 +145,7 @@ hdw_sn_get(hdw_info_t *hi, int brdno)
>  }
>
>
> -       void __init
> +static void __init
>  prep_hdw_info(void)
>  {
>         hdw_info_t *hi;
> @@ -164,7 +164,7 @@ prep_hdw_info(void)
>         }
>  }
>
> -void
> +static void
>  cleanup_ioremap(void)
This function is used in "linux.c"
>  {
>         hdw_info_t *hi;
> @@ -187,7 +187,7 @@ cleanup_ioremap(void)
>  }

>
>
> -void
> +static void
>  cleanup_devs(void)
This function is used in "linux.c"

>  {
>         hdw_info_t *hi;
> @@ -287,7 +287,7 @@ c4_hdw_init(struct pci_dev *pdev, int found)
>         return 1;
>  }
>
> -status_t __init
> +static status_t __init
>  c4hw_attach_all(void)
This function is used in "linux.c"

>  {
>         hdw_info_t *hi;

And when you send a patch for this, please check maintainers with "
./scripts/get_maintainer.pl".
In case of this patch, my email is in CC list. :-)

Regards,
Daeseok Youn.
