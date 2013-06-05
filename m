Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab3FECD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 22:03:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:14529 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494Ab3FECD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 22:03:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,803,1363158000"; 
   d="asc'?scan'208";a="348258054"
Date: Tue, 4 Jun 2013 21:56:01 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Betty Dall <betty.dall@hp.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Huang Ying <ying.huang@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] PCI/AER: Provide reset_link for firmware first
 root port
Message-ID: <20130605015601.GA27550@gchen.bj.intel.com>
Mail-Followup-To: Bjorn Helgaas <bhelgaas@google.com>,
	Betty Dall <betty.dall@hp.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Huang Ying <ying.huang@intel.com>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
References: <1369924769-17183-1-git-send-email-betty.dall@hp.com>
 <1369924769-17183-4-git-send-email-betty.dall@hp.com>
 <20130604083644.GD20448@gchen.bj.intel.com>
 <1370381931.20051.101.camel@ejdallLaptop>
 <CAErSpo6tDep+BywdJ5FyQ6=kfzKJtFUH5zp57CAaD6enVFU9=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <CAErSpo6tDep+BywdJ5FyQ6=kfzKJtFUH5zp57CAaD6enVFU9=w@mail.gmail.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 04, 2013 at 04:15:21PM -0600, Bjorn Helgaas wrote:
