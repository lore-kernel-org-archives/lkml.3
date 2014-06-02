Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202AbaFBVCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:02:08 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51215 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbaFBVCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:02:06 -0400
Date: Mon, 2 Jun 2014 22:01:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lee.jones@linaro.org, sameo@linux.intel.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Message-ID: <20140602210117.GO31751@sirena.org.uk>
References: <1401699704-17902-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lCFQJunhLz1tFGpX"
Content-Disposition: inline
In-Reply-To: <1401699704-17902-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 109.148.252.180
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] mfd: core: Add the option to order destruction of
 MFD cells
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lCFQJunhLz1tFGpX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 02, 2014 at 10:01:43AM +0100, Charles Keepax wrote:
> Sometimes MFD children will have interdependancies. For example an MFD
> device might contain a regulator cell and another cell which requires
> that regulator to function. Probe deferral will ensure that these
> devices probe in the correct order, however currently nothing ensures
> they are destroyed in the correct order. As such it is possible for a
> cell to be destroyed whilst another cell still expects it to exist. For
> example the cell mentioned earlier would attempt to do a regulator_put
> as part of its own tear-down but the regulator may have already been
> destroyed.

Probe deferral is supposed to handle removal too, we're supposed to be
able to walk the device list in reverse order and everything just work.

--lCFQJunhLz1tFGpX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjOYTAAoJELSic+t+oim9MjQP/3kt216TW4L9npAhn5Ng4G90
xbl0lgrx7y2ya5KbvX9XHKMzSostGcoXKTP0dTcy/cvQJ0o+Ln0Xfnac2O024zJq
InIFP4nHVywNS8nqRxu9Yf1FJG9vXN265ry4Nj+scRpqc2sHPTM2k/LonzCic89i
IYIqcGSNAEoaJGSNLXTE4IrmsrJtQQy0nuifDuVhY3aSDsWXQEvuthM5Bz3bQOhd
9ZyGT/VDHHWapEyshbypI3T7Kyy2ES2pOU1iomBIjRYv2N40wAJl2n6EebW4QNJJ
ql52VwAYJ20Zq5d7MPkRouQVdrZqazWLrCJq7Kml0Orxo4HQxuAYvoHJgBaYvtoV
VgrnyUfiyvdyBX4R5Ln1IYq0yHlY5STSSWIdQppy10dJhDRCFA2laL7f05kjM5yI
N7/6pb28ZYRat9iMayH0ZwiwbwQuZW+ZhpO8HeSn83UiNzr24mEHSDapYLa7H02E
P2XHbmh7oaAxYf3W0jdyFRqC3znRC2AEuIm3iRR7jg9YGgKq1A10SeC+eEhcvNQd
5cOLp7Yc9rR5iUCorGoF2VO/cAiegV2AySaxa2te+B3R5SkcBvIIozqEbfIcxaOD
JHndAOEGr/++5DLb8xIFWb0OjkGZksz4wRSW0PWHbOD5SBwxB6TasP8uLZ9PToo0
K5Xha12kifbhleSw4DDq
=amD3
-----END PGP SIGNATURE-----

--lCFQJunhLz1tFGpX--
