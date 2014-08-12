Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbaHLF4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 01:56:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:37730 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbaHLF4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 01:56:39 -0400
Date: Tue, 12 Aug 2014 07:56:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, x86: Use extended offcore mask on Haswell
Message-ID: <20140812055626.GJ9918@twins.programming.kicks-ass.net>
References: <1407802290-619-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SQdXmIN7lSx8hpjK"
Content-Disposition: inline
In-Reply-To: <1407802290-619-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SQdXmIN7lSx8hpjK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 11, 2014 at 05:11:30PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>=20
> HSW-EP has a larger offcore mask than the client Haswell CPUs.
> It is the same mask as on Sandy/IvyBridge-EP. All of
> Haswell was using the client mask, so some bits were missing.
>=20
> On the client parts some bits were also missing compared
> to Sandy/IvyBridge, in particular the bits to match on a L4
> cache hit.
>=20
> The Haswell core in both client and server incarnations
> accepts the same bits (but some are nops), so we can use
> the same mask.
>=20
> So use the snbep extended mask, which is a superset of the
> client and the server, for all of Haswell.
>=20
> This allows specifying a number of extra offcore events, like
> for example for HSW-EP.
>=20
> % perf stat -e cpu/event=3D0xb7,umask=3D0x1,offcore_rsp=3D0x3fffc00100,na=
me=3Doffcore_response_pf_l3_rfo_l3_miss_any_response/ true
>=20
> which were <not supported> before.
>=20
> v2: Post correct patch.
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

I seem to have this patch; so that means this is a repost right?


--SQdXmIN7lSx8hpjK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT6ayKAAoJEHZH4aRLwOS6igEP/R2drG3WfIrVy8lv1WOuQRst
H3zDJl5qh/xMMrQkebzOFB/8jzekD91npM/Mv6I+OiHnAFph1bCPjJKfdKnQiFIG
3eUgw10bS2GAqS10h3V2kMG2qKSDBS9FlEA47rr/xG7pG2W7opj84eF7j/xl/gFc
6ytqzhT8AKivkDj3lovG66ZHOBgMkfFKQtYC1GJz20Pb6JIMvs26YoOkeQeTq3Xh
MJZeotjftlMGRQJELF5k0Qbu+4oDIHCwWxisC+33Saa0KWworbeXvAztm9GJDJpo
Fxlu3WB9qaXIV9D2medzQSA903/1ZNRlAgAPikmYlNFiu+2XG7TpLGrGZPLZjIAQ
zjwwY1JDR0IRdNnwtmePiQg1RLf6Ngoyheqtdcq0oRlaueyJqIiQXnhdN1hgAlct
6fCU/5y40jMinQ1cc/xmP7Ue6+eJoZT5PD2o2ChYZeI3TzeB5P6/z5ZrjUAYMBcJ
lAevIu37JSQ6UX/vLiuI0F5UAYmwc8JRzpGE8h2EaG4fN2JYWqO7Aas/iJg2ep2W
VLCIWxiZC15JGTAk9tAy0qwoTLGiJQzzj7672fVVun7HTdUSoHpV3GY81nCIf9cM
uj+BPzxVdNlX/KIBAtUAe+fz4cuROfrm12ijUx62xmIZ4PKkoSkS7rBJW0Va2uFW
7aoHtKEwa1och7Bn80Ve
=L3U3
-----END PGP SIGNATURE-----

--SQdXmIN7lSx8hpjK--
