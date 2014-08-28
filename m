Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbaH1Nmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 09:42:55 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44123 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbaH1Nmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 09:42:54 -0400
Date: Thu, 28 Aug 2014 08:42:38 -0500
From: Felipe Balbi <balbi@ti.com>
To: Kiran Kumar Raparthy <kiran.kumar@linaro.org>
CC: <linux-kernel@vger.kernel.org>, Todd Poynor <toddpoynor@google.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Arve =?utf-8?B?SGrvv71ubmV277+9Zw==?= <arve@android.com>,
        Benoit Goby <benoit@android.com>
Subject: Re: [RFC v1 1/2] USB: OTG: Hold wakeupsource when VBUS present
Message-ID: <20140828134238.GD16689@saruman.home>
Reply-To: <balbi@ti.com>
References: <1409219710-26874-1-git-send-email-kiran.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jCrbxBqMcLqd4mOl"
Content-Disposition: inline
In-Reply-To: <1409219710-26874-1-git-send-email-kiran.kumar@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jCrbxBqMcLqd4mOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Aug 28, 2014 at 03:25:10PM +0530, Kiran Kumar Raparthy wrote:
> +bool enabled =3D false;
> +
> +static DEFINE_SPINLOCK(otgws_spinlock);
> +static struct usb_phy *get_phy_hook(void);
> +
> +/* Only one lock, but since these 2 fields are associated with each othe=
r... */
> +
> +struct otgws_lock {
> +	char name[40];
> +	struct wakeup_source wsource;
> +};
> +
> +/* VBUS present lock */
> +
> +static struct otgws_lock vbus_lock;

I believe I mentioned that all of this should be per-PHY.

--=20
balbi

--jCrbxBqMcLqd4mOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT/zHOAAoJEIaOsuA1yqRELUUQAJxBfUeI+juryUwak2Lp/+1a
ge65G73kaubCFCpsAvWEXDETO0n+zQar7uRK1f7QenmmVfNaPThqZ2pQN9p6zvGV
7tHxy4AdJVUptxZHsaHQfdUg/nuyEhMfxd81HJWJOs9EX928J60Sy0cDHgGzumD0
w2X0n5sO74hW3XRWkK0dQoInv+XY0Dj+2/aFpXo++09/5FqWbYKHUfrQw9TLlYJ/
AWsEpR7EyGzwgYdig5YI98TyzGA5wKcMkm5ul6kPDJDAy898G5SO1VmoAigcOAFz
AEGEhSnzGbdjWzC6hoSddEFhkCY2KGngQjhU5v3ioeNfaazd8Lmg5xlpRFSiu0jP
p8gfzbQNNIrYUyaPCzKLScChDxv/e0UVDL/V566/4k6juEX2Urn2eWCOInZ5Q2yL
skyfMce75V8uy+ncWjiQBPT/Zs/8poxaa+IPyXdypGApgSc6ZKBpdbTF3FN/ESId
WRZlzYLUm9WTMdHyaKvG0iKR5UFjAi/wcqcK7IEA3iukhPmrUAGjrBDaJ350dC/m
xGNexkGRi3s6KGgXBdwSVmPbMlhQ+UxSydxycB/EjSoxJxuwvIi7JFqx+kQYHobq
0/CsS0k9wOjOKwP9h6iu+rtNSQ/FsX+xqCrN87bfso21YG8aNfm2aJNX3vBVWKAY
C08kMHlY2d3pqXf4qXug
=o7cf
-----END PGP SIGNATURE-----

--jCrbxBqMcLqd4mOl--
