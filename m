Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbaDNWKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:10:49 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34275 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512AbaDNWKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:10:46 -0400
Date: Mon, 14 Apr 2014 17:08:05 -0500
From: Felipe Balbi <balbi@ti.com>
To: Mathias Krause <minipli@googlemail.com>
CC: Felipe Balbi <balbi@ti.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        PaX Team <pageexec@freemail.hu>, Anton Vorontsov <anton@enomsg.org>
Subject: Re: [PATCH 2/2] pda_power: Unregister USB notifier in
 pda_power_remove()
Message-ID: <20140414220804.GB22800@saruman.home>
Reply-To: <balbi@ti.com>
References: <1396186455-3276-1-git-send-email-minipli@googlemail.com>
 <1396186455-3276-3-git-send-email-minipli@googlemail.com>
 <20140414213504.GB22607@saruman.home>
 <CA+rthh__aRaY+DQ7drj_MPB3Gb35RFFUCd50ZN_pQR3OGr2GEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xgyAXRrhYN0wYx8y"
Content-Disposition: inline
In-Reply-To: <CA+rthh__aRaY+DQ7drj_MPB3Gb35RFFUCd50ZN_pQR3OGr2GEw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--xgyAXRrhYN0wYx8y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 15, 2014 at 12:07:13AM +0200, Mathias Krause wrote:
> On 14 April 2014 23:35, Felipe Balbi <balbi@ti.com> wrote:
> > On Sun, Mar 30, 2014 at 03:34:15PM +0200, Mathias Krause wrote:
> >> If we've registered a notifier in pda_power_probe() we must deregister
> >> it in pda_power_remove() to not let it work on stale data like, e.g.,
> >> the charger timer.
> >>
> >> Cc: Felipe Balbi <balbi@ti.com>
> >> Cc: Anton Vorontsov <anton@enomsg.org>
> >> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> >> ---
> >>  drivers/power/pda_power.c |    5 +++++
> >>  1 file changed, 5 insertions(+)
> >>
> >> diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
> >> index 87a963d0a8..aba23d6848 100644
> >> --- a/drivers/power/pda_power.c
> >> +++ b/drivers/power/pda_power.c
> >> @@ -430,6 +430,11 @@ static int pda_power_remove(struct platform_devic=
e *pdev)
> >>       if (pdata->is_ac_online && ac_irq)
> >>               free_irq(ac_irq->start, &pda_psy_ac);
> >>
> >> +#if IS_ENABLED(CONFIG_USB_PHY)
> >> +     if (!IS_ERR_OR_NULL(transceiver) && pdata->use_otg_notifier)
> >
> > IS_ERR() should be enough here.
>=20
> That's true! The usb_get_phy() call in pda_power_probe() will always
> return a valid pointer or an ERR_PTR() -- never NULL. Albeit, looking
> at usb_get_phy(), it contains another bug, returning a valid pointer,
> even when the try_module_get() call fails. *sigh* It should set ptr to
> an ERR_PTR() in this case.

good catch, can you send a patch for that ?

> Anyway, probably all the transceiver checks in pda_power.c can be
> changed to IS_ERR() checks. The reason I am using IS_ERR_OR_NULL() in
> my patch is that I just copied the test from a few lines below. I'll
> create a follow up patch in case somebody cares about this series in
> the first place.

awesome, thanks

--=20
balbi

--xgyAXRrhYN0wYx8y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTTFxEAAoJEIaOsuA1yqRE44oQAJec1tjDmLuxI+RnRo2YmbUr
gCqjEUJmbpdSOuP0iHSw2OjPDF6L7TwZyfvPB6iJTABBCiGC9jbnRgyztGI2i/cX
9xz3hxGXA607wl+JuPsFWREcvDbXGcObEej6Y0NiPtaLYdOBJfU3q9r5/opxPvQL
YpCs1ghKWec7IqqsbgY9sKsff8MCpuqtPgS5Bcsdl0Nhp7jiccrD4z48cvK7Ee6h
ElcX6FocNUKcK21IWqUks+X1RUOj0igpucjWCHXFxrpPBtAh82/zUD+m0OcIfuCD
rdS4/NhTYpKjWGZVlz3zj8/DKpy1l/DHN+7Adxlw0raD3c2DYF962xNzci6hU7ja
Qdt3KJBtXMe9DWAuprusGTHnkn4yZ/52aMqFQrs3YaiS/VUfO4NuprMTloo8q8fe
2CzMDoyWr+t3wQJ+FAvwGh2cKs4p66Mi815CraB0t76NlaLiKB7J99nyb8Yy08bg
T7o8h/vFw6XS++pjTivEhaMdBUpzKyE7+RGvGyODy+vJexgmK3PjMdMr/S+Gbghg
UkCvEAuiLX7tCqDFYkcVyJyr+QHbiNYXZzILkd4nv5VqX/Xso2YFerO3DEwwEIRE
EwlqAIwtk1+RmcLvGJr9DfSXMSh2w9qx26rvrWIne7+/mk1q9vTKMw+8COaWFoIH
47J7o5DaZMUSwQzjuwx7
=6WQV
-----END PGP SIGNATURE-----

--xgyAXRrhYN0wYx8y--
