Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab3DVOgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:36:12 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38516 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab3DVOgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:36:09 -0400
Date: Mon, 22 Apr 2013 17:35:37 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sourav Poddar <sourav.poddar@ti.com>
CC: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <khilman@linaro.org>,
        <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Benoit Cousson <b-cousson@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: Re: [PATCHv2 4/5] arm: dts: am33xx: Remove "ti,no_idle_on_suspend"
 property.
Message-ID: <20130422143537.GD7508@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1366638237-6880-1-git-send-email-sourav.poddar@ti.com>
 <1366638237-6880-5-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="at6+YcpfzWZg/htY"
Content-Disposition: inline
In-Reply-To: <1366638237-6880-5-git-send-email-sourav.poddar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--at6+YcpfzWZg/htY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Apr 22, 2013 at 07:13:56PM +0530, Sourav Poddar wrote:
> The "ti,no_idle_on_suspend" property was required to keep ocmcram
> clocks running during idle.
>=20
> But the commit below[1], added in v3.6 should prevent the
> any automaic clock gating for devices without drivers bound.  Since
> there is no driver for the OCM RAM block, we are not affected by
> the automatic idle on suspend anyways.
> [1]:
> commit 72bb6f9b51c82c820ddef892455a85b115460904

your commit log can be improved a bit, it could look like below:

The "ti,no_idle_on_suspend" property was required to keep ocmcram clocks
running during idle.

But commit 72bb6f9 (ARM: OMAP: omap_device: don't attempt late suspend
if no driver bound), added in v3.6 should prevent any automatic clock
gating for devices without drivers bound.  Since there is no driver for
the OCM RAM block, we are not affected by the automatic idle on suspend
anyways which means "ti,no_idle_on_suspend" can be safely removed since
there are no users for it.

other than that:

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--at6+YcpfzWZg/htY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdUq5AAoJEIaOsuA1yqREL9EQAIoFHiv8p3YSlxJKzW2LUbKL
HY5Wk6t+K3dmsz6cUHP9t0FhIXJnanXk/0OKgqf0CxN+tJcqmRVQB68Fz5LNsVYo
8453QvjSTtOgH2YlpyKoL80IbcOBMuOL9JGyLygtlGS0Boop3ip9Qi43kCeT4hBD
m17ctA7PGwKcrU7c+WQfmxRj4XXffm6+cGFzKSfcyvqqguLuh5UQHbBr9Kxsl+9k
HLK1mSbNTzau1bhGCFaER5fHYff5zBKaucaPfik9hpnkUb+a5H4xxVMRdRvjjhTf
sUDiPepWG79ABgnCgqYn1bt3psQjosxEyYFqLu1nf9LLVlGUPAdIKyf4YK1kUXNc
Q9PmuhyHdsiOy6Hfx+KFI0QdCt4rJDC0/8nw3cLid1jz5NqXIX/slzyg+BeMJyl4
yAEVeY3KHnO8DsWSINqppPWmfVbPFChJ3XDJrbDyuxWIve813Jg7M6g+R6L2s4qj
TTG2KF98rdrYTkn1aZ7NaDQq4XIFmlvaNGw9GVxLZTHV+wyGMeS8XT61hCtAZZiu
o5d9QGe0RdJcv+VNdCWHA8UCFWXz+f2p8gF+BIOIJ2nAfEfnqd62gzwVBWhMPpQo
Xv0oJJhyFlPSLG/VrpKzDHRgihDMqOqGPGq+09hvCvoQZp3MmnH6nZN04fnJ8nLc
HHvo9h8fZ+HRRMMtw5n3
=drMv
-----END PGP SIGNATURE-----

--at6+YcpfzWZg/htY--