> Date: Tue, 4 Jun 2013 16:15:21 -0600
> From: Bjorn Helgaas <bhelgaas@google.com>
> To: Betty Dall <betty.dall@hp.com>
> Cc: Chen Gong <gong.chen@linux.intel.com>, "Rafael J. Wysocki"
>  <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>,
>  "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
>  "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
>  "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
> Subject: Re: [PATCH v2 3/3] PCI/AER: Provide reset_link for firmware first
>  root port
>=20
> On Tue, Jun 4, 2013 at 3:38 PM, Betty Dall <betty.dall@hp.com> wrote:
> > On Tue, 2013-06-04 at 04:36 -0400, Chen Gong wrote:
> >> On Thu, May 30, 2013 at 08:39:29AM -0600, Betty Dall wrote:
> >> > Date:       Thu, 30 May 2013 08:39:29 -0600
> >> > From: Betty Dall <betty.dall@hp.com>
> >> > To: rjw@sisk.pl, bhelgaas@google.com
> >> > Cc: ying.huang@intel.com, linux-acpi@vger.kernel.org,
> >> >  linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, Betty Dall
> >> >  <betty.dall@hp.com>
> >> > Subject: [PATCH v2 3/3] PCI/AER: Provide reset_link for firmware fir=
st root
> >> >  port
> >> > X-Mailer: git-send-email 1.7.7.6
> >> >
> >> > The firmware first path does not install the aerdrv root port
> >> > service driver, so the firmware first root port does not have
> >> > a reset_link callback. When a firmware first root port does not have
> >> > a reset_link callback, use a new default reset_link similar to what
> >> > we already do for the default_downstream_reset_link(). The firmware
> >> > first default reset_link brings the root port out of SBR if firmware
> >> > left it in SBR.
> >> >
> >> > Changes since v1:
> >> > Removed incorrect setting of p2p_ctrl after the read.
> >> >
> >> > Signed-off-by: Betty Dall <betty.dall@hp.com>
> >> > ---
> >> >
> >> >  drivers/pci/pcie/aer/aerdrv_core.c |   36 +++++++++++++++++++++++++=
+++++++++++
> >> >  1 files changed, 36 insertions(+), 0 deletions(-)
> >> >
> >> >
> >> > diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/a=
er/aerdrv_core.c
> >> > index 8ec8b4f..72f76cd 100644
> >> > --- a/drivers/pci/pcie/aer/aerdrv_core.c
> >> > +++ b/drivers/pci/pcie/aer/aerdrv_core.c
> >> > @@ -413,6 +413,39 @@ static pci_ers_result_t default_downstream_rese=
t_link(struct pci_dev *dev)
> >> >     return PCI_ERS_RESULT_RECOVERED;
> >> >  }
> >> >
> >> > +/**
> >> > + * default_ff_root_port_reset_link - default reset function for fir=
mware
> >> > + *         first Root Port
> >> > + * @dev: pointer to root port's pci_dev data structure
> >> > + *
> >> > + * Invoked when performing link reset at Root Port w/ no aer driver.
> >> > + * This happens through the firmware first path. Firmware may leave
> >> > + * the Root Port in SBR and it is the OS responsiblity to bring it =
out
> >> > + * of SBR.
> >> > + */
> >> > +static pci_ers_result_t default_ff_root_port_reset_link(struct pci_=
dev *dev)
> >> > +{
> >> > +   u16 p2p_ctrl;
> >> > +
> >> > +   /* Read Secondary Bus Reset */
> >> > +   pci_read_config_word(dev, PCI_BRIDGE_CONTROL, &p2p_ctrl);
> >> > +
> >> > +   /* De-assert Secondary Bus Reset, if it is set */
> >> > +   if (p2p_ctrl & PCI_BRIDGE_CTL_BUS_RESET) {
> >> > +           p2p_ctrl &=3D ~PCI_BRIDGE_CTL_BUS_RESET;
> >> > +           pci_write_config_word(dev, PCI_BRIDGE_CONTROL, p2p_ctrl);
> >> > +
> >> > +           /*
> >> > +            * System software must wait for at least 100ms from the=
 end
> >> > +            * of a reset of one or more device before it is permitt=
ed
> >> > +            * to issue Configuration Requests to those devices.
> >> > +            */
> >> > +           msleep(200);
> >> > +           dev_dbg(&dev->dev, "Root Port link has been reset\n");
> >> > +   }
> >> > +   return PCI_ERS_RESULT_RECOVERED;
> >> > +}
> >>
> >> I don't think this function is OK.
> >> 1) You don't really reset the 2nd Bus but just checking its status.
> >> I think you should have following steps to reset 2nd Bus:
> >>
> >> a. Assert 2nd Bus Reset
> >> b. wait for some time until this message has been broadcasted well
> >> c. De-assert 2nd Bus Reset
> >> d. wait for Trst time
> >>
> >> IOW, since we have aer_do_secondary_bus_reset to perform secondary bus
> >> reset, why you repeat it again?
> >>
> >> 2) msleep(200) is too long for kernel. You'd better yield the CPU when
> >> sleep.
> >
> > The firmware first path currently has no reset_link. I want to make a
> > minimal change since resetting the link could be considered firmware's
> > job in the firmware first path. This change is to just check if SBR is
> > set, and bring the link out of reset only if it is in SBR.  This way, if
> > a another firmware first platform is already resetting the link, it
> > won't be done twice. I took the msleep and the code from
> > aer_do_sercondary_bus_reset() as you noticed.
>=20
> I understand the desire to make a minimal change, and we certainly
> don't want to make changes bigger than they need to be.
>=20
> However, my goal is really to have clean, maintainable code at the
> end.  If that means bigger patches where you can't test every affected
> platform, that's a risk I'm willing to take.
>=20
> In this particular case, we could try to limit the change to just the
> platforms you can test, as you've done.  But it looks to me like we
> actually want to reset the link in *all* cases, regardless of whether
> firmware-first is involved.  We're handling a fatal error for a
> device.  That device might be below a PCIe switch (where we currently
> reset the link), or it might be directly below a root port (where we
> currently don't).  Why should those cases be different?  I don't think
> the device or the driver should be able to tell the difference.
>=20
> My *guess* is that this is an oversight in the original code, and that
> doing the link reset for both downstream ports and root ports will
> make error handling for devices below root ports work better.
>=20
> The *last* thing I want is code littered with special cases that are
> only there because "they only fix the platforms I could actually
> test."  It's just about impossible to clean those up later.
>=20
> Bjorn

I agree with Bjorn's conclusion. Once we meet a bogus BIOS implementation,
it will be a disaster for that device.

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRrpqxAAoJEI01n1+kOSLHYcQP/32YELY4SB3ec+K/Oxb1O30N
tOWxqQNQT+4mTtM4WvrRB2MXfpYItaQYBqV1YHgSvYGpy3d1+lRXY3tbEqRgNre+
O7V0QvJP61DG9ONHd3bT8/M4UYwSwF9Xn8pMkae3LxbTcbfTS/H1s6+xc/KDmYGw
CUXSm31H0LiWTnLrNP8X+0UM5CYrBBe3jktosK0Ij5mSK8KkEYxPKkq7roQkEWcp
aiDtbbJ7t29vJjgauSjF8jrfTrCqZaf/39GXxzSP8fkY2LHi/sJ0eujl/cAnS38y
q5luFpx4zeFOBU+WtTqFPTHMcwTUJgnCOhWw+CSPD3pLQbq45lxyugzkrPZcXaVY
4I3u1OKcTgmllgghk/oqj9RZ+l96ideVOtc/mIjajcmk/6y42REIGWSwmvafOAqS
lqg1+rfawm+Golt6QToypOMf/dPFar8TmvKocfspea5URre+lavxPOx8Ti1uvrho
wPAKiNUlxnNVrduUiUAdAbs9KdsUTvl8/wx+NCzSKZnZh9G8jXmIb0TwJvweo9Di
gJWy8apC3domUqpIraDYJEDDFpHcW7hHeJESIVX0NfYshhNNacGyZoy2eGsLBsGj
b+4LEtkRqr83Fw+kAAnb31CDgdpYclw95LRnL7x3OtMrG5wKa5jDFlFv+wimy5uR
q0RrFdYokwiQEkVYKT0q
=Lw4o
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
