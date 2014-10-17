Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaJQSsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 14:48:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40363 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbaJQSsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 14:48:39 -0400
Date: Fri, 17 Oct 2014 13:48:19 -0500
From: Felipe Balbi <balbi@ti.com>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
CC: "balbi@ti.com" <balbi@ti.com>, Huang Rui <ray.huang@amd.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Vincent Wan <vincent.wan@amd.com>, Tony Li <tony.li@amd.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 16/16] usb: dwc3: enable usb suspend phy
Message-ID: <20141017184819.GX26260@saruman>
Reply-To: <balbi@ti.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
 <1413536021-4886-17-git-send-email-ray.huang@amd.com>
 <20141017145942.GL26260@saruman>
 <A2CA0424C0A6F04399FB9E1CD98E0304844E3423@US01WEMBX2.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mlvFMpb4NrD3AMcD"
Content-Disposition: inline
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E0304844E3423@US01WEMBX2.internal.synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--mlvFMpb4NrD3AMcD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 17, 2014 at 06:41:04PM +0000, Paul Zimmerman wrote:
> > From: Felipe Balbi [mailto:balbi@ti.com]
> > Sent: Friday, October 17, 2014 8:00 AM
> >=20
> > On Fri, Oct 17, 2014 at 04:53:41PM +0800, Huang Rui wrote:
> > > AMD NL needs to suspend usb3 ss phy, but this doesn't enable on simul=
ation
> > > board.
> > >
> > > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > > ---
> > >  drivers/usb/dwc3/core.c          | 7 ++++++-
> > >  drivers/usb/dwc3/dwc3-pci.c      | 3 ++-
> > >  drivers/usb/dwc3/platform_data.h | 1 +
> > >  3 files changed, 9 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> > > index 3ccfe41..4a98696 100644
> > > --- a/drivers/usb/dwc3/core.c
> > > +++ b/drivers/usb/dwc3/core.c
> > > @@ -395,6 +395,9 @@ static void dwc3_phy_setup(struct dwc3 *dwc)
> > >  	if (dwc->quirks & DWC3_QUIRK_TX_DEEPH)
> > >  		reg |=3D DWC3_GUSB3PIPECTL_TX_DEEPH(1);
> > >
> > > +	if (dwc->quirks & DWC3_QUIRK_SUSPHY)
> >=20
> > should be:
> >=20
> > 	if (!dwc->suspend_usb3_phy_quirk)
> >=20
> > > +		reg |=3D DWC3_GUSB3PIPECTL_SUSPHY;
> >=20
> > IIRC, databook asks us to set that bit anyway, so the quirk is disabling
> > that bit. Am I missing something ? Paul ?
>=20
> It looks to me that Huang's patch is enabling that bit, not disabling
> it.

right, but that's what's actually quirky right ? IIRC, Databook asks us
to set usb2 and usb3 suspend phy bits and we're just not doing it.

> Currently the driver does not set either DWC3_GUSB3PIPECTL_SUSPHY or
> DWC3_GUSB2PHYCFG_SUSPHY (unless it has been added by that big patch
> series you just posted). According to the databook, both of those
> bits should be set to 1 after the core initialization has completed.

there you go. So unless that quirk bit flag is set, we're safe of
setting SUSPHY bit for everybody.

> So I think the driver should be changed to enable both of those by
> default, and then maybe you want quirks to disable them if there is
> some platform out there which needs that.

Yeah, that's what I thought too :-) Thanks for confirming

--=20
balbi

--mlvFMpb4NrD3AMcD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUQWRzAAoJEIaOsuA1yqRESPYQAIkZRHZUs6+YdSu9kfn2Y4zK
XPVh1eUuCjItFCU9htv9/wqD3fdeOJbXBTDO7vpe7SCVMe7pyN3ymZTEyaPiub5r
8T8YPeGU+lKBzT5ldxejTdmO62KvhoH+515RmSTln/A4J1D69jGxnA3O+8QVcU4n
RyY01CPhFFlT783FT7u+cq20lH4hk7xw5iaCbqrPzuzfwey7yLlD9KJ3iMj+Ml81
qomtBkiLIjvM5DDTJxGGWhGwFiQ870qLIRosOJ56gJh/Ja3PP3YbK1W+4g2GgECV
fAETbGPBmn0rAqhwJLduRs9qmujDFqWpwAk1Rht1K/A6gYcqc2kL+D78kcAjt9ky
2Nzeh56TG7n86y3kUf4qQGlodOk8N6SdbRNYKo5UrOW2AFeK38UOMP35wZkEMrLE
lwBlaQ8pHTjaVXjw3IJE6wPCpAbdXx9Q3CATgLFPmLnrMNmG2J+T1e2tpkusABuc
gLQCvFymtYaxBXthJB6UjCwfnUisuE+8aIZg+h++tpzI4M7q7QZnlLrKMtkJ4tNq
/bIoPrlNYbRZrcYgY1nBwy+gLr5/zlmvK1l1R0JrHHtnh2hmYPRsnkcTXo4kqPLB
eBa4fz7sv9q8sOWfsC1/5ukUoAXdSxPAlk9pugpzY/Y6t1vSTI/qrB9rXtgFX30r
krpkpDgVns5stUpg3TvU
=ZrNo
-----END PGP SIGNATURE-----

--mlvFMpb4NrD3AMcD--
