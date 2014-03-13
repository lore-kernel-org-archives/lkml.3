Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbaCMHqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 03:46:25 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:50579 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaCMHqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 03:46:24 -0400
Date: Thu, 13 Mar 2014 15:46:13 +0800
From: Kevin Hao <haokexin@gmail.com>
To: Scott Wood <scottwood@freescale.com>
Cc: Chenhui Zhao <chenhui.zhao@freescale.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, leoli@freescale.com,
        Jason.Jin@freescale.com
Subject: Re: [PATCH 9/9] powerpc/pm: support deep sleep feature on T1040
Message-ID: <20140313074613.GD26692@pek-khao-d1.corp.ad.wrs.com>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
 <1394168285-32275-9-git-send-email-chenhui.zhao@freescale.com>
 <1394586624.13761.132.camel@snotra.buserror.net>
 <20140312055755.GA17203@pek-khao-d1.corp.ad.wrs.com>
 <1394646185.13761.145.camel@snotra.buserror.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cQXOx3fnlpmgJsTP"
Content-Disposition: inline
In-Reply-To: <1394646185.13761.145.camel@snotra.buserror.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cQXOx3fnlpmgJsTP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 12, 2014 at 12:43:05PM -0500, Scott Wood wrote:
> > Shouldn't we use "readback, sync" here? The following is quoted form t4=
240RM:
> >   To guarantee that the results of any sequence of writes to configurat=
ion
> >   registers are in effect, the final configuration register write shoul=
d be
> >   immediately followed by a read of the same register, and that should =
be
> >   followed by a SYNC instruction. Then accesses can safely be made to m=
emory
> >   regions affected by the configuration register write.
>=20
> I agree that the sync before the readback is probably not necessary,
> since transactions to the same address should already be ordered.
>=20
> A sync after the readback helps if you're trying to order the readback
> with subsequent memory accesses, though in that case wouldn't a sync
> alone (no readback) be adequate?

No, we don't just want to order the subsequent memory access here.
The 'write, readback, sync' is the required sequence if we want to make
sure that the writing to CCSR register does really take effect.

>  Though maybe not always -- see the
> comment near the end of fsl_elbc_write_buf() in
> drivers/mtd/nand_fsl_elbc.c.  I guess the readback does more than just
> make sure the device has seen the write, ensuring that the device has
> finished the transaction to the point of acting on another one.

Agree.

>=20
> The data dependency plus isync sequence, which is done by the normal I/O
> accessors used from C code, orders the readback versus all future
> instructions (not just I/O).  The delay loop is not I/O.

According to the PowerISA, the sequence 'load, date dependency, isync' only
order the load accesses. So if we want to order all the storage access as w=
ell
as execution synchronization, we should choose sync here.

Thanks,
Kevin

--cQXOx3fnlpmgJsTP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAEBAgAGBQJTIWJFAAoJEJNY7TDerrFxnSEH/0paHHq8090PGw8y7vRdA/ji
FYQhy9BalQVsYBSW96ZRzixEmEPaQ4f0PJiENH36ni4iTCk8gFUNT47wGiBOOxLg
IztuXIhyJlK93gIZEW63SKrbPvOs8M56ACxAtG5UKV9qBPeYX6e+o5C4xmlhXAOr
6V2CJQ5WaeeZZArGgGvSmR+fLQkMCEcLbnIjEMpUfO2rUt1eo2+Fd4sB+sZJpLQt
uM9NYLQ+zgixtADrjq1JPTU+LPpTdrU6Ody+WbqzPWTtnL0YZvN8+SPViteatYDY
tMxiZUbadOgqgrd4xJbtMcMDqQ8eAB9RvNJoHY//HwvadV73Gw5ceKJTTN1GP58=
=1D0C
-----END PGP SIGNATURE-----

--cQXOx3fnlpmgJsTP--
