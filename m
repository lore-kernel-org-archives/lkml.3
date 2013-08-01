Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab3HAGTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 02:19:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:29264 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754465Ab3HAGTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 02:19:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,791,1367996400"; 
   d="asc'?scan'208";a="374379990"
Message-ID: <1375337976.2877.63.camel@jtkirshe-mobl>
Subject: Re: /sys/module/pcie_aspm/parameters/policy not writable?
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Joe Lawrence <joe.lawrence@stratus.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Date: Wed, 31 Jul 2013 23:19:36 -0700
In-Reply-To: <CAErSpo5ig3bxZ3hBUUrzTdc=YqHy7cBGBxOLru4NYdyOOR+W5w@mail.gmail.com>
References: <20130709012611.GA22371@amd.pavel.ucw.cz>
	 <20130709041321.GA30555@kroah.com> <20130709094906.GA3870@amd.pavel.ucw.cz>
	 <20130709101039.GA4479@amd.pavel.ucw.cz>
	 <CAErSpo57qjTkGbNK5qLzJcKuqBGK5=R=raEdyL6M1d5O=FkK_Q@mail.gmail.com>
	 <20130710132950.GA3684@amd.pavel.ucw.cz>
	 <CAErSpo5ig3bxZ3hBUUrzTdc=YqHy7cBGBxOLru4NYdyOOR+W5w@mail.gmail.com>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Bbu8FcgTT+z0G+f/yHO5"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Bbu8FcgTT+z0G+f/yHO5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-07-10 at 13:57 -0600, Bjorn Helgaas wrote:
> [+cc Jeff, Jesse, et al, e1000-devel]
>=20
> Holy cow, you guys have a lot of folks listed in MAINTAINERS for Intel
> drivers :)  This is an ASPM question, if that helps narrow down the
> folks interested.

Bruce Allan is the e1000e maintainer, I have trimmed down the
recipients.  If you simply add e1000-devel mailing list, that will get
to all of us and we can respond accordingly.

I need to put together a patch to remove PJ because he is no longer in
our group.

>=20
> On Wed, Jul 10, 2013 at 7:29 AM, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> >> >> But:
> >> >> 1) it should not list unavailable options
> >> >>
> >> >> 2) operation not permitted seems like wrong error code for
> >> >> operation not supported.
> >> >
> >> > So I forcibly enabled ASPM, and now ping latencies are in normal
> >> > range... no matter how I set
> >> > /sys/module/pcie_aspm/parameters/policy. Strange.
> >> >
> >> > Any ideas what correct solution is?
> >> >                                                                     =
    Pavel
