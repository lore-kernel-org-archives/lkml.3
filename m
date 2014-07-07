Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbaGGMoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 08:44:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:49520 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbaGGMoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 08:44:17 -0400
Date: Mon, 7 Jul 2014 14:44:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mateusz Guzik <mguzik@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] sched: fix possible divide by zero in avg_atom
 calculation
Message-ID: <20140707124409.GO6758@twins.programming.kicks-ass.net>
References: <1402750809-31991-1-git-send-email-mguzik@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C+dxB3FEDSxkOkFg"
Content-Disposition: inline
In-Reply-To: <1402750809-31991-1-git-send-email-mguzik@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C+dxB3FEDSxkOkFg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 14, 2014 at 03:00:09PM +0200, Mateusz Guzik wrote:
> proc_sched_show_task does:
> if (nr_switches)
> 	do_div(avg_atom, nr_switches);
>=20
> nr_switches is unsigned long and do_div truncates it to 32 bits, which
> means it can test non-zero on e.g. x86-64 and be truncated to zero for
> division.
>=20
> Fix the problem by using div64_ul instead.
>=20
> As a side effect calculations of avg_atom for big nr_switches are now cor=
rect.
>=20
> Signed-off-by: Mateusz Guzik <mguzik@redhat.com>

Thanks.

--C+dxB3FEDSxkOkFg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTupYZAAoJEHZH4aRLwOS6cJ0P/iEs/ZvWRGaS2ucjO4sMHlcW
Q7VnFvJY6xK5toERaIKZu/VcpsFpp/YHp395/9thkkVRlUbAZ5HxSE6gEuf2HnyJ
xjG9QtU5oeDnbtM/eGEM6VJ9Z5yumoV418PbiYdns2ZbvBJBszT3sC32e1L3aCRB
Bre+do2td14HQQLehIYD6maM6Q7nBFyrTXWaUhQm7yhu0IC5yPdljbNuV2BHhcdM
o4dhuML5rbe203/S/CxnRzb3C1gtbiQG8EkeGAVC+8bcGx0fOlgjvpBrSxg43MiT
XFe/MJCDkASlN4cbj125bmZpjPkPP1uG0xYRUPIqKqiHru4ew7RytvZWxNUj5D21
jh68akZ62Mv0vH/gYNulScrlTUodiPx6qItXofdVyAUfC5FpPfKYtzPATWOiWCC5
3IYrCcYyzyjKEIn6ggHnt3y3fznrJFOY2bZerl/Sttcck1J/SgVJTVGJ2R4xAL0I
XaBvyMqEAmykywwfsvaEItpH8j1bx5/QvuCS6FoOD0OU3lHANd4U8H2yeW6Y9BOI
vOgS2lErM72/KF5TRfDj8ZAn+tf48/8acj3abB2WE4Z5ivxE036mgFM/L6aGji3A
UzEmuEb68dvAsLFYs6AzVft2WxUIojXG6KSgTobz7ynqI0jKCt8rTKpYHhq401zd
5SePNDZwPgDHdXxo4XSg
=UYCQ
-----END PGP SIGNATURE-----

--C+dxB3FEDSxkOkFg--
