Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820AbaIEOUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:20:10 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34091 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305AbaIEOUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:20:05 -0400
Date: Fri, 5 Sep 2014 09:19:45 -0500
From: Felipe Balbi <balbi@ti.com>
To: Todd Poynor <toddpoynor@google.com>
CC: <balbi@ti.com>, Kiran Kumar Raparthy <kiran.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Badhri Jagan Sridharan <badhri@google.com>,
        Ruchi Kandoi <kandoiruchi@google.com>
Subject: Re: [RFC v2 2/2] usb: phy: Temporarily hold wakeupsource on charger
 connect and disconnect events
Message-ID: <20140905141945.GC24449@saruman.home>
Reply-To: <balbi@ti.com>
References: <1409658558-12318-1-git-send-email-kiran.kumar@linaro.org>
 <20140902145435.GF16872@saruman.home>
 <CAAW3YpZJ0JrYL4OxJ18Vq1kVWVWN+XFRBkTbgDS5SFUQ6HUJqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GPJrCs/72TxItFYR"
Content-Disposition: inline
In-Reply-To: <CAAW3YpZJ0JrYL4OxJ18Vq1kVWVWN+XFRBkTbgDS5SFUQ6HUJqg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GPJrCs/72TxItFYR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 05, 2014 at 12:40:22AM -0700, Todd Poynor wrote:
> On Tue, Sep 2, 2014 at 7:54 AM, Felipe Balbi <balbi@ti.com> wrote:
> > Hi,
> >
> > On Tue, Sep 02, 2014 at 05:19:18PM +0530, Kiran Kumar Raparthy wrote:
> ...
> >> diff --git a/drivers/usb/phy/otg-wakeupsource.c b/drivers/usb/phy/otg-=
wakeupsource.c
> >> index fca2010..70fa05e 100644
> >> --- a/drivers/usb/phy/otg-wakeupsource.c
> >> +++ b/drivers/usb/phy/otg-wakeupsource.c
> >> @@ -48,7 +48,7 @@ static void otgws_handle_event(struct usb_phy *otgws=
_xceiv, unsigned long event)
> >>       case USB_EVENT_NONE:
> >>       case USB_EVENT_ID:
> >>       case USB_EVENT_CHARGER:
> >> -             usb_drop_wsource(otgws_xceiv);
> >> +             usb_temporary_hold_wsource(otgws_xceiv);
> >
> > looks like this won't work. You're holding the lock even on
> > USB_EVEN_NONE. Why ?
>=20
> It temporarily holds a timed wakeup source on USB disconnect events,
> to allow the rest of the system time to react to the USB disconnection
> (dropping host sessions, updating charger status, etc.) prior to
> re-allowing suspend.

alright, please add a note like this to commit log.

--=20
balbi

--GPJrCs/72TxItFYR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUCcaBAAoJEIaOsuA1yqRE1vYQAIZ7X2aoCg+92STcCQ6eHtE3
nGQ7pevYlltE5TgNFAVdDiFyYVKqFJRHKAbv1fvFXNqgtrLqyD8mv7eGqQwixaYU
S9khXSR9kdty4vpRkybWolhwrlSCf5W9dSTkZ8FSkOy+Va8TnK24e8RnUuvQTf9U
UEUByXGXlN/KoWTOoxt3EX3rcEmn9K4y9TdskK6W9wihzJnFY7yQ8spUXO9Oax4C
FR73SmL37UR1P0/grnJfLS80kK26WOFZNcv5hsC3q1KiVdKatmN6LjME4ZScou1J
WJUEn8fbiuKoywSgJZ0R4USBbpANNah/jTUp/1bPCtfw8kZiQk52DbrkWcPasBQ1
dw1G4JWvXPJaVbzomg6FuLxB6hG4b/DgZdH4ED08HL/lLzX4AZ4CcqK47EsQflhd
uiI85uj659Hp6asCCwO3F+t58QeHpIRA4VhdqJsIQLV+orSdPGfybyOw6XCvXffw
k+Yr4bswASABHA9isNyAu/PrH0584L1acotpVz+/dr2z+waWnAEHXpZHbkfRcD0a
f7JTwaQznK/OdZaFRyEMTvfYOpMhWXNeW2+pCgbN4c4zv/ZOMzdgOyD6e2Q4/b0o
xODdQZZc6xFoUbXwdBmQR0jX/RYuOLDb38OcykQB1MC3ZL8KfXv6xjLR6SboH1tA
kOlBu1NDNi2PcFv7GGkw
=Xcv7
-----END PGP SIGNATURE-----

--GPJrCs/72TxItFYR--
