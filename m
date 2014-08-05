Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbaHEM6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:58:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:37953 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaHEM6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:58:30 -0400
Date: Tue, 5 Aug 2014 14:58:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Pranith Kumar <pranith@gatech.edu>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question regarding "Control Dependencies" in memory-barriers.txt
Message-ID: <20140805125819.GY19379@twins.programming.kicks-ass.net>
References: <CAJhHMCADiEsUC7GsYF7=qMNEyRJerfhC5zh7WQPgkQ0gJn5=5A@mail.gmail.com>
 <20140804185226.GQ8101@linux.vnet.ibm.com>
 <CAJhHMCBEprK9hp786cwguJR=JW7Xxgt4GKX5=E0vikO-D4qmZg@mail.gmail.com>
 <20140805073237.GX3935@laptop>
 <CAJhHMCBjub+_Gg_wC2EoR5OgzwT7JTHr-wzoGp_dePUBVwEG8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y21+uYhi56M1pLFQ"
Content-Disposition: inline
In-Reply-To: <CAJhHMCBjub+_Gg_wC2EoR5OgzwT7JTHr-wzoGp_dePUBVwEG8g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y21+uYhi56M1pLFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 05, 2014 at 08:13:54AM -0400, Pranith Kumar wrote:
> >> 689         q =3D ACCESS_ONCE(a);
> >> 690         BUILD_BUG_ON(MAX <=3D 1); /* Order load from a with store =
to b. */
> >> 691         if (q % MAX) {
> >> 692                 ACCESS_ONCE(b) =3D p;
> >> 693                 do_something();
> >> 694         } else {
> >> 695                 ACCESS_ONCE(b) =3D p;
> >> 696                 do_something_else();
> >> 697         }
> >> 698


> I don't think the write to 'b' here is speculative since it is
> happening in both the legs of the if() conditional. The write to b can
> be pulled out to before the conditional. Without the barrier(), isn't
> the following a valid transformation of the above?
>=20
> BUILD_BUG_ON(MAX <=3D 1); /* this will be compiled out if MAX !=3D 1*/
> q =3D ACCESS_ONCE(a);
> ACCESS_ONCE(b) =3D p; / *BUG: No ordering */
> if (q % MAX) {
>         do_something();
> } else {
>         do_something_else();
> }
>=20
> I don't see how it is preserving the ordering.

Ah, that's what you meant. Yes possibly that's true.

--Y21+uYhi56M1pLFQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT4NTqAAoJEHZH4aRLwOS6Q58P/3XFlMcarIychMls/NRLr4WD
hf4gXbxFFbds2+/NcYYsoQFz6to9GuYqkzuH2w9TtB3wa6U/jnS1LcZ+CbH8HYCj
kGSbrQ5IT0JJa2n6rF+gviGPOlXIu4lxqugqvuZCojwU/YAJzU5SU0G1CPFoSYq0
pUszMt6yvn0Zon9TdQAR32XO/p4LB5xU04GEoQ9401crEldIlGTJPsuHKDcMWglp
k6uSrAgZ+NabA67B3tcl4aMZXjSYRsU61y+MOClESQtqVS1U78Yf7/KnJ/9EK2c5
TRfNvOMEIOzPdkje+MoMfLqK+5DvpnItuaJEa8iG1vvV2YnVW+Uxjw04KlIPUkDj
VecPkb0BwPEPQXKXhUUySxSa1UTX0AQiM7Jf4MqF4acGtH+E2YTku4/I1xUVWtoW
mOlVhd7OBQLzqSaaJj1Lbx1e6qJwOP9RjLZKY2tMUcOJt/b0Tm+vzsnQUgfdxiQ7
IUsP16PYB1sCc5H5fEg7FOJ2ja0MqAHevO5z10lXVLrvHAkJkPm5UIFzXAVAQoy1
y/DBdrIveZpN17vfn8J4pwbKkiG+vOk2/33/wa7JMSLkh+pk09XZPNuqL0RT7FP/
mBqV2YTnFo5ce+WFr3icdCCOTyEyGcoyqddwdU2Du/W3bZOh4p4Vyy8j+BX5C+UO
yCACDM1yT1MHwN/al6G1
=hWUg
-----END PGP SIGNATURE-----

--Y21+uYhi56M1pLFQ--
