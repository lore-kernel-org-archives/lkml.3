Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbaIHNkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:40:08 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47781 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084AbaIHNkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:40:03 -0400
Date: Mon, 8 Sep 2014 08:39:49 -0500
From: Felipe Balbi <balbi@ti.com>
To: Kiran Kumar Raparthy <kiran.kumar@linaro.org>
CC: <linux-kernel@vger.kernel.org>, Todd Poynor <toddpoynor@google.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [RFC v3 2/2] usb: phy: Temporarily hold timed wakeup source on
 charger and disconnect events
Message-ID: <20140908133948.GI22409@saruman.home>
Reply-To: <balbi@ti.com>
References: <1410171049-14239-1-git-send-email-kiran.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jQIvE3yXcK9X9HBh"
Content-Disposition: inline
In-Reply-To: <1410171049-14239-1-git-send-email-kiran.kumar@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jQIvE3yXcK9X9HBh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 08, 2014 at 03:40:49PM +0530, Kiran Kumar Raparthy wrote:
> From: Todd Poynor <toddpoynor@google.com>
>=20
> usb: phy: Temporarily hold timed wakeup source on charger and disconnect
> events
>=20
> It temporarily holds a timed wakeup source on USB disconnect events, to a=
llow
> the rest of the system time to react to the USB disconnection (dropping h=
ost
> sessions, updating charger status, etc.) prior to re-allowing suspend
>=20
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-usb@vger.kernel.org
> Cc: Android Kernel Team <kernel-team@android.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Signed-off-by: Todd Poynor <toddpoynor@google.com>
> [kiran: Added context to commit message and
> addressed community feedback]
> Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
> ---
> v3:
> * Modified the commit log.
> * Remove indirect function usb_temporary_hold_wsource and call
>   __pm_wakeup_even directly.
>=20
> v2:
> * Implement usb_temporary_hold_wsource function in phy.
>=20
> v1:
> * Removed the refactoring logic from this integrated into main driver cod=
e.
>=20
> RFC:
> * Integrated the refactoring logic and logic to hold wakeupsource
>   temporarily.
>=20
>  drivers/usb/phy/otg-wakeupsource.c | 3 ++-
>  include/linux/usb/phy.h            | 2 ++
>  2 files changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/phy/otg-wakeupsource.c b/drivers/usb/phy/otg-wak=
eupsource.c
> index d9a1720..7bc9657 100644
> --- a/drivers/usb/phy/otg-wakeupsource.c
> +++ b/drivers/usb/phy/otg-wakeupsource.c
> @@ -47,7 +47,8 @@ static void otgws_handle_event(struct usb_phy *otgws_xc=
eiv, unsigned long event)
>  	case USB_EVENT_NONE:
>  	case USB_EVENT_ID:
>  	case USB_EVENT_CHARGER:
> -		__pm_relax(&otgws_xceiv->wsource);
> +		__pm_wakeup_event(&otgws_xceiv->wsource,
> +				msecs_to_jiffies(TEMPORARY_HOLD_TIME));

this was introduced by patch 1, why don't you merge this with that
patch? This is another comment that I have already provided. Why are you
ignoring my comments ? At a minimum, explain why are you ignoring them.

--=20
balbi

--jQIvE3yXcK9X9HBh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUDbGkAAoJEIaOsuA1yqRE4xgQAJ0tAPvV1GKYJPC2Dz2m66er
CICQXFMh3lp9ek6qZxjFOZTpeLVDZ7g6oXFkXHJuEOkZkou2caMQicG7BviteSmD
RgJRuKZ2pfwHWYMOGaAWypeC0RGeki0C+z9QHeQuHTm5GiMirPJMtcb08LyfxWCI
OzZ15vdAlDARmFTE80tsqwGZi9gt1iM9IwIeVGqqIWOekZhlRiQfpjEmlOc3YRmo
8W4USv1ISogdjg9SSjBAfsvHz4ci617QZrgA9oB9Wa081H/ccOgwLcbU1oK08zwD
383QYo72QDJvOpoantYzlmJCvfdCGBX7nxJ+pwqmfJz07VlX4EytBZ71rPPYGfyJ
v0vb//gg9imOmUqPhqo3EauZJSBTTwtweZ8xXBhJ696GYAQpQZBtFXC5dpQzYjPx
rjpf2jzpmm6DL/ke7TkLX69T9tp14aNqWbWMKYf++9FmnJZ+L8ICA3TqnG6GXK7L
K8Ls29xhJLUDIeKGGuEggWctRhv84uGXgLWZJ6erM1uSUwMvc9VP3dky1V3piWM3
L0bk4VgJgUexJqN6x25zcnMuwcuVQQsTgzBOO1TEH5peOeFIffsoxK+b6ImPBQDE
NpDsoRZSpq7+lpN6HKvJqE79pXa1Hk+HO+fQlVoezjdxM5YaYh2M7YLLz7l8sPdK
mXaRVF9ZYe/jZM1CFBJZ
=unZb
-----END PGP SIGNATURE-----

--jQIvE3yXcK9X9HBh--
