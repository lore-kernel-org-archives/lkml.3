Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbaJHR5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 13:57:40 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54122 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbaJHR5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 13:57:38 -0400
Date: Wed, 8 Oct 2014 12:57:07 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>, <josh@joshtriplett.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: RCU bug with v3.17-rc3 ?
Message-ID: <20141008175707.GI22688@saruman>
Reply-To: <balbi@ti.com>
References: <20140904184021.GA13421@saruman.home>
 <20140904191642.GJ5001@linux.vnet.ibm.com>
 <20140904192535.GJ13421@saruman.home>
 <20140904200403.GL13421@saruman.home>
 <20140905213216.GD5001@linux.vnet.ibm.com>
 <20141008171322.GH22688@saruman>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uJWb33pM2TcUAXIl"
Content-Disposition: inline
In-Reply-To: <20141008171322.GH22688@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--uJWb33pM2TcUAXIl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 08, 2014 at 12:13:22PM -0500, Felipe Balbi wrote:
> On Fri, Sep 05, 2014 at 02:32:16PM -0700, Paul E. McKenney wrote:
> > On Thu, Sep 04, 2014 at 03:04:03PM -0500, Felipe Balbi wrote:
> > > Hi,
> > >=20
> > > On Thu, Sep 04, 2014 at 02:25:35PM -0500, Felipe Balbi wrote:
> > > > On Thu, Sep 04, 2014 at 12:16:42PM -0700, Paul E. McKenney wrote:
> > > > > On Thu, Sep 04, 2014 at 01:40:21PM -0500, Felipe Balbi wrote:
> > > > > > Hi,
> > > > > >=20
> > > > > > I keep triggering the following Oops with -rc3 when writing to =
the mass
> > > > > > storage gadget driver:
> > > > >=20
> > > > > v3.17-rc3, correct?
> > > >=20
> > > > yup, as in subject ;-)
> > > >=20
> > > > > I take it that the test passes on some earlier version?
> > > >=20
> > > > about to test v3.14.17.
> > >=20
> > > coudln't get v3.14 working on this board but at least v3.16 is also
> > > affected except that on now it happened during boot, I didn't even ne=
ed
> > > to run my test:
> > >=20
> > > [   17.438195] Unable to handle kernel paging request at virtual addr=
ess ffffffff
> > > [   17.446109] pgd =3D ec360000
> > > [   17.448947] [ffffffff] *pgd=3Dae7f6821, *pte=3D00000000, *ppte=3D0=
0000000
> > > [   17.455639] Internal error: Oops: 17 [#1] SMP ARM
> > > [   17.460578] Modules linked in: dwc3(+) udc_core lis3lv02d_i2c lis3=
lv02d input_polldev dwc3_omap matrix_keypad
> > > [   17.471060] CPU: 0 PID: 1381 Comm: accounts-daemon Tainted: G W   =
  3.16.0-00005-g8a6cdb4 #811
> > > [   17.480735] task: ed716040 ti: ec026000 task.ti: ec026000
> > > [   17.486405] PC is at find_get_entry+0x7c/0x128
> > > [   17.491070] LR is at 0xfffffffa
> > > [   17.494364] pc : [<c0110b4c>]    lr : [<fffffffa>]    psr: a0000013
> > > [   17.494364] sp : ec027dc8  ip : 00000000  fp : ec027dfc
> > > [   17.506384] r10: c0c6f6bc  r9 : 00000005  r8 : ecdf22f8
> > > [   17.511860] r7 : ec026008  r6 : 00000001  r5 : 00000000  r4 : 0000=
0000
> > > [   17.518705] r3 : ec027db4  r2 : 00000000  r1 : 00000005  r0 : ffff=
ffff
> > > [   17.525526] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM Se=
gment user
> > > [   17.533007] Control: 10c5387d  Table: ac360059  DAC: 00000015
> > > [   17.539020] Process accounts-daemon (pid: 1381, stack limit =3D 0x=
ec026248)
> > > [   17.546151] Stack: (0xec027dc8 to 0xec028000)
> > > [   17.550710] 7dc0:                   00000000 00000000 c0110ad0 ecd=
f0b80 00000000 ecdf22f4
> > > [   17.559259] 7de0: ecdf22f4 00000000 00000005 00000000 ec027e34 ec0=
27e00 c0111874 c0110adc
> > > [   17.567824] 7e00: ecdf0b80 c03565b4 ed7165f8 ec3dddf0 ecdf22f4 000=
00005 ec3ddd00 00000001
> > > [   17.576385] 7e20: ecdf21a0 00000000 ec027ebc ec027e38 c0112978 c01=
11844 00000000 c06af938
> > > [   17.584950] 7e40: ecdf0b70 ecdf0b70 ec027e6c ec027e58 00000005 000=
00006 00000b80 ecdf0b70
> > > [   17.593514] 7e60: 00000000 c0163264 ec3dddf0 ec027ee8 ec027ed4 000=
00b80 ec027eac ec027e88
> > > [   17.602087] 7e80: c0178d98 c0356590 00000000 00000000 00020000 000=
05b80 00000000 ec027f78
> > > [   17.610653] 7ea0: ec3ddd00 ed716040 b6cab018 00000000 ec027f44 ec0=
27ec0 c0163264 c0112780
> > > [   17.619202] 7ec0: 00000180 00000180 ec027efc b6cab018 00000180 000=
00000 00000000 00000180
> > > [   17.627772] 7ee0: ec027ecc 00000001 ec3ddd00 00000000 00000000 000=
00000 ed716040 00000000
> > > [   17.636371] 7f00: 00000000 00000000 00005b80 00000000 00000180 000=
00000 00000000 00000000
> > > [   17.644946] 7f20: b6cab018 ec3ddd00 b6cab018 ec027f78 ec3ddd00 000=
00180 ec027f74 ec027f48
> > > [   17.653524] 7f40: c0163a6c c01631cc b6cab018 00000000 00005b80 000=
00000 ec3ddd03 ec3ddd00
> > > [   17.662085] 7f60: 00000180 b6cab018 ec027fa4 ec027f78 c0164198 c01=
639e0 00005b80 00000000
> > > [   17.670658] 7f80: be91badc be91ba50 00044a00 00000003 c000f044 ec0=
26000 00000000 ec027fa8
> > > [   17.679222] 7fa0: c000edc0 c0164158 be91badc be91ba50 00000008 b6c=
ab018 00000180 be91ba38
> > > [   17.687794] 7fc0: be91badc be91ba50 00044a00 00000003 be91bbac b6c=
ab008 00000000 00000000
> > > [   17.696370] 7fe0: 00000020 be91ba40 b6c78e8c b6c78ea8 60000010 000=
00008 ae7f6821 ae7f6c21
> > > [   17.704956] [<c0110b4c>] (find_get_entry) from [<c0111874>] (pagec=
ache_get_page+0x3c/0x1f4)
> > > [   17.713687] [<c0111874>] (pagecache_get_page) from [<c0112978>] (g=
eneric_file_read_iter+0x204/0x794)
> > > [   17.723259] [<c0112978>] (generic_file_read_iter) from [<c0163264>=
] (new_sync_read+0xa4/0xcc)
> > > [   17.732185] [<c0163264>] (new_sync_read) from [<c0163a6c>] (vfs_re=
ad+0x98/0x158)
> > > [   17.739945] [<c0163a6c>] (vfs_read) from [<c0164198>] (SyS_read+0x=
4c/0xa0)
> > > [   17.747149] [<c0164198>] (SyS_read) from [<c000edc0>] (ret_fast_sy=
scall+0x0/0x48)
> > > [   17.754994] Code: e1a01009 eb08ffa9 e3500000 0a00001f (e5904000)=
=20
> > > [   17.761476] ---[ end trace 49c4ed35a1c01157 ]---
> > >=20
> > > It seems to be a difficult-to-reproduce race though. On a second boot=
 it
> > > didn't die during boot, but died with my USB test case. Unfortunately,
> > > the platform I'm using is pretty new and only goes as far back as v3.=
16
> > > (which I had to backport 11 patches to get it to boot good enough for
> > > this test).
> > >=20
> > > I wonder if a corrupt file system could cause such problems... I keep
> > > seeing EXT4 errors every now and again; considering that this dies in=
 a
> > > path through VFS, I wonder...
> >=20
> > I recall hearing of similar things in the past, but must defer to the
> > FS/VFS experts on this one.
>=20
> resurrecting this thread. I'm facing the same issues with a brand new
> filesystem mounted through NFS. The way to reproduce is the same though:
> using g_mass_storage with either tmpfs or mmc as backing store.
>=20
> However it seems to die much more frequently than before. I can
> reproduce all the time. It's definitely not a problem with my board as I
> have two boards with different SoCs (ARM Cortex A8 and ARM Cortex A9)
> with two different USB peripheral controllers (MUSB and DWC3), using the
> same rootfs and they die the exact same way no matter if I use tmpfs or
> MMC as backing store.
>=20
> Adding a few more folks here.

alright, first stable kernel with Cortex A8 was v3.14. All other kernel
versions die starting with v3.15 to today's Linus. I'll start bisecting
now.

--=20
balbi

--uJWb33pM2TcUAXIl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUNXrzAAoJEIaOsuA1yqREOkYP/AuR6AoRoh/VdJF/6ncj3oBr
zTf5FYO584AsSD5AZU2Rz01nhHc8J8aIZ0nMKWWT7C8DMtr57zi6SwPVzmT5vCwx
voq7+HCUc6skYejKZKCqxvgi25ti09C/X1A+GKC1U3z17aK4rW3f0o084xBuBnOk
eszkgpuawreGNMNwe6tGfvUGhL3pEeIwkg50lmetl6Y9Q9joY9l2K0Wdjd0Aa/zO
MCF2bgj1CZpPZyeM4YYWhRS2eB8iiXw74l/ArRN7EYMR5j1RHgNDJ6NXN1w1BFMg
7MG59G/fcmJNX9KfynSrZv3UsY4A5qAovP4RU5lXlg6lOSDaBnCjezM0eN06HRj0
2k2C2c0xp6x/Mprlidw9Qlpp0owGNU7cWsamU0OS4up1PH34Ac6DhtO1Hr28aVRo
6phanB9UgqL+l1Mlwwq3e1aTzcoc7ZlYEVmGZ3VAGoTHj/ptqUKn5/YKs3YmgLQl
/SL5f48mmtMWi1rIqRYIgSCoOl0aFLEXWgtFCnJPHkwPjzIP7FyJxWV6j0adPymg
qydTllUvc/M3MkGeI6KB5sabS326g6nue80ivMpl+fmY6t5IMNNRpLkXCrh/iddX
N/19xG6is/QZhkjJhTGTmrEq1GP/RK0vOk/qZ2S9T1wgnMskzLAKSFxW7yzROFab
JWFFl8oNZ1Fr87eIrufW
=ImYZ
-----END PGP SIGNATURE-----

--uJWb33pM2TcUAXIl--
