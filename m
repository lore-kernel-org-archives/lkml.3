Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275AbaH2UuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 16:50:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41133 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbaH2UuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 16:50:21 -0400
Date: Fri, 29 Aug 2014 15:50:15 -0500
From: Felipe Balbi <balbi@ti.com>
To: Todd Poynor <toddpoynor@google.com>
CC: <balbi@ti.com>, Kiran Kumar Raparthy <kiran.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Arve =?utf-8?B?SGrvv71ubmV277+9Zw==?= <arve@android.com>,
        Benoit Goby <benoit@android.com>,
        Ruchi Kandoi <kandoiruchi@google.com>,
        Badhri Jagan Sridharan <badhri@google.com>
Subject: Re: [RFC 1/2] USB: OTG: Hold wakeupsource when VBUS present
Message-ID: <20140829205015.GE16391@saruman.home>
Reply-To: <balbi@ti.com>
References: <1408700972-8518-1-git-send-email-kiran.kumar@linaro.org>
 <20140822171210.GD27616@saruman.home>
 <CAAW3YpZPOCkTkx=OM_0ZYA7brh5t32miprstLqGyurD9vN94yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X3gaHHMYHkYqP6yf"
Content-Disposition: inline
In-Reply-To: <CAAW3YpZPOCkTkx=OM_0ZYA7brh5t32miprstLqGyurD9vN94yg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--X3gaHHMYHkYqP6yf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Aug 27, 2014 at 02:58:30PM -0700, Todd Poynor wrote:
> On Fri, Aug 22, 2014 at 10:12 AM, Felipe Balbi <balbi@ti.com> wrote:
> ...
> > you never explain why this is needed and you have also added some
> > information to commit log which shouldn't be here.
>=20
> Android uses this to prevent suspend from interfering with USB
> peripheral traffic, notably adb.

aaaaah, that's because Android freezes userspace right ?

> The wakeup source is held only when USB is connected and enumerated
> for a host session (I might be using wrong terminology here).  It may
> not be necessary on a platform that implements wakeup on incoming USB
> traffic, although it is likely adb and other protocols would need to
> hold wakeup sources at certain times.
>=20
> ...
> >> +static struct otgws_lock vbus_lock;
> >
> > should be per-PHY
>=20
> One of the reasons this was done as a separate driver and via
> notifiers was to keep the (original Android wakelock) logic out of the
> USB code.  If the general idea is something that finds favor with the
> USB and PM folks then perhaps adding a wakeup source per PHY in the
> PHY driver would be better.

it's best to do it per-PHY, but it doesn't have to be written into each
and every PHY driver, do it at the core and abstract that away from PHY
drivers.

--=20
balbi

--X3gaHHMYHkYqP6yf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUAOeHAAoJEIaOsuA1yqREBCsP/1wiBjgx9HvcoV2b/alI9Gnl
WcHWthYIlXyvUpMm1DHct/7UxoSuTNYAO2DLQgkO/nKH32npZvA8MCrLb20/65jN
py1lyjU5jMU8diDmJXeBL+x/3mhy3Fh+ZIk65lwnIsZW+yAvs+DI+c4rCQa/JyWL
VYX3XpS28j+pEFHldxmcVjJjBvwCn6mSeM3RkIHHrwhBh4iIrnOQCXzpqDiXmYQ4
FzoV0DBdjNF8p4p3KvzQ5kNI8jkDStMuDVjZEPBsPcDNmniX6eMXw71hqhitcxAP
n0akJec1EYr/zJtKWY90V7qLICzZEAc3MahLOL6386lZmYB7ZOQHVxDC7UXiAhP8
iDUN71JAHw7u9Xxce2C1nSusJSEY9Ze4pJ/UxDuOVgd6rl1zb32FeBw4wunDSHs2
EzGdRLk5yAmNMbJ9FiQqu7bc6uc6OiXpNuw2a0Yf7XxmTpasyHlNX2qplXUN9B5e
WeEywgKO4l/HWZaY7ydb2WUDjxK7M+9W+QyE6at/lysx5wK88GiS/ZUwlaIZO/jn
+HWAdkEQSklcYYq0o2LqZ+x8f8EsrXC2xImpzqptrzv8YSAy23iK2UM/QZpoE9Kp
7reMgVJS/lK3doCpGzOnw5y6JxN4ZTxCJV8nzMc5zYrLlsn3zikMMWO+7go4O6qV
n+SVHsbwegKgJh4M5Drq
=MW8S
-----END PGP SIGNATURE-----

--X3gaHHMYHkYqP6yf--
