Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbaCYIff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:35:35 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45602 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753376AbaCYIf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:35:29 -0400
Date: Tue, 25 Mar 2014 08:50:59 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, andriy.shevchenko@intel.com
Subject: Re: [PATCH v5 1/7] clk: sunxi: Remove calls to clk_put
Message-ID: <20140325075059.GL5416@lukather>
References: <1394723659-4995-1-git-send-email-maxime.ripard@free-electrons.com>
 <1394723659-4995-2-git-send-email-maxime.ripard@free-electrons.com>
 <20140324215120.32624.63543@quantum>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ggdAeHltlv4tpqCr"
Content-Disposition: inline
In-Reply-To: <20140324215120.32624.63543@quantum>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ggdAeHltlv4tpqCr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

On Mon, Mar 24, 2014 at 02:51:20PM -0700, Mike Turquette wrote:
> Quoting Maxime Ripard (2014-03-13 08:14:13)
> > Callers of clk_put must disable the clock first. This also means that a=
s long
> > as the clock is enabled the driver should hold a reference to that cloc=
k.
> > Hence, the call to clk_put here are bogus and should be removed.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>=20
> Looks good to me. There is a balanced clk_put in the module remove
> function?

Actually, this is not part of any module, it's part of the function
called through CLK_OF_DECLARE, so there's never a remove function for
this code.

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--ggdAeHltlv4tpqCr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTMTVjAAoJEBx+YmzsjxAgWkoP/0BFxgIOorhBQum/NS367wak
6yjebqAwuGWclWlqyLf3d8h6x7Z+x1SCpQtXxunZyLfL0lM7gT1XL7i/JVHkVD6K
pce0Rx3YbVtrj6Xw+Mk6BJHfrC9W3g8bSGSxABEtOl30UQ0dP8Ko+JXiD4vo+zwz
CxjGcyyWPNkKf/ZQF1pPBAfMuOv6E1K+0q2JB2nviggyOIttOXAf2/fozDwaW0lF
r5uhKQGhiaHbwvQfFn+HiXBZDn/3TlLikIQk41B4r++uE5csa4Lle+vJek0CkLcZ
1fqTZyCHq6aWRWicdACOA2tLYtgZsX+4ZlJ4rF2UTtOF6DqDAJVvRJMhy0U2fuzx
/cL9mfi3ILcTaWGfvgdy/omhsqBw1Js+btsG0dX8EzqedtU+cuUt0P6l0HFz/wbt
7cUyosoGAXAy13iW8KHLrjMeydR/vf+7cHUxHhY2/mbyoSaL8orrh0O/gkmxmH3A
zKJX/y/kuFvorbcRf+64WlXRb3ZVPQxjwGYKcKKCsrjwBjDmaACl8vjsrYAtnXfr
8azp/SMolKa7HLTsIFhvYBiSBnDcjpHj6cqE/968BGy23vD82fW3KA8Tl/TGarvh
1FWLJkEIbcC28xYofSmtM8rCnigsFWvUHVwxZyxt6Uxt9pppFMfB1BeonyXA6fsQ
mUYf7scUM6fiHv1GbrlL
=N5NY
-----END PGP SIGNATURE-----

--ggdAeHltlv4tpqCr--