> >> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> >> > (but don't apply)
> > ...
> >> > diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
> >> > index e4b1fb2..9a1b63e 100644
> >> > --- a/drivers/pci/pci-acpi.c
> >> > +++ b/drivers/pci/pci-acpi.c
> >> > @@ -382,7 +382,7 @@ static int __init acpi_pci_init(void)
> >> >
> >> >         if (acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_ASPM) {
> >> >                 printk(KERN_INFO"ACPI FADT declares the system doesn=
't support PCIe ASPM, so disable it\n");
> >> > -               pcie_no_aspm();
> >> > +//             pcie_no_aspm();
> >> >         }
> >> >
> >> >         ret =3D register_acpi_bus_type(&acpi_pci_bus);
> >>
> >> Hi Pavel,
> >>
> >> Interesting.  Can you collect dmesg and "lspci -vvv" output for both
> >> cases (high ping latency and normal ping latency)?
> >
> > Will do. Results are in attachment (200KB...)
> >
> >> Also, how much
> >> difference does this make in ping latency?
> >
> > The ping latency goes from 100msec range to <2msec.
> >
> >> If ASPM is enabled for a
> >> device, e.g., your NIC, the link may be put in a low power state when
> >> the device is idle.  It takes time to exit that low power state, of
> >> course, but I would expect that time to be in the microsecond time and
> >> probably not observable via ping.
> >
> > I'd hope so. 100msec ping makes ssh unpleasant to use.
>=20
> Pavel's ThinkPad X60 has two NICs: Intel 82573L and Intel PRO/Wireless
> 3945ABG.  I'm pretty sure the problem he's reporting is with the
> 82573L.  Ping times are bad (~100msec) when ASPM is enabled, as
> reported by lspci.
>=20
> On Pavel's system, the FADT says we shouldn't enable OSPM control of
> ASPM (ACPI_FADT_NO_ASPM is set), so we set "aspm_disabled =3D 1".  One
> effect is that we don't blacklist the pre-1.1 82573L device, which I
> think results in it being left with the BIOS configuration, which
> apparently has ASPM enabled.  (Pavel, could you confirm the BIOS
> config, e.g., with "pci=3Dearlydump"?)
>=20
> e1000e claims to disable ASPM, but because aspm_disabled is set, the
> driver's call to pci_disable_link_state_locked() actually does nothing
> [1].
>=20
> I experimented [2] with Windows and found that when a driver requests
> PciASPMOptOut, Windows will not touch ASPM config if the _OSC method
> fails, i.e., the BIOS declines to grant ASPM control to the OS.
> However, I do not know if Windows similarly ignores PciASPMOptOut when
> the FADT ACPI_FADT_NO_ASPM bit is set.
>=20
> The PCI core has failed spectacularly at providing useful ASPM
> interfaces.  Do you Intel folks have any suggestions about how to
> resolve this?  I assume that the Windows driver for the 82573L must
> disable ASPM somehow, even though ACPI_FADT_NO_ASPM is set.  Does it
> just use brute-force, as in the version of __e1000e_disable_aspm()
> that's used when CONFIG_PCIEASPM is not set?
>=20
> Bjorn
>=20
> [1] We just merged 2add0ec1, which adds a "can't disable ASPM; OS
> doesn't have ASPM control" message in this case, but I don't think
> Pavel's kernel has this change.  It doesn't change the behavior
> anyway.
>=20
> [2] https://bugzilla.kernel.org/show_bug.cgi?id=3D57331



--=-Bbu8FcgTT+z0G+f/yHO5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAABCgAGBQJR+f34AAoJEOVv75VaS+3OYIIP/1y+0ePh2nCKlEU5z91V45qb
AdLz5vh/ZPR8/Mx+E37eNKMVFG9ySjDS020rm6XaETCIncV+kYWTx2jjTspcIVep
z2+HA2VzCYE91yWqMmWfKgYmI2Ct7WtETBKaUB8f9j2VeptTzSkv3/s3Ukt44rUM
RSDqdBDLWQgFssx6u5HMKPJ8hnzgEteh0ahlWP0azUS6udVBjH7FcTKweYyNLCfA
IC2bjeAgcCUqEzUg52E1rutxCltE9dWPNcIWGsO+Pt3QnTJXIoJlwOt3N2VtcsWR
WqgiK7C5KBhcaNBKlr0hjDj8MrGLRVivzbs7dM+hM2mDo14DzEYz146NL1Nc+7Q/
9dfE7N6+xLEFVTR+AV2r/oFu9u4su3bdu+oIz31QUt+O4w24zlCfttc4JvkXnq8f
HA32eH8Lp2zQE4zmg/sShPz5Vz+cav9J0w5yl796M3etZbESxySEvIbZKWPvGxi/
4saH3qVZDvGwx+7+lKooN2jcaG1Bs0Ym+7amPPwdyw9bKFnaVCdZP+ssI4tzEQC3
kOvQc7v84ewNXqf3eYmitP1WPA+Vikf2hN7yWLvSx8gl49l2LOu+q7NP3VQ7A86D
UqjiMFfQuPDA706k6BTJ9zKgXFMS26mINKSSUD+eerBSNtB42w/X377FsgMMzgZH
HxprBalRuoN6Lij1OqdL
=xKQu
-----END PGP SIGNATURE-----

--=-Bbu8FcgTT+z0G+f/yHO5--

