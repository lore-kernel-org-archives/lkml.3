Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbaGHOb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:31:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:55053 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbaGHObW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:31:22 -0400
Date: Tue, 8 Jul 2014 16:31:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH V3 1/2] perf ignore LBR and offcore_rsp.
Message-ID: <20140708143113.GQ19379@twins.programming.kicks-ass.net>
References: <1404740066-4374-1-git-send-email-kan.liang@intel.com>
 <20140708092923.GC6758@twins.programming.kicks-ass.net>
 <37D7C6CF3E00A74B8858931C1DB2F077014CDF76@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nDAeJifZeokOLf48"
Content-Disposition: inline
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F077014CDF76@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nDAeJifZeokOLf48
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 08, 2014 at 02:22:25PM +0000, Liang, Kan wrote:
> > This too is wrong in many ways; there's more than 2 extra_msrs on many
> > systems.
> >=20
> Right, there are four extra  reg types on Intel systems. Since my
> previous test only triggers the crash with RSP_0 and RSP_1, so I only
> handle these two msrs.  I will handle all the extra msrs then.

Yeah, so to other two are PEBS related, and I think we disable PEBS
early on so you'll never hit them or something; didn't look too closely.

> > And the place you check is abysmal, if we know at init time that we don=
't
> > have those MSRs, WTF do you allow event creation that would use them,
> > only to then misbehave?
>=20
> Right, we can check it at all the possible creation places.  I think
> the most common place to check should be x86_pmu_extra_regs.  For
> RSP_0 and RSP_1, I also plan to do the check in intel_fixup_er, so
> extra_reg will not be updated.  For LBR select, lbr_sel_map will be
> cleared at runtime once check_msr failed.  Besides the three places,
> is there any place I missed?

I think that's sufficient; but didn't stare too hard.

--nDAeJifZeokOLf48
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTvACxAAoJEHZH4aRLwOS6NmQQALDTN9cc5vSkALZO0/C00AuZ
m1zFGZjh/w+Is++ttACcPA9NPY1auwgBqx+9Ftc2jcQrfCK6lRVhcIeTIzE6gPur
H2AWYY/nu7l0R1syLgu0HFHlIBn7PxRwFmevdF7vSSG/jO3HfSelD4glTNbviJhl
zLK4auIJ46GCWkWb3Y1y6e7Rr8G3v5JrP0cWDPzqCBHFNFHlXTWUpQFcsodjJ/r2
BdVEYILD4Dxiw8YNt3sEd9mW3ZiBvcKA8mcD3J1coxUStdXdv4kGFA3M2IBal7J9
Ll3FUA7+R1T1sKhph2Ohe2ViOshgQVazA/udWfUQJCElK+1ZENnF+MPp159lUmm9
Dk4I1HeUBaEMx4aQuX9NHNNahVEhZ31IyLFMmcdXLv4J9+zYbXoBt9iaMcsT/kwl
FPBhnv2QjVtTTzySqLrkYzsbCkb9tvcR8M4ykyVYpm1JMhPZEmMBDgkTuKq2FpvR
YOoxfuVlKxaL5fvTjlQ8Nz1xkKyJaMvNnuIVGg5NjYDSeUnSXr9o7b3PGb85Q5Nn
60WkT2r5OXf39yccAdpxo8mC1qJDaAmBtDfQulU0ppLhcckkOBoyCd1qQPsj/VQf
uBUCAsTE6xpsu94L/+Ky0fpCt9Zny/9f8Ubf5fDEXzdJ2MhJLoz4CjwdtTjkFo6l
0RtwtVfhP83Xph0oMPIy
=NPSZ
-----END PGP SIGNATURE-----

--nDAeJifZeokOLf48--
