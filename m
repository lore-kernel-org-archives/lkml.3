Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbaIDUE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 16:04:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45940 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210AbaIDUEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 16:04:23 -0400
Date: Thu, 4 Sep 2014 15:04:03 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>, <josh@joshtriplett.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: RCU bug with v3.17-rc3 ?
Message-ID: <20140904200403.GL13421@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140904184021.GA13421@saruman.home>
 <20140904191642.GJ5001@linux.vnet.ibm.com>
 <20140904192535.GJ13421@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bPg9NdpM9EETxvqt"
Content-Disposition: inline
In-Reply-To: <20140904192535.GJ13421@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bPg9NdpM9EETxvqt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 04, 2014 at 02:25:35PM -0500, Felipe Balbi wrote:
> On Thu, Sep 04, 2014 at 12:16:42PM -0700, Paul E. McKenney wrote:
> > On Thu, Sep 04, 2014 at 01:40:21PM -0500, Felipe Balbi wrote:
> > > Hi,
> > >=20
> > > I keep triggering the following Oops with -rc3 when writing to the ma=
ss
> > > storage gadget driver:
> >=20
> > v3.17-rc3, correct?
>=20
> yup, as in subject ;-)
>=20
> > I take it that the test passes on some earlier version?
>=20
> about to test v3.14.17.

coudln't get v3.14 working on this board but at least v3.16 is also
affected except that on now it happened during boot, I didn't even need
to run my test:

