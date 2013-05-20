Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab3ETUYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 16:24:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:30455 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756561Ab3ETUYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 16:24:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,709,1363158000"; 
   d="asc'?scan'208";a="340421692"
Message-ID: <1369081461.2892.4.camel@jtkirshe-mobl>
Subject: Re: [ 094/136 ] e1000e: fix runtime power management transitions
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Borislav Petkov <bp@suse.de>, Aaron Brown <aaron.f.brown@intel.com>
Date: Mon, 20 May 2013 13:24:21 -0700
In-Reply-To: <1369078550.6828.121.camel@gandalf.local.home>
References: <20130518021557.139113314@goodmis.org>
	 <20130518021656.829696669@goodmis.org> <5197132A.5030308@openvz.org>
	 <1368855636.2235.136.camel@jtkirshe-mobl>
	 <1369078550.6828.121.camel@gandalf.local.home>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-cOOitTHvAOmI/3DErQPb"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cOOitTHvAOmI/3DErQPb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-05-20 at 15:35 -0400, Steven Rostedt wrote:
> On Fri, 2013-05-17 at 22:40 -0700, Jeff Kirsher wrote:
> > On Sat, 2013-05-18 at 09:35 +0400, Konstantin Khlebnikov wrote:
> > > Steven Rostedt wrote:
> > > > 3.6.11.4 stable review patch.
> > > > If anyone has any objections, please let me know.
> > >=20
> > > I don't think that 3.6.y needs this. That was fix for problem which a=
ppeared
> > > in 3.8 after some changes in PCI power management code. Probably it d=
epends
> > > on these changes. If no one complains about problems we should leave =
it as is.
> >=20
> > My thoughts are the same as Konstantin, but I would like Bruce Allan to
> > weigh in on this since he is the e1000e maintainer.  Since it is late
> > Friday night, Bruce probably won't see this until Monday to respond.
>=20
> Any word on this? I'll wait till tomorrow to do the release. If I don't
> hear anything, then I may just remove it.
>=20
> Thanks,
>=20
> -- Steve
>=20

Drop it from the release please.

Cheers,
Jeff

> >=20
> > > >
> > > > ------------------
> > > >
> > > > From: Konstantin Khlebnikov<khlebnikov@openvz.org>
> > > >
> > > > [ Upstream commit 66148babe728f3e00e13c56f6b0ecf325abd80da ]
> > > >
> > > > This patch removes redundant actions from driver and fixes its inte=
raction
> > > > with actions in pci-bus runtime power management code.
> > > >
> > > > It removes pci_save_state() from __e1000_shutdown() for normal adap=
ters,
> > > > PCI bus callbacks pci_pm_*() will do all this for us. Now __e1000_s=
hutdown()
> > > > switches to D3-state only quad-port adapters, because they needs qu=
irk for
> > > > clearing false-positive error from downsteam pci-e port.
> > > >
> > > > pci_save_state() now called after clearing bus-master bit, thus __e=
1000_resume()
> > > > and e1000_io_slot_reset() must set it back after restoring configur=
ation space.
> > > >
> > > > This patch set get_link_status before calling pm_runtime_put() in e=
1000_open()
> > > > to allow e1000_idle() get real link status and schedule first runti=
me suspend.
> > > >
> > > > This patch also enables wakeup for device if management mode is ena=
bled
> > > > (like for WoL) as result pci_prepare_to_sleep() would setup wakeup =
without
> > > > special actions like custom 'enable_wakeup' sign.
> > > >
> > > > Cc: Bruce Allan<bruce.w.allan@intel.com>
> > > > Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
> > > > Acked-by: Rafael J. Wysocki<rafael.j.wysocki@intel.com>
> > > > Tested-by: Borislav Petkov<bp@suse.de>
> > > > Tested-by: Aaron Brown<aaron.f.brown@intel.com>
> > > > Signed-off-by: Jeff Kirsher<jeffrey.t.kirsher@intel.com>
> > > > Signed-off-by: Steven Rostedt<rostedt@goodmis.org>
> > >=20
> >=20
> >=20
>=20
>=20



--=-cOOitTHvAOmI/3DErQPb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAABCgAGBQJRmoZ1AAoJEOVv75VaS+3OAisQAIXwfBJLn9mUxG1DRDkvlmI5
MGfItfmhiw7+tI/Zt6tlbJKWcM6E3V6qwFIQ8JtsotiTCCNEFeVRzeuapy82KJTb
Emh1sXL2AWk5008HBP0yS9O1WNk9/6eD7Udfqg8LHTRWwmfXGU4FJkI2Tc8tCdp0
SkywcknDeeFlyoqdm+cuHArcRS2moHZcPtOkkEK1+y6b9tty3f5cB3dzOehX/fzA
9noKC1VrjPXCRT0ufKP6rpmMvYogorVY7LQ9AzTSa2mU4/2Q6H0iR2kB/j/dITLt
GETmF2gHVJ01OFsewCaFTGef6VRnc1FdX+831LK8wv4gnjUqKSPjgtmUq0beav7y
rFQF7FSYxCzKjOAcLk2ulJnDIIfp+8sGhPmPDFE5DZ2oiMYsTIdQdweZlmQ77nS0
lrZbOctdSKz/R0V8uD7+kRaUOHVRxFmQ/8GD/aLFOFZqxCKbhOAHLNHcWkmeyhwK
0RSctoW9rDx8sNEAYqcbUVYno2Xz1dj+OZwkqHhwh3itDpLXfpfFM6T9KGTQPkU7
MZo9BblbQfA86CFI8gJcxn0Z7cDiZya5Uy2V37l5HI4Z2mlPFLk+EPHfv4Mcb0cF
1dPi/oo7J4dDAtxBI6Y5U8/knQ+BRQnmVKB9kdo+mwXibr3AGd2hVlcXMEIdWHT2
/cMbUlUsi+Wtc/A69VLk
=IBGZ
-----END PGP SIGNATURE-----

--=-cOOitTHvAOmI/3DErQPb--

