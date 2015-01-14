Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbbANREX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:04:23 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:37123 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbbANREU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:04:20 -0500
Date: Wed, 14 Jan 2015 11:02:44 -0600
From: Felipe Balbi <balbi@ti.com>
To: Sneeker Yeh <sneeker.yeh@gmail.com>
CC: Felipe Balbi <balbi@ti.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>, Hans de Goede <hdegoede@redhat.com>,
        Thomas Pugliese <thomas.pugliese@gmail.com>,
        David Mosberger <davidm@egauge.net>,
        Peter Griffin <peter.griffin@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Andy Green <andy.green@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
Subject: Re: [PATCH 3/3] usb: dwc3: add a quirk for device disconnection
 issue in Synopsis dwc3 core
Message-ID: <20150114170244.GD16533@saruman>
Reply-To: <balbi@ti.com>
References: <1418695828-605-4-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
 <20141222153730.GA12815@saruman>
 <CAJ1gpc3jVpz=5ME4+wCJDW5NKihvB4xYzwi0co=UuPtG9Ubmjg@mail.gmail.com>
 <CAJ1gpc3-Wjtm54WOhO6RXjZft9BMngzyYC0-S-XnTacV-qKgMg@mail.gmail.com>
 <20141229160641.GD29379@saruman>
 <CAJ1gpc0Uu4vS2iA_o_W5NaE_QBWDYFZJio7yKvhpaR5f=qWcGA@mail.gmail.com>
 <20150105170921.GH19336@saruman>
 <CAJ1gpc3RZnqizhiasrwS8uy1H_wQAi_T0mPcS8LAK4FhmBRJ6A@mail.gmail.com>
 <20150112172032.GD6525@saruman>
 <CAJ1gpc0ZQva0u=e=SpBdhhRrTXdj_b3hv3oP=jyNue=1sF8EbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zljh9u/ceMLi+8mf"
