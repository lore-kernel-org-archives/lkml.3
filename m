Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796AbaGCHd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 03:33:29 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56320 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739AbaGCHd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 03:33:28 -0400
Date: Thu, 3 Jul 2014 09:33:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: kan.liang@intel.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, andi@firstfloor.org
Subject: Re: [PATCH V2 2/3] perf protect LBR when Intel PT is enabled.
Message-ID: <20140703073321.GU19379@twins.programming.kicks-ass.net>
References: <1404324855-15166-1-git-send-email-kan.liang@intel.com>
 <1404324855-15166-2-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ixDgnS8AC6zwmyK0"
Content-Disposition: inline
In-Reply-To: <1404324855-15166-2-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ixDgnS8AC6zwmyK0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 02, 2014 at 11:14:14AM -0700, kan.liang@intel.com wrote:
> From: Kan Liang <kan.liang@intel.com>
>=20
> If RTIT_CTL.TraceEn=3D1, any attempt to read or write the LBR or LER MSRs=
, including LBR_TOS, will result in a #GP.
> Since Intel PT can be enabled/disabled at runtime, LBR MSRs have to be pr=
otected by _safe() at runtime.

Lines are too long, and the reasoning is totally broken.

If there's active LBR users out there, we should refuse to enable PT and
vice versa. What we should not be doing is using _safe and fault and
generate crap.

--ixDgnS8AC6zwmyK0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTtQdBAAoJEHZH4aRLwOS66PoP/iY4+jaFtuQRIAVzn5oI2Crc
dBh8PyZVcDHRktq8AaqeD2TpUTvUxqHD/UAuRYQK9XxKU9qO50wlAb8Tnzd6h7iN
fdlWx8d7tvGXn+VletVy8go71ym08mAh8QhLpcBJw5nQZfpcxvq/uXaAUxiL2TMa
fnOGLE+4C4P+YMYatk/daU8xVV4Svr91vygGepM7dmotkq44WtL1nFir+k3l9TZZ
PFRdh5vC0i21K7HFnLKrKsGcAxfLMetNo4l50pO38SUJf3/CfnuHfE0BTx/MkQoK
LNhi/ZrVPC7q+jzTYKuLg8cL4YqGG5SdS51SnFBUGBUD8p2rUwn9dNtP5YHHniz1
sSVpjCeb5GUgpxXZztD7x9yNI0gbfuUMVFxKIbAq0cL0d5MauHmdZPP3Xv2t46lT
Yw6sDCWyv5xV4oJ577w/7JZnqO2Mw8qkY61hET5s0MP9jdWL1W2Mt0DXKmvOVrz/
vpp1Bj5+AOnYEWrx2ZH5ae7rvpE5NDKW5Gpod+/xbn4hRIRj1y1w57vlGwYTUmRG
SjNKkcJll597SEcJL2pMnie+xP/jT2i0lY7SjhhRfntKPDJ1v8L4LY9N65VZs1d0
9uPhWKGh/qNsJdMuDQ2LO0R+jNfUQHXa0GjCSpjoXIWnc4MkPm4MgC33YWBxi0od
zsjbvF5kHSy7u5aIGHjv
=Al8z
-----END PGP SIGNATURE-----

--ixDgnS8AC6zwmyK0--
