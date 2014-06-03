Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbaFCIM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 04:12:27 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:49227 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680AbaFCIMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 04:12:24 -0400
MIME-Version: 1.0
In-Reply-To: <1401725505-3459-2-git-send-email-c@24.io>
References: <1401725505-3459-1-git-send-email-c@24.io>
	<1401725505-3459-2-git-send-email-c@24.io>
Date: Tue, 3 Jun 2014 10:12:23 +0200
X-Google-Sender-Auth: uFGM0gBgMXh2l32guwcD3Y66Flo
Message-ID: <CAMuHMdW1YnLVyZbmD0fadc6KX=EcH4CArC1379CDGb9ACm=GbQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] Staging: rtl8192u: r8192U_wx.c Removed all C99 comments
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chaitanya Hazarey <c@24.io>
Cc: Greg KH <gregkh@linuxfoundation.org>, burzalodowa@gmail.com,
        andrea.merello@gmail.com, driverdevel <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chaitanya,

On Mon, Jun 2, 2014 at 6:11 PM, Chaitanya Hazarey <c@24.io> wrote:
> To address the error -
>
> ERROR: do not use C99 // comments
>
> Removed all C99 comments.

IMHO, blindly converting C99 comments is a good idea...

> --- a/drivers/staging/rtl8192u/r8192U_wx.c
> +++ b/drivers/staging/rtl8192u/r8192U_wx.c
> @@ -180,8 +180,8 @@ static int r8192_wx_set_crcmon(struct net_device *dev,
>               priv->crcmon ? "accepted" : "rejected");
>
>         if (prev != priv->crcmon && priv->up) {
> -               //rtl8180_down(dev);
> -               //rtl8180_up(dev);
> +               /* rtl8180_down(dev); */
> +               /* rtl8180_up(dev); */

These calls were probably commented out for a reason. Keeping the
"//" makes them stand out, so hopefully one day someone will look into them.

>         }
>
>         up(&priv->wx_sem);
> @@ -249,15 +249,15 @@ static int rtl8180_wx_get_range(struct net_device *dev,
>         /* ~5 Mb/s real (802.11b) */
>         range->throughput = 5 * 1000 * 1000;
>
> -       // TODO: Not used in 802.11b?
> -//     range->min_nwid;        /* Minimal NWID we are able to set */
> -       // TODO: Not used in 802.11b?
> -//     range->max_nwid;        /* Maximal NWID we are able to set */
> +       /* TODO: Not used in 802.11b? */
> +       /* range->min_nwid; */  /* Minimal NWID we are able to set */
> +       /* TODO: Not used in 802.11b? */
> +       /* range->max_nwid; */  /* Maximal NWID we are able to set */

These are OK, the "TODO" is a good indicator.

>         /* Old Frequency (backward compat - moved lower ) */
> -//     range->old_num_channels;
> -//     range->old_num_frequency;
> -//     range->old_freq[6]; /* Filler to keep "version" at the same offset */
> +       /* range->old_num_channels; */
> +       /* range->old_num_frequency; */
> +       /* range->old_freq[6]; */ /* Filler to keep "version" at the same offset */

Please keep the "//" as an indicator.

>         if (priv->rf_set_sens != NULL)
>                 range->sensitivity = priv->max_sens;    /* signal level threshold range */
>
> @@ -292,26 +292,26 @@ static int rtl8180_wx_get_range(struct net_device *dev,
>         range->we_version_compiled = WIRELESS_EXT;
>         range->we_version_source = 16;
>
> -//     range->retry_capa;      /* What retry options are supported */
> -//     range->retry_flags;     /* How to decode max/min retry limit */
> -//     range->r_time_flags;    /* How to decode max/min retry life */
> -//     range->min_retry;       /* Minimal number of retries */
> -//     range->max_retry;       /* Maximal number of retries */
> -//     range->min_r_time;      /* Minimal retry lifetime */
> -//     range->max_r_time;      /* Maximal retry lifetime */
> +       /* range->retry_capa; */        /* What retry options are supported */
> +       /* range->retry_flags; */       /* How to decode max/min retry limit */
> +       /* range->r_time_flags; */      /* How to decode max/min retry life */
> +       /* range->min_retry; */         /* Minimal number of retries */
> +       /* range->max_retry; */         /* Maximal number of retries */
> +       /* range->min_r_time; */        /* Minimal retry lifetime */
> +       /* range->max_r_time; */        /* Maximal retry lifetime */

Same here.

>         for (i = 0, val = 0; i < 14; i++) {
>
> -               // Include only legal frequencies for some countries
> +               /* Include only legal frequencies for some countries */

Converting normal comments is OK.

>                 if ((GET_DOT11D_INFO(priv->ieee80211)->channel_map)[i+1]) {
>                         range->freq[val].i = i + 1;
>                         range->freq[val].m = ieee80211_wlan_frequencies[i] * 100

What do other people think?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
