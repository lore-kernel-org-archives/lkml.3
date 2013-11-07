Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab3KGQDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 11:03:41 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:58635 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab3KGQDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 11:03:39 -0500
MIME-Version: 1.0
In-Reply-To: <1383419089-31248-1-git-send-email-matthew@incomplete.io>
References: <1383419089-31248-1-git-send-email-matthew@incomplete.io>
Date: Thu, 7 Nov 2013 10:03:38 -0600
Message-ID: <CAGzDe_ZSVEkH0BaU1oZjPWjKuR02ibs=r+jQEU7hF-R68q7rfA@mail.gmail.com>
Subject: Re: [PATCH] INPUT: wacom: Added definition for Wacom CTH680 The Wacom
 Creative Pen & Touch Tablet M (CTH680, 056A:0303) is a newer revision of the
 Bamboo series. This patch adds product 0303 to wacom.ko.
From: Chris Bagwell <chris@cnpbagwell.com>
To: matthew@incomplete.io
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 2, 2013 at 2:04 PM,  <matthew@incomplete.io> wrote:
> From: Matthew Geddes <matthew@incomplete.io>
>

Your whole commit message appears to be crammed into first summary
line.  Could you please align with git conventions: put a line break
after "CTH680", a blank line, and then the remaining description
afterwards.

> Signed-off-by: Matthew Geddes <matthew@incomplete.io>
> ---
>  drivers/input/tablet/wacom_wac.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
> index c59b797..5015269 100644
> --- a/drivers/input/tablet/wacom_wac.c
> +++ b/drivers/input/tablet/wacom_wac.c
> @@ -2128,6 +2128,9 @@ static const struct wacom_features wacom_features_0x300 =
>  static const struct wacom_features wacom_features_0x301 =
>         { "Wacom Bamboo One M",    WACOM_PKGLEN_BBPEN,    21648, 13530, 1023,
>           31, BAMBOO_PT, WACOM_INTUOS_RES, WACOM_INTUOS_RES };
> +static const struct wacom_features wacom_features_0x303 =
> +       { "Wacom Creative Touch & Pen M", WACOM_PKGLEN_BBPEN, 21648, 13530,

A search for model CTH680 shows this device is the newly released
"Intuos Pen & Touch Medium"; which is also the new name for Bamboo's
and with new form factor.  I do see occasional site that added
Creative in there: "Intuos Creative Pen & Touch Medium".  Can you
confirm if this is the model you have?

I'd suggest using Wacom's terms closer (add in Intuos and swap Pen &
Touch to their order; maybe drop phrase Creative).

Also, the 21648/13530 values look copy&pasted from previous line.  Can
you use "evtest" or similar to find real maximum values.  Previous
"Bamboo Touch" models had 13700 as second number.  Since your tablet
has different shape from previous Bamboo and the "Bamboo One" then
there is good change you need unique values to get full usable area of
tablet.

> +         1023, 31, BAMBOO_PT, WACOM_INTUOS_RES, WACOM_INTUOS_RES };

Can you update patch to exactly follow form of structures surrounding
it?  Namely, put the "1023" value on first line like rest of lines do.

Thanks!
Chris


>  static const struct wacom_features wacom_features_0x6004 =
>         { "ISD-V4",               WACOM_PKGLEN_GRAPHIRE,  12800,  8000,  255,
>           0, TABLETPC, WACOM_INTUOS_RES, WACOM_INTUOS_RES };
> @@ -2258,6 +2261,7 @@ const struct usb_device_id wacom_ids[] = {
>         { USB_DEVICE_WACOM(0x10F) },
>         { USB_DEVICE_WACOM(0x300) },
>         { USB_DEVICE_WACOM(0x301) },
> +       { USB_DEVICE_WACOM(0x303) },
>         { USB_DEVICE_WACOM(0x304) },
>         { USB_DEVICE_WACOM(0x4001) },
>         { USB_DEVICE_WACOM(0x47) },
> --
> 1.8.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
