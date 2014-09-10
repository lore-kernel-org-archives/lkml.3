Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186AbaIJEyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:54:16 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47523 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbaIJEyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:54:14 -0400
Date: Tue, 9 Sep 2014 23:53:28 -0500
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: Felipe Balbi <balbi@ti.com>, Julius Werner <jwerner@google.com>,
        Julius Werner <jwerner@chromium.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>, kishon <kishon@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH v6 4/4] phy: exynos5-usbdrd: Calibrate LOS levels for
 exynos5420/5800
Message-ID: <20140910045328.GA32475@saruman.home>
Reply-To: <balbi@ti.com>
References: <CAFp+6iEyqmbwMLFrBKD7NVLDAC=b+h1hPKFS=BG4k9D69hn_dg@mail.gmail.com>
 <20140903144225.GD31855@saruman.home>
 <CAFp+6iETPJCWMMkjHrpDcdCv=K0PbefYLa4eBOwN=aUY2=EHLA@mail.gmail.com>
 <20140905175651.GK24449@saruman.home>
 <CAFp+6iGU86yL8Ry3ArJJjBy2Cs0Em2B49yssH3BK5fJwyaZbtA@mail.gmail.com>
 <20140908134454.GK22409@saruman.home>
 <CAFp+6iG+gmD_JseytYuVQcRK9ErOqQrUEWJoU1KUU7PqMd=aRw@mail.gmail.com>
 <20140909144225.GF6151@saruman.home>
 <CAFp+6iHJKmeothDM67WW60Sqqj8BQroBCzZ8zecKwM_GcYL8HA@mail.gmail.com>
 <CAFp+6iHRJ5oAA+K1Y0Y2uadPhsR6wmrd13DM39dqiL4jj+swHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <CAFp+6iHRJ5oAA+K1Y0Y2uadPhsR6wmrd13DM39dqiL4jj+swHg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2014 at 09:09:57AM +0530, Vivek Gautam wrote:
> On Wed, Sep 10, 2014 at 9:07 AM, Vivek Gautam <gautam.vivek@samsung.com> =
wrote:
> > adding Julius here,
>=20
> i think i had missed adding Julius for this entire series :-(
> I should be more careful with the CC list in future.
> Added his chromium id, since that seems to be more active.
>=20
> >
> >
> > On Tue, Sep 9, 2014 at 8:12 PM, Felipe Balbi <balbi@ti.com> wrote:
> >> On Tue, Sep 09, 2014 at 07:19:50AM +0530, Vivek Gautam wrote:
> >>> Hi,
> >>>
> >>>
> >>> On Mon, Sep 8, 2014 at 7:14 PM, Felipe Balbi <balbi@ti.com> wrote:
> >>> > Hi,
> >>> >
> >>> > On Mon, Sep 08, 2014 at 09:53:09AM +0530, Vivek Gautam wrote:
> >>> >> On Fri, Sep 5, 2014 at 11:26 PM, Felipe Balbi <balbi@ti.com> wrote:
> >>> >> > On Thu, Sep 04, 2014 at 12:01:19PM +0530, Vivek Gautam wrote:
> >>> >> >> > Don't we have phy_power_on()
> >>> >> >> > for that ? It looks like you could just as well do this from
> >>> >> >> > phy_power_on() ?
> >>> >> >>
> >>> >> >> No, unfortunately keeping these calibration settings in phy_pow=
er_on()
> >>> >> >> doesn't help, since we need to do this after XHCI reset has hap=
pened.
> >>> >> >
> >>> >> > teach xHCI about PHYs ?
> >>> >>
> >>> >> sorry i couldn't understand you here.
> >>> >> Aren't we trying to do the same with Heikki's patch about dwc3 :
> >>> >> [PATCH 6/6] usb: dwc3: host: convey the PHYs to xhci
> >>> >>
> >>> >> and the 2nd patch in this series :
> >>> >> [PATCH v6 2/4] usb: host: xhci-plat: Get PHYs for xhci's hcds
> >>> >>
> >>> >> Is there something else that is expected ?
> >>> >
> >>> > right, use that to call phy_init() at the right time, then you need=
 to
> >>> > add a new ->calibrate() method which, likely, will only be used by =
you
> >>> > ;-)
> >>>
> >>> so you mean, the xhci should itself call phy_init() at a time suitabl=
e,
> >>> so that ->calibrate() is not required at all ?
> >>>
> >>> i think you meant there - "then you __do not__ need to
> >>
> >> right :-)
> >
> > alright, i will prepare a patch for the suggested change.
> >
> > But AFAI remember we had discussion for this patch in earlier
> > version, and Julius suggested to use a generic approach for such
> > change wherein other users in future may be able to use the
> > facility.

right, and what's more generic than adding the support for PHYs straight
into xHCI ?

What I fear is that we end up opening the doors for every odd
platform-specific operation to be added to the framework without really
considering what needs to be done. That would defeat the idea of having
a generic framework altogether.

cheers

--=20
balbi

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUD9lIAAoJEIaOsuA1yqREjQQQAKGPe5DdtVF8lgqzyrDml5J+
2dlaXKlL8/TFUhU/P/hScwU4zc31gOZhNJ0V9fR9p9bhQxWpWXEsepuPy3unk4Sr
DbSgaVXC3cvS++4pWKsJoRcDeid0C+K++vMlgRqY2mzhY4wYzvtDMjIsf6CQ0fdf
7PFsap9E0N7Qn/nlzFxV2qLYWdoVygc9639qpHVK+v/HOMRTePfLT7EachY6H6TL
X04qx414MYyBGi2Xk/RFGHcuzChN6PTMImFoKnCappBc5egOJHpJBZC03aaxxHfB
nVBQ5tRnxvt5cXNAikqnLIT3m/Ot5ckMPdythjfis1uoXkxYqj+1NkJleDDlZiQC
goydyPTxCPu+cp/YGTxBIoZIR0iWaEFhvUz5wiuY7+SDTWelQGz/JlcDwzyT2seU
lOTfdGF3MVGdptkPPeufXlbWJmzIK9E43J7EmdYJdXSSyTgnPd4vvwSFhMw/9Jge
i12FVH8oNWr5Vanf6Zw+SoLPy3KGwNDEqsBjn5lThgJzh2U9sUpayrgdF3tEVQMm
sJfVyKoYpxag2aRkVfReCP7Ia/iQogJBViaICefdZ1gor2gRW0ByRYhxYXG/CybR
nEUAp2iAxYi5VKZxH3MuNFgHRKGxo6YGaIsl/5ls/Nwo9Q9dGKIb8m+j3oANjd3S
2x5tpmxZl1u937W9AD1Z
=93B6
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