Content-Disposition: inline
In-Reply-To: <CAJ1gpc0ZQva0u=e=SpBdhhRrTXdj_b3hv3oP=jyNue=1sF8EbA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Zljh9u/ceMLi+8mf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jan 14, 2015 at 03:08:43PM +0800, Sneeker Yeh wrote:
> Hi Felipe:
>=20
> thanks for suggestion,
>=20
> 2015-01-13 1:20 GMT+08:00 Felipe Balbi <balbi@ti.com>:
>=20
> > Hi,
> >
> > On Sun, Jan 11, 2015 at 11:19:55PM +0800, Sneeker Yeh wrote:
> > > > > > enable the quirk only for you. Isn't there a better way of
> > enabling the
> > > > > > quirk based off of revision detection couple with a look on
> > GHWPARAMS*
> > > > > > registers ?
> > > > > >
> > > > > > What's tricking me is this claim that only config-free PHYs wou=
ld
> > be
> > > > > > affected, why ?
> > > > > >
> > > > >
> > > > > i'm still struggling now to try to get more information about thi=
s.
> > > > > some security policy inside Fujitsu make me unable to access full
> > > > > information of this errata today.
> > > > >
> > > > > Someday after i get enough information,
> > > > > i shall take your suggestion here that seems better to incur quirk
> > > > > dynamically via GHWPARAMS,
> > > > > and then send it here again.
> > > >
> > > > ok, hopefully you'll find a way ;-)
> > > >
> > > > I got some update information here finally~
> > > in case i express unclearly i also put a pdf:
> > > https://drive.google.com/file/d/0B18MmcvvKjNNbDF6eEdHSzZCazA/view
> > >
> > > This issue is defined by a two-way race at disconnect, between
> > > 1) class driver interrupt endpoint resheduling attempts if the ISR ga=
ve
> > an
> > > ep error event due to device detach (it would try 3 times)
> > > 2) Disconnect interrupt on PORTSC_CSC, which is cleared by hub thread
> > > asynchronously
> > > 3) The hardware IP was configured in silicon with
> > >        - DWC_USB3_SUSPEND_ON_DISCONNECT_EN=3D1 (this is an IP configu=
ration
> >
> > yeah, aparently this is another configuration which is not exposed on
> > HWPARAMS registers. Paul, can you confirm for us ? I couldn't find it on
> > Databook on any of the HWPARAMS registers.
> >
> > > port whose state cannot be checked from software)
> > >        - Synopsys IP version is < 3.00a
> >
> > heh, so pretty much everybody :-)
> >
>=20
> yeah, and I'm really lucky to encounter this @@
>=20
>=20
> >
> > >        The IP will auto-suspend itself on device detach with some
> > > phy-specific interval after CSC is cleared by 2)
> > >
> > > If 2) and 3) complete before 1), the interrupts it expects will not be
> > > generated by the autosuspended IP, leading to a deadlock. Even later
> > > disconnection procedure would detect that corresponding urb is still
> > > in-progress and issue a ep stop command, auto-suspended IP still won't
> > > respond to that command.
> > >
> > > this defect would result in this when device detached:
> > > -------------------
> > > [   99.603544] usb 4-1: USB disconnect, device number 2
> > > [  104.615254] xhci-hcd xhci-hcd.0.auto: xHCI host not responding to =
stop
> > > endpoint command.
> > > [  104.623362] xhci-hcd xhci-hcd.0.auto: Assuming host is dying, halt=
ing
> > > host.
> > > [  104.653261] xhci-hcd xhci-hcd.0.auto: Host not halted after 16000
> > > microseconds.
> > > [  104.660584] xhci-hcd xhci-hcd.0.auto: Non-responsive xHCI host is =
not
> > > halting.
> > > [  104.667817] xhci-hcd xhci-hcd.0.auto: Completing active URBs anywa=
y.
> > > [  104.674198] xhci-hcd xhci-hcd.0.auto: HC died; cleaning up
> > > --------------------
> > > As a result, when device detached, we desired to postpone "PORTCSC cl=
ear"
> > > behind "disable slot". it's found that all executed ep command relate=
d to
> > > disconnetion, are executed before "disable slot".
> >
> > Now this is all great information and they should all be part of your
> > commit log and probably a big comment should be added to code as well.
> >
>=20
> I see, thanks.
>=20
>=20
> >
> > Thanks for going after all these details, now let's figure out a way to
> > pass dwc3 revision to xhci, or maybe we pass just a flag for the quirk,
> > something like:
> >
> >         if (dwc->revision < 3.00a && dwc->has_suspend_on_disconnect)
> >                 xhci_pdata.delay_portcsc_clear =3D true;
> >
> > or something similar to that.
> >
>=20
> Sure, how about i write these like this, that i learn from the way dwc3
> inject XHCI_LPM_SUPPORT to xhci via platform data:
>=20
> --- a/drivers/usb/dwc3/host.c
> +++ b/drivers/usb/dwc3/host.c
> @@ -53,6 +53,10 @@ int dwc3_host_init(struct dwc3 *dwc)
>         pdata.usb3_lpm_capable =3D 1;
>  #endif
>=20
> +       if ((dwc->revision < DWC3_REVISION_300A) &&
> +           dwc->suspend_on_disconnect_quirk)
> +               pdata.delay_portcsc_clear =3D 1;
> +
>         ret =3D platform_device_add_data(xhci, &pdata, sizeof(pdata));
>         if (ret) {
>                 dev_err(dwc->dev, "couldn't add platform data to xHCI
> device\n");
> --- a/drivers/usb/host/xhci-plat.c
> +++ b/drivers/usb/host/xhci-plat.c
> @@ -147,6 +147,9 @@ static int xhci_plat_probe(struct platform_device *pd=
ev)
>         if ((node && of_property_read_bool(node, "usb3-lpm-capable")) ||
>                         (pdata && pdata->usb3_lpm_capable))
>                 xhci->quirks |=3D XHCI_LPM_SUPPORT;
> +
> +       if (pdata && pdata->delay_portcsc_clear)
> +               xhci->quirks |=3D XHCI_DISCONNECT_QUIRK;
>         /*
>          * Set the xHCI pointer before xhci_plat_setup() (aka
> hcd_driver.reset)
>          * is called by usb_add_hcd().
>=20
> but I'm a little confused about how we decide
> dwc->suspend_on_disconnect_quirk.
> just wondering if pdata & dts would be better than Kconfig to decide this?
> because using Kconfig means forcing dwc3.ko has this quirk, but platform
> might have another dwc3 core doesn't need that quirk.
> So I write the following code, is it in a good shape? :
>=20
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -838,6 +838,9 @@ static int dwc3_probe(struct platform_device *pdev)
>                                 "snps,tx_de_emphasis_quirk");
>                 of_property_read_u8(node, "snps,tx_de_emphasis",
>                                 &tx_de_emphasis);
> +
> +               dwc->suspend_on_disconnect_quirk =3D
> of_property_read_bool(node,
> +                               "snps,has_suspend_on_disconnect");
>         } else if (pdata) {
>                 dwc->maximum_speed =3D pdata->maximum_speed;
>                 dwc->has_lpm_erratum =3D pdata->has_lpm_erratum;
> @@ -864,6 +867,8 @@ static int dwc3_probe(struct platform_device *pdev)
>                 dwc->tx_de_emphasis_quirk =3D pdata->tx_de_emphasis_quirk;
>                 if (pdata->tx_de_emphasis)
>                         tx_de_emphasis =3D pdata->tx_de_emphasis;
> +
> +               dwc->suspend_on_disconnect_quirk =3D
> pdata->has_suspend_on_disconnect;
>         }
>=20
>         /* default to superspeed if no maximum_speed passed */

this all looks good, but let's split it in tiny little patches:

1) add macros for new revisions
2) add suspend_on_disconnect_quirk (and the DT counterpart, please don't
	forget to document the new binding)
