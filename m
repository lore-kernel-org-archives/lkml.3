Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab3IYSca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 14:32:30 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36799 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab3IYSc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 14:32:28 -0400
Date: Wed, 25 Sep 2013 19:32:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: devicetree@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Message-ID: <20130925183201.GT3226@sirena.org.uk>
References: <1380131272-16982-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pnDjx0H/VpusRTEI"
Content-Disposition: inline
In-Reply-To: <1380131272-16982-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH] mfd: arizona: Update device tree regulator bindings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pnDjx0H/VpusRTEI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 25, 2013 at 06:47:52PM +0100, Charles Keepax wrote:

> This patch creates a sub-node for the codec and attaches the required
> regulators here using the of_compatible field on the mfd_cell.

> Another issue with the Arizona bindings, I am not sure
> exactly what the best approach is this patch seems like the
> "correct" fix, but it does require a change to the binding,
> although the current binding is non-functional.

No, this is not sensible - what you're doing here is clearly a Linux
implementation detail. =20

> Alternatively I could simply set the codec of_node to match
> the mfd one manually in the codec driver which wouldn't need
> the binding changing but feels a bit like a work around.

That's not clever either, fiddling around with the data structures like
that is bound to cause referencing problems ("I just freed the device,
let's clean up all the memory") and general fragility.

> Any thoughts would be greatly appreciated?

You need to do something like arrange for the regulator API to resolve
attempts to look up regulators on the subnode using the parent, the
device is virtual after all.

--pnDjx0H/VpusRTEI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSQyweAAoJELSic+t+oim94x4P/0Vlu7TTeBJPh4eB4/jXbaKq
abD/w2eQNBNDc30li0bqNDgIJHGjjdSTXrRs2t8S1if3cf6IOozsii9JkUeV2La6
EBPgRrEqUrOuz6BmWJMwSrE5QOOhFScmzbSPo/oORXhVpOuW3EIvFzp7IPZJJfwg
Wz0Uqg0rZ5ZEQ6XvrMJEt/Nm+1WmwTROGMUttJIBEAZ+JXeLzE6vQiu/FOJokgvH
ha6Mdn0FB49ZygvTKWDaJ/zuI8JxQHrEQ07A574rZtqThaJB/BfgcEgoeb9Nqw0/
Vzh6JvlwY1wwIYlyqKT7f3kcN5uJMPSF/HJUwfg5Eef5lVqfH6s4TJfBSpEu4FQc
tCkEdjgKpgg5MkVq0IToOQEbg+qImCF+mFbU3GDr2VW3cUiaQW7PnQGqPNEedlxu
ban/RHYMjCSiJiPmq8ZR3J+inx9lSQszUvUMITQBU+UV3slvcVGD8RTwLiokoJ91
MtPQb5I+QYe9f8mmbUHdmXlh8Wtmp6NuN5DcEfFDSiEHHrkI1KrIKLKqa1k0I9M4
vV9iTsibhIeo+Nof3n/nblPgQMXxQrfdUAm/Oj6mtwHVDi0M9fcGaOB+Uh7BMM5Y
3/wnlUAs/hr4PIWBWEu9maUVbfs/8IMaeAVWTFX54aLGRED1HkRzE5KsX3h+pnGR
AumB/PcGWT3TVTkSre5C
=kxbZ
-----END PGP SIGNATURE-----

--pnDjx0H/VpusRTEI--
