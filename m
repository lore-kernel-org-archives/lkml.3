Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbaIBOyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 10:54:49 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54046 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbaIBOys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 10:54:48 -0400
Date: Tue, 2 Sep 2014 09:54:35 -0500
From: Felipe Balbi <balbi@ti.com>
To: Kiran Kumar Raparthy <kiran.kumar@linaro.org>
CC: <linux-kernel@vger.kernel.org>, Todd Poynor <toddpoynor@google.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC v2 2/2] usb: phy: Temporarily hold wakeupsource on charger
 connect and disconnect events
Message-ID: <20140902145435.GF16872@saruman.home>
Reply-To: <balbi@ti.com>
References: <1409658558-12318-1-git-send-email-kiran.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p8PhoBjPxaQXD0vg"
Content-Disposition: inline
In-Reply-To: <1409658558-12318-1-git-send-email-kiran.kumar@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--p8PhoBjPxaQXD0vg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Sep 02, 2014 at 05:19:18PM +0530, Kiran Kumar Raparthy wrote:
> From: Todd Poynor <toddpoynor@google.com>
>=20
> usb: phy: Temporarily hold wakeupsource on charger connect and disconnect
> events
>=20
> Allow other parts of the system to react to the charger connect/disconnect
> event without allowing the system to suspend before the other parts can p=
rocess
> the event. This wakeup_source times out after 2 seconds; if nobody else h=
olds a
> wakeup_source by that time then the device can sleep.
>=20
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-usb@vger.kernel.org
> Cc: Android Kernel Team <kernel-team@android.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Signed-off-by: Todd Poynor <toddpoynor@google.com>
> [kiran: Added context to commit message
> 	wakeupsource handling implemented per PHY in phy core]
> Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
> ---
>  drivers/usb/phy/otg-wakeupsource.c |  2 +-
>  drivers/usb/phy/phy.c              | 10 ++++++++++
>  include/linux/usb/phy.h            |  3 +++
>  3 files changed, 14 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/phy/otg-wakeupsource.c b/drivers/usb/phy/otg-wak=
eupsource.c
> index fca2010..70fa05e 100644
> --- a/drivers/usb/phy/otg-wakeupsource.c
> +++ b/drivers/usb/phy/otg-wakeupsource.c
> @@ -48,7 +48,7 @@ static void otgws_handle_event(struct usb_phy *otgws_xc=
eiv, unsigned long event)
>  	case USB_EVENT_NONE:
>  	case USB_EVENT_ID:
>  	case USB_EVENT_CHARGER:
> -		usb_drop_wsource(otgws_xceiv);
> +		usb_temporary_hold_wsource(otgws_xceiv);

looks like this won't work. You're holding the lock even on
USB_EVEN_NONE. Why ?

--=20
balbi

--p8PhoBjPxaQXD0vg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUBdorAAoJEIaOsuA1yqREQe4P/Rp8+Ba3evmbc9dWYpPpjtuV
/r2oQfD4ur8BLZpLScNTIvBA9h/m1at/Zw7NSdTUhPYfRWwhc9QVk5joN6vfr3u7
2qPwT/0gGp35ReyoIpDzTcBdlONYU3SlJ2h5sZNvEHVeFAje9PjtxLyLDRVPGlzw
vMjF6vR3a6GsaBgKw/BIN6cp4ZSwFALkQwh7ufD7O5ZvoB5qlqUfrUUwbiLP/eC0
cq7n9CTB9gfLGg5pN/cRFzpwnDqpUqTda+9vdlTNaz9+7FOkRCiwnuYUQwNycPcp
1UpC7zSRwdSvC9hvQqVnlQ4xgFCsMOQvXEFA150KONrWhRaaXZZUWdiVER5fYO7N
5njKHaOLJ0fdoT4GX9Le0cNe1s+U3KZAhRqH+sxJGPu3socjbTNBQchOUGirUW9P
8PJN7/vb73gnhvQ8LUM/BdcSnCoLw1xORdLtw73j/VbOCn3smqa6XOdIoVnb1lmU
EYgB8rJ3Dg2DgLO3c0YA11XW5ieRLWSXXr7BHI+AmEt4RyN4BHZyZ8om6VkTV6Zh
XF3noPwSLlPjyOh70BRQsKIOm8WD9r0VWvXut1Wzz62Rc/XyWHLRdbc0MyVasu3S
DDCjZnm2cKHq7NzM2b8J3wl3TitwP8tXkB0n6M7smjn3uj+6Kgz//9VTAMnX1C+T
5UWh5AXboXi5qRx+P3hv
=05Ue
-----END PGP SIGNATURE-----

--p8PhoBjPxaQXD0vg--
