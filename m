Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab3FLOso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 10:48:44 -0400
Received: from mail.abilis.ch ([195.70.19.74]:15022 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567Ab3FLOsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 10:48:42 -0400
Date: Wed, 12 Jun 2013 16:47:45 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH REBASE] i2c-designware: make SDA hold time configurable
Message-ID: <20130612144743.GB8102@ab42.lan>
References: <20130514110745.GA10906@intel.com>
 <1368536642-7158-1-git-send-email-christian.ruppert@abilis.com>
 <20130610152954.GE2987@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <20130610152954.GE2987@katana>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 10, 2013 at 05:29:55PM +0200, Wolfram Sang wrote:
> On Tue, May 14, 2013 at 03:04:02PM +0200, Christian Ruppert wrote:
> > This patch makes the SDA hold time configurable through device tree.
> >=20
> > [rebased to i2c-current/i2c-next/mainline-3.10-rc1]
> >=20
> > Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> > Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>
>=20
> Hmm, I really have problems adding a generic property. I need to better
> understand why this is needed? What is the usecase? Can't a safe value
> be calculated depending on the bus-speed? Is there a public datasheet
> available somewhere?

I checked with our PCB/Applications team and the data sheets for the
peripherals in question (DVB demodulator front ends) are under NDA.
Mika, you seem to be interested in this patch as well. Do you know of
any publicly available data sheets for hardware requiring this
adjustment?

In the case of the Designware block, the parameter both changes SDA and
START hold times, however, and you'll find lots of data sheets for
hardware with START hold time requirements on the net, e.g.
http://ww1.microchip.com/downloads/en/DeviceDoc/21805B.pdf

The empirical solution in the function i2c_dw_scl_hcnt does not seem to
work in all cases: Our lab guys confirmed that we have several PCB
designs which do not work without adjusting the sda-hold-time parameter
to an appropriate value. The value seems to be different for different
PCBs.

I suspect that this kind of configurability is not the same for all i2c
bus master hardware. If you don't want to add a generic property, would
you accept the patch with the property renamed to dwi2c,sda-hold-time?

Greetings,
  Christian


--=20
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pr=E9-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAlG4ig8ACgkQbI8SbDT4m4+xQACgudMzzFq2VpdSrGO40HHOo3kV
HDgAmgP9Yvcdkp4fZng0JyHCgfBqCd/A
=4bpo
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
