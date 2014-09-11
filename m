Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbaIKQzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:55:18 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52288 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755671AbaIKQzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:55:15 -0400
Date: Thu, 11 Sep 2014 11:54:28 -0500
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: Vivek Gautam <gautam.vivek@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Julius Werner <jwerner@google.com>,
        Julius Werner <jwerner@chromium.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH v6 4/4] phy: exynos5-usbdrd: Calibrate LOS levels for
 exynos5420/5800
Message-ID: <20140911165428.GD1840@saruman.home>
Reply-To: <balbi@ti.com>
References: <CAFp+6iGU86yL8Ry3ArJJjBy2Cs0Em2B49yssH3BK5fJwyaZbtA@mail.gmail.com>
 <20140908134454.GK22409@saruman.home>
 <CAFp+6iG+gmD_JseytYuVQcRK9ErOqQrUEWJoU1KUU7PqMd=aRw@mail.gmail.com>
 <20140909144225.GF6151@saruman.home>
 <CAFp+6iHJKmeothDM67WW60Sqqj8BQroBCzZ8zecKwM_GcYL8HA@mail.gmail.com>
 <CAFp+6iHRJ5oAA+K1Y0Y2uadPhsR6wmrd13DM39dqiL4jj+swHg@mail.gmail.com>
 <20140910045328.GA32475@saruman.home>
 <CAFp+6iHMhbi4V4LAkNsgzDc192ihT2a1mZHgLbia=K2U8+x=2w@mail.gmail.com>
 <CAFp+6iErXKpXgE0tRPB=tEqXxcXgQAeFJP1TpSwRN6fNu9a-qw@mail.gmail.com>
 <5411C265.2080203@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Rgf3q3z9SdmXC6oT"
Content-Disposition: inline
In-Reply-To: <5411C265.2080203@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Rgf3q3z9SdmXC6oT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 11, 2014 at 09:10:21PM +0530, Kishon Vijay Abraham I wrote:
> Hi,
>=20
> On Wednesday 10 September 2014 01:26 PM, Vivek Gautam wrote:
> > On Wed, Sep 10, 2014 at 10:53 AM, Vivek Gautam <gautam.vivek@samsung.co=
m> wrote:
> >> On Wed, Sep 10, 2014 at 10:23 AM, Felipe Balbi <balbi@ti.com> wrote:
> >>> On Wed, Sep 10, 2014 at 09:09:57AM +0530, Vivek Gautam wrote:
> >>>> On Wed, Sep 10, 2014 at 9:07 AM, Vivek Gautam <gautam.vivek@samsung.=
com> wrote:
> >>>>> adding Julius here,
> >>>>
> >>>> i think i had missed adding Julius for this entire series :-(
> >>>> I should be more careful with the CC list in future.
> >>>> Added his chromium id, since that seems to be more active.
> >>>>
> >>>>>
> >>>>>
> >>>>> On Tue, Sep 9, 2014 at 8:12 PM, Felipe Balbi <balbi@ti.com> wrote:
> >>>>>> On Tue, Sep 09, 2014 at 07:19:50AM +0530, Vivek Gautam wrote:
> >>>>>>> Hi,
> >>>>>>>
> >>>>>>>
> >>>>>>> On Mon, Sep 8, 2014 at 7:14 PM, Felipe Balbi <balbi@ti.com> wrote:
> >>>>>>>> Hi,
> >>>>>>>>
> >>>>>>>> On Mon, Sep 08, 2014 at 09:53:09AM +0530, Vivek Gautam wrote:
> >>>>>>>>> On Fri, Sep 5, 2014 at 11:26 PM, Felipe Balbi <balbi@ti.com> wr=
ote:
> >>>>>>>>>> On Thu, Sep 04, 2014 at 12:01:19PM +0530, Vivek Gautam wrote:
> >>>>>>>>>>>> Don't we have phy_power_on()
> >>>>>>>>>>>> for that ? It looks like you could just as well do this from
> >>>>>>>>>>>> phy_power_on() ?
> >>>>>>>>>>>
> >>>>>>>>>>> No, unfortunately keeping these calibration settings in phy_p=
ower_on()
> >>>>>>>>>>> doesn't help, since we need to do this after XHCI reset has h=
appened.
> >>>>>>>>>>
> >>>>>>>>>> teach xHCI about PHYs ?
> >>>>>>>>>
> >>>>>>>>> sorry i couldn't understand you here.
> >>>>>>>>> Aren't we trying to do the same with Heikki's patch about dwc3 :
> >>>>>>>>> [PATCH 6/6] usb: dwc3: host: convey the PHYs to xhci
> >>>>>>>>>
> >>>>>>>>> and the 2nd patch in this series :
> >>>>>>>>> [PATCH v6 2/4] usb: host: xhci-plat: Get PHYs for xhci's hcds
> >>>>>>>>>
> >>>>>>>>> Is there something else that is expected ?
> >>>>>>>>
> >>>>>>>> right, use that to call phy_init() at the right time, then you n=
eed to
> >>>>>>>> add a new ->calibrate() method which, likely, will only be used =
by you
> >>>>>>>> ;-)
> >>>>>>>
> >>>>>>> so you mean, the xhci should itself call phy_init() at a time sui=
table,
> >>>>>>> so that ->calibrate() is not required at all ?
> >=20
> > but wait, dwc3 does a phy_init() already, then how xhci will be able to
> > do that again. We can't do phy_init() multiple times right ?
>=20
> right. I think we should split and do phy ops separately for dwc3 host
> and gadget?

no, don't do that. We need a better way of handling this. As of now we
don't support dual-role, so we can just reinitialize the PHY once we
reach xhci.

Once we start supporting dual-role, we will need more inteligence in the
algorithm.

--=20
balbi

--Rgf3q3z9SdmXC6oT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUEdPDAAoJEIaOsuA1yqREclgP/2+VvtBIoccn4wMjgjdiERCp
FKp8erfCibNHWXHSUoNx5IJzfaNCPlh366DNdC1ZOBWxCI98k7qAn6dRdb4M1GhL
6lnSjNWNVChbctAZIunRrxD0LdtfvykXssHPXKxPZ4v1oZ+ULKits9nRXwWCEONJ
Dh89x/5boZKjkLMcDAU8QSZbnh0eVkWtYJQL5zbtRh6D9tciVY702cGr4BYi5WEq
Cgxu75Fc7AwIY1l8EVw9FrJa3p+fdxOWA4SbzodwV7OwbtrmaX9RhaqwduxMOQOW
8D08XKvpdkRxgYDK+kIKoCUpJd6C8e7xR/Z4ALAF8e7AI2mBQVLgBnOeC7JOmM5+
8hmDW2292iuBYXIfjxpPlCZwX1XYVHZpzFEuWohz3l4Sc1ZJBCXbbJqAoTjDUXQH
AXP7fPqmALgcT+uWJllpxHOSDic/viat0ueHX9fe33wFYIRlPfnjRMQ1Dfyt+ZVD
yrx1uJY7qi4HAMkvNPBrWeDDGN860Sp1txhRZ5mlhNaJkqB7MPvf1g/1XqiptNwc
MaLeID09bQ+xGu2hM/nwJwHBO/dAzlDiU4TY57an+Xwh8wrQ795goxRQaowNXTeE
PJ0xyRAcVq6Iyj1iCGsKNDsoSgXhLkkGlsSXTTF/2DKKmC7N/M51cyA4io5x/wlx
ozNEiywlc8w+XHfgRyUh
=ufO3
-----END PGP SIGNATURE-----

--Rgf3q3z9SdmXC6oT--