[   17.438195] Unable to handle kernel paging request at virtual address ff=
ffffff
[   17.446109] pgd =3D ec360000
[   17.448947] [ffffffff] *pgd=3Dae7f6821, *pte=3D00000000, *ppte=3D00000000
[   17.455639] Internal error: Oops: 17 [#1] SMP ARM
[   17.460578] Modules linked in: dwc3(+) udc_core lis3lv02d_i2c lis3lv02d =
input_polldev dwc3_omap matrix_keypad
[   17.471060] CPU: 0 PID: 1381 Comm: accounts-daemon Tainted: G W     3.16=
=2E0-00005-g8a6cdb4 #811
[   17.480735] task: ed716040 ti: ec026000 task.ti: ec026000
[   17.486405] PC is at find_get_entry+0x7c/0x128
[   17.491070] LR is at 0xfffffffa
[   17.494364] pc : [<c0110b4c>]    lr : [<fffffffa>]    psr: a0000013
[   17.494364] sp : ec027dc8  ip : 00000000  fp : ec027dfc
[   17.506384] r10: c0c6f6bc  r9 : 00000005  r8 : ecdf22f8
[   17.511860] r7 : ec026008  r6 : 00000001  r5 : 00000000  r4 : 00000000
[   17.518705] r3 : ec027db4  r2 : 00000000  r1 : 00000005  r0 : ffffffff
[   17.525526] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM Segment =
user
[   17.533007] Control: 10c5387d  Table: ac360059  DAC: 00000015
[   17.539020] Process accounts-daemon (pid: 1381, stack limit =3D 0xec0262=
48)
[   17.546151] Stack: (0xec027dc8 to 0xec028000)
[   17.550710] 7dc0:                   00000000 00000000 c0110ad0 ecdf0b80 =
00000000 ecdf22f4
[   17.559259] 7de0: ecdf22f4 00000000 00000005 00000000 ec027e34 ec027e00 =
c0111874 c0110adc
[   17.567824] 7e00: ecdf0b80 c03565b4 ed7165f8 ec3dddf0 ecdf22f4 00000005 =
ec3ddd00 00000001
[   17.576385] 7e20: ecdf21a0 00000000 ec027ebc ec027e38 c0112978 c0111844 =
00000000 c06af938
[   17.584950] 7e40: ecdf0b70 ecdf0b70 ec027e6c ec027e58 00000005 00000006 =
00000b80 ecdf0b70
[   17.593514] 7e60: 00000000 c0163264 ec3dddf0 ec027ee8 ec027ed4 00000b80 =
ec027eac ec027e88
[   17.602087] 7e80: c0178d98 c0356590 00000000 00000000 00020000 00005b80 =
00000000 ec027f78
[   17.610653] 7ea0: ec3ddd00 ed716040 b6cab018 00000000 ec027f44 ec027ec0 =
c0163264 c0112780
[   17.619202] 7ec0: 00000180 00000180 ec027efc b6cab018 00000180 00000000 =
00000000 00000180
[   17.627772] 7ee0: ec027ecc 00000001 ec3ddd00 00000000 00000000 00000000 =
ed716040 00000000
[   17.636371] 7f00: 00000000 00000000 00005b80 00000000 00000180 00000000 =
00000000 00000000
[   17.644946] 7f20: b6cab018 ec3ddd00 b6cab018 ec027f78 ec3ddd00 00000180 =
ec027f74 ec027f48
[   17.653524] 7f40: c0163a6c c01631cc b6cab018 00000000 00005b80 00000000 =
ec3ddd03 ec3ddd00
[   17.662085] 7f60: 00000180 b6cab018 ec027fa4 ec027f78 c0164198 c01639e0 =
00005b80 00000000
[   17.670658] 7f80: be91badc be91ba50 00044a00 00000003 c000f044 ec026000 =
00000000 ec027fa8
[   17.679222] 7fa0: c000edc0 c0164158 be91badc be91ba50 00000008 b6cab018 =
00000180 be91ba38
[   17.687794] 7fc0: be91badc be91ba50 00044a00 00000003 be91bbac b6cab008 =
00000000 00000000
[   17.696370] 7fe0: 00000020 be91ba40 b6c78e8c b6c78ea8 60000010 00000008 =
ae7f6821 ae7f6c21
[   17.704956] [<c0110b4c>] (find_get_entry) from [<c0111874>] (pagecache_g=
et_page+0x3c/0x1f4)
[   17.713687] [<c0111874>] (pagecache_get_page) from [<c0112978>] (generic=
_file_read_iter+0x204/0x794)
[   17.723259] [<c0112978>] (generic_file_read_iter) from [<c0163264>] (new=
_sync_read+0xa4/0xcc)
[   17.732185] [<c0163264>] (new_sync_read) from [<c0163a6c>] (vfs_read+0x9=
8/0x158)
[   17.739945] [<c0163a6c>] (vfs_read) from [<c0164198>] (SyS_read+0x4c/0xa=
0)
[   17.747149] [<c0164198>] (SyS_read) from [<c000edc0>] (ret_fast_syscall+=
0x0/0x48)
[   17.754994] Code: e1a01009 eb08ffa9 e3500000 0a00001f (e5904000)=20
[   17.761476] ---[ end trace 49c4ed35a1c01157 ]---

It seems to be a difficult-to-reproduce race though. On a second boot it
didn't die during boot, but died with my USB test case. Unfortunately,
the platform I'm using is pretty new and only goes as far back as v3.16
(which I had to backport 11 patches to get it to boot good enough for
this test).

I wonder if a corrupt file system could cause such problems... I keep
seeing EXT4 errors every now and again; considering that this dies in a
path through VFS, I wonder...

cheers

--=20
balbi

--bPg9NdpM9EETxvqt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUCMWzAAoJEIaOsuA1yqREpO8P/RbWn9wzZ/B08FW3tCSDcgvf
XmmFSbhV0XLbAW3MNSRn0gicnyQJmycO7OV3Ne/meLMf0uXhhtRE/z+YUbUlqyg2
dxm1T61wKf6RDLS+HgD7qClWrkJ0vtwhEP2S874FF8q61m4AxvJXc23pKTn72VtQ
cSsBelbIj3eTmEbHUPUFg5KWA8gJkr0pJxrb4uT8nh39CCgJTmckEs3rhOq3ZxDY
09DnhQ7ZHTjMas5/QcGesjOstvLketZgBJ1pc3KhHmmXO5hoce3Pu8usedAqMOfb
O5lvh0NIMpR3oh6e89MAC3ITNJWq/HYIRiIGcPrL+5BWLtQsUsZIo4F3MPDLkgd0
D+UptjuzLjk6FY9IMtgW1YvqFQgndi01WuylvES4EixGFA4ZJhWQWY6nh6D4x8OH
uxEiRM+YPMTxRmjIACVJT1MMkBBXVEjgkwX1d93lOzsrzPs/gSYzBXw0eG88bGC8
3ffjkmmqTmPhsphSOI77T06xNiHwwMXf4gFSAN9bdqnrVmaIJK4/fim5xomgjprA
J5lGlsfQ4jp5eU2LKIcbBUgxYTIwlRJYdhfiP+vEuQ6HCEaw6P3QuMo1EYqZoZgp
5voW09jGSYz3/n3hAPOraFa3YfuHotG6IXxn1J2+z6vja7LFaK8QNUG2PkSG7QcX
g5fmxx/IgSnSLzxd3ncs
=207U
-----END PGP SIGNATURE-----

--bPg9NdpM9EETxvqt--