3) pass the quirk to XHCI through pdata
4) Use the quirk on XHCI

That'll make patches real easy to review. As per the commit log, the
more verbose the better, specially when it comes to the quirk. It needs
to be 100% clear that we cannot detect this in runtime.

cheers

--=20
balbi

--Zljh9u/ceMLi+8mf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtqE0AAoJEIaOsuA1yqRE9zAQAJQ9zod009StGwXwcJKduBfg
VqiJ/rzSZ7AiZekdBF1KIszYNtf0gLInnYePWWUU46gGuqvY68pADhEcav4kYCcx
rw/cs4hvidaDBoOR5ZlP/0JTsAo6YITOKmLQ+H2d2FqzrhXJe0jzMwVxVY+Js6Vb
xVvbR+zKUOKv0ZmvD1eGZUL5UBI52bhcLeQDjnyvjPOO+TrpVEzXBzSX1T7A5xY2
3rDvm6zTAn0MD26UcgDw/052XnCvCcAwkllJr/lC0moK+gBRptaXOfEw+o1Is6zV
noscxdHHqoyFVUG8b6HjepDmNGSYPrPtuA28GKQ/RVzGRAuR1oZnS/sPbIR8AOuO
bmvcWCmp7WMX3HggagmrZV8+1S4cSgc2yzlyzE5hU+MQaCAY3x8em/KQT256rgAt
ITbwvqGyavAQzsm2IMaQaAGeO2tSyi3/sDw6wBJ4g7bemle09kHEPLZT2hzusWLU
lhqn2Gy6ETsPkhmkv+F/hh9/J6cKn9xesAAB2BtMXAoy+VqcVx+HYyE5X0aWyatn
tA1ulcxj2WbkSf/stZKjcvRRKbJUPFUlq8khmHtUtPQA+tyfk4hEp96RnqtGSPyr
sDP6ijKvmTGGJyBNHG5sfEe8gXy/HptEFbLeM+goBOBK3zENxsGDlsjgMYlMCQvs
wmOSpa6g4E0hDS2H3Eac
=7HEe
-----END PGP SIGNATURE-----

--Zljh9u/ceMLi+8mf--
