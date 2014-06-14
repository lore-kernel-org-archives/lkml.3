Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbaFNOPc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 10:15:32 -0400
Received: from arrakis.dune.hu ([78.24.191.176]:48819 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754683AbaFNOPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 10:15:31 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Jun 2014 10:15:29 EDT
MIME-Version: 1.0
In-Reply-To: <20140614114813.GA8466@witts-MacBook-Pro.local>
References: <20140614114813.GA8466@witts-MacBook-Pro.local>
From: Jonas Gorski <jogo@openwrt.org>
Date: Sat, 14 Jun 2014 16:08:27 +0200
Message-ID: <CAOiHx=k7=ExZgY=RcKE3t0i5xzF3TKjDfRBkvQZK5B=XMtbkOg@mail.gmail.com>
Subject: Re: [PATCH 2/2] staging: rtl8712: use kcalloc instead of kmalloc(x*y, ...)
To: Vitaly Osipov <vitaly.osipov@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2014 at 1:48 PM, Vitaly Osipov <vitaly.osipov@gmail.com> wrote:
> Replaced kmalloc(x*y, ...) with kcalloc(x,y,...)
>
> Signed-off-by: Vitaly Osipov <vitaly.osipov@gmail.com>
> ---
>  drivers/staging/rtl8712/rtl871x_mlme.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/staging/rtl8712/rtl871x_mlme.c b/drivers/staging/rtl8712/rtl871x_mlme.c
> index 26b8f37..8561841 100644
> --- a/drivers/staging/rtl8712/rtl871x_mlme.c
> +++ b/drivers/staging/rtl8712/rtl871x_mlme.c
> @@ -62,8 +62,7 @@ static sint _init_mlme_priv(struct _adapter *padapter)
>         _init_queue(&(pmlmepriv->scanned_queue));
>         set_scanned_network_val(pmlmepriv, 0);
>         memset(&pmlmepriv->assoc_ssid, 0, sizeof(struct ndis_802_11_ssid));
> -       pbuf = kmalloc(MAX_BSS_CNT * (sizeof(struct wlan_network)),
> -                      GFP_ATOMIC);
> +       pbuf = kcalloc(MAX_BSS_CNT, sizeof(struct wlan_network), GFP_ATOMIC);

kcalloc() additionally zeroes the memory, so this is a change in
behaviour. A better replacement would be kmalloc_array().


Jonas
