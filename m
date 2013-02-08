Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab3BHFpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 00:45:25 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:34019 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab3BHFpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 00:45:24 -0500
Date: Fri, 8 Feb 2013 16:45:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: James Hogan <james.hogan@imgtec.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>
Subject: Re: linux-next build conflict between modules and metag trees
 (LOCKDEP_NOW_UNRELIABLE)
Message-Id: <20130208164515.c10e1bb039801c5894e674cb@canb.auug.org.au>
In-Reply-To: <51148A28.4030307@synopsys.com>
References: <51138CFC.9000508@imgtec.com>
	<51148A28.4030307@synopsys.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__8_Feb_2013_16_45_15_+1100_WnH1cVof5iSgxhnA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Feb_2013_16_45_15_+1100_WnH1cVof5iSgxhnA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vineet,

On Fri, 8 Feb 2013 10:46:24 +0530 Vineet Gupta <Vineet.Gupta1@synopsys.com>=
 wrote:
>
> On Thursday 07 February 2013 04:46 PM, James Hogan wrote:
> >=20
> > The metag architecture tree adds an add_taint(TAINT_DIE) like other
> > architectures do, and the modules-next tree adds the
> > LOCKDEP_NOW_UNRELIABLE flag to all uses of add_taint (but obviously
> > misses arch/metag since it doesn't exist yet), causing a compile error
> > on metag in -next when the two are merged together.
> >=20
> > Is it okay for me to merge your commit 373d4d0 ("taint: add explicit
> > flag to show whether lock dep is still OK.") in modules-next into the
> > base of the metag tree and expect it not to be rebased, so that I can
> > then squash the fix into the metag tree?
> >=20
> > The only commits this would include are:
> > $ git log --oneline linus/master..373d4d0
> > 373d4d0 taint: add explicit flag to show whether lock dep is still OK.
> > 64748a2 module: printk message when module signature fail taints kernel.
>=20
> Being in the same situation as metag (ARC Port), what's the recommended p=
ractice
> here - do we simply cherry-pick these changes into our tree - or do we me=
rge the
> "other" tree on top - ofcourse with premise that "other" tree will not re=
base.

Merging is better, as then the commits only exist once when your tree
gets merged back into Linus' tree.  However, such a merge should explain
why it is being done.  Assuming that the thing you merge does not get
rebased - which in this case, Rusty has said it won;t be.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__8_Feb_2013_16_45_15_+1100_WnH1cVof5iSgxhnA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRFJDrAAoJEECxmPOUX5FEvuYP/1oCVA+7Q+Qy80p4h46BRaui
xyxJU714sQsfmAAXKgOf0ipqbdEXaafvCNs7KGs3pPl2FHkOgMSRASC5oWT6USPQ
uEdWMc7pxxjsVDlbdfUZsoz0qgUfq379c+5ozW+QvNSwMzpwtfE7aCuWRzV9GKJD
s+xVQ35cIcjixdbyxp5HHvt++MeYAFBUTgvYXQp3qlz9o7J0PvEdtVRWmZHyBxMD
zyhzQOtYrV+6al+t0GHSlC9NeEMvfb//e6CgY2qbxS4nXZ0Qr8YG1fq9ydzW7rMC
LBG8ALJ7QERc9Zca1w9hjIuKzHNdPGL+Ut3VcGkO+54QC97eC7ec/thDeTavho7i
/QCbIQ0fcNP9S+SOlNPazTAE9n3mwhy9OvdrZ+H+79hxhN5r3qUmKw9fumD/a4qr
JVRPLCZ4MoRwRDzxTJNRRDUtZ/IwVCF6IWkwdGKBrOs8XpM2FydO+JWHtk57hno/
xVdre6lykpRuy0DkeLPoAC5oVKjiyRMCvhUA6dk2AJ8lWgCgLWD0AjgTYfeDU1bL
uwJ+ApLQKjM9znIsXnD4RjMBka25OULDnsVTDzzQbfDWhBiwNb6kHi9jid/3yXdQ
A7Lw0i+03lHcLuz+TaKpgtapFvGiO2pIq2jbIveJpCqWybzlDa2W3JoBap6Lledh
85+lRJOyhI/g+585a0db
=TlGe
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Feb_2013_16_45_15_+1100_WnH1cVof5iSgxhnA--
