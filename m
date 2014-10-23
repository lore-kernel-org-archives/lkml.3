Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbaJWTLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 15:11:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36714 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbaJWTLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 15:11:08 -0400
Date: Thu, 23 Oct 2014 14:08:19 -0500
From: Felipe Balbi <balbi@ti.com>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        "balbi@ti.com" <balbi@ti.com>,
        "dinh.linux@gmail.com" <dinh.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "matthijs@stdin.nl" <matthijs@stdin.nl>,
        "r.baldyga@samsung.com" <r.baldyga@samsung.com>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "kever.yang@rock-chips.com" <kever.yang@rock-chips.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCHv5 2/7] usb: dwc2: Move gadget probe function into
 platform code
Message-ID: <20141023190819.GH21407@saruman>
Reply-To: <balbi@ti.com>
References: <1413831126-24193-1-git-send-email-dinguyen@opensource.altera.com>
 <1413831126-24193-3-git-send-email-dinguyen@opensource.altera.com>
 <29460399.4PyRbDpEzA@amdc1032>
 <A2CA0424C0A6F04399FB9E1CD98E0304844E4FDC@US01WEMBX2.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3VRmKSg17yJg2MZg"
Content-Disposition: inline
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E0304844E4FDC@US01WEMBX2.internal.synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3VRmKSg17yJg2MZg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 22, 2014 at 08:54:00PM +0000, Paul Zimmerman wrote:
> > From: Bartlomiej Zolnierkiewicz [mailto:b.zolnierkie@samsung.com]
> > Sent: Wednesday, October 22, 2014 4:16 AM
> >=20
> > On Monday, October 20, 2014 01:52:01 PM dinguyen@opensource.altera.com =
wrote:
> > > From: Dinh Nguyen <dinguyen@opensource.altera.com>
> > >
> > > This patch will aggregate the probing of gadget/hcd driver into platf=
orm.c.
> > > The gadget probe funtion is converted into gadget_init that is now on=
ly
> > > responsible for gadget only initialization. All the gadget resources =
is now
> > > handled by platform.c
> > >
> > > Since the host workqueue will not get initialized if the driver is co=
nfigured
> > > for peripheral mode only. Thus we need to check for wq_otg before cal=
ling
> > > queue_work().
> > >
> > > Also, we move spin_lock_init to common location for both host and gad=
get that
> > > is either in platform.c or pci.c.
> > >
> > > We also ove suspend/resume code to common platform code, and update i=
t to use
> > > the new PM API (struct dev_pm_ops).
> > >
> > > Lastly, move the "samsung,s3c6400-hsotg" binding into dwc2_of_match_t=
able.
> >=20
> > This patch seems to break bisectability.  It moves all the gadget probi=
ng
> > to platform.c but Kconfig/Makefile are not updated (platform.c will be
> > compiled only for CONFIG_USB_DWC2_PLATFORM=3Dy which in turn depends on
> > CONFIG_USB_DWC2_HOST).  IMO patch #7 should be merged into this one (#2=
).
>=20
> It doesn't break the compile, I already tested it. It does break the
> operation of the driver until patch #7 is applied, but I think that's
> OK in the middle of a patch series. I think it's a bit much to expect
> the driver to keep working at each step of a patch series like this.

It's your driver and, at the end of the day, your headache; but the
very day you need to run a git bisect and you end up in the middle of
one of these commits, you'll regret this statement :-)

There's usually a way to make sure things continue to work even if it
means duplicating some code until the conversion is completed, or adding
temporary flags which get added and removed within the same series, etc.

my 2 cents

--=20
balbi

--3VRmKSg17yJg2MZg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUSVIjAAoJEIaOsuA1yqRE/uoQAJGVBqtjYseTe/pPGAAdfNYY
H1gSYRlv+ufD94zjQ077WsfR4yVsjMJWtVzZ7Tr2mPrQi0B+V7Ln0vtHERP4/CmI
Yq6AQ7y21mmZJLr838ZKWD180hWS5lIakw+wIcTKOq4GVX57yMFz+U7HoJDuWZ/t
kVPQTvWcWdNsqmTf/0cJOYiA9beHWRlzByHGEndX3pB4dT5dmKJUxaKxN4JSMyTR
5wshkaPszXTS/gpREfRGDThR3J7+QJnBpB5GiEv44VCNylu3tiyToSQBlMOdg/4U
PvjDmsAKGEScohunrmJ6Hajxn9g+xev6v75Xky4wMjErXXTs6YV5bXD7G9koT8oA
hOK3s647yn7v0jorngmc4MGWbiQfw+RYtHsxCzTaIlJrn5pKtBUh+4pXcLNF0YnW
/QzngVEV6HWelcu5qNqermQJaDdP6ZlHAp5tMhNa8JGJuTReb4GSWMc6uIKeNcV7
tFjXmYoiRk9trZ9S71tmJdL4DsHr6AZqK0EjeYWJQeRegt0c5bHO/TvvWsPZE+fC
SMD3GxEbTPp8gz2DiBXVgNz1NaDIk6BajRQzT/kkM58Wml99cLMgZmJ8z3KUOCvW
GOXQgKCmBYiIhBGAtr4W8qkrv4sxSJRBguxxJqOc2nRQ99T8hoYwHWlTwtW+sI01
Pjwt3N9/6MCSv+RWhnF9
=w6a4
-----END PGP SIGNATURE-----

--3VRmKSg17yJg2MZg--
