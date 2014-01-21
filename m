Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbaAUKgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 05:36:33 -0500
Received: from multi.imgtec.com ([194.200.65.239]:30793 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091AbaAUKgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 05:36:31 -0500
Message-ID: <52DE4DA3.7090301@imgtec.com>
Date: Tue, 21 Jan 2014 10:36:19 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Chen Gang <gang.chen.5i5j@gmail.com>, <devel@driverdev.osuosl.org>,
        <andreas.dilger@intel.com>, Greg KH <gregkh@linuxfoundation.org>,
        <bergwolf@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <oleg.drokin@intel.com>, <jacques-charles.lafoucriere@cea.fr>,
        <jinshan.xiong@intel.com>, <linux-metag@vger.kernel.org>
Subject: Re: [PATCH] drivers: staging: lustre: lustre: include: add "__attribute__((packed))"
 for the related union
References: <52DA4E6A.1000308@gmail.com> <20140118100547.GS7444@mwanda> <52DA56C2.5010802@gmail.com> <20140118142404.GT7444@mwanda> <52DBA3D4.3090308@gmail.com> <52DD0EFF.2010305@imgtec.com> <20140120123045.GV7444@mwanda> <52DD18A5.1090308@imgtec.com> <20140120125603.GD4815@mwanda> <20140120211356.GG4815@mwanda>
In-Reply-To: <20140120211356.GG4815@mwanda>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="FU3XnrEtioXfThSukdsKvdelQ5i32u6un"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2014_01_21_10_36_26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--FU3XnrEtioXfThSukdsKvdelQ5i32u6un
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Dan,

On 20/01/14 21:13, Dan Carpenter wrote:
> I made a quick and dirty sparse patch to check for this.  I don't think=

> I will bother trying to send it to sparse upstream, but you can if you
> want to.
>=20
> It found 289 unions which might need a __packed added.  The lustre
> unions were not in my allmodconfig so they're not listed.

Thanks a lot for this, it seems to be useful. I'm adapting it to reduce
false negatives (e.g. omitting the check if the struct/union is already
packed), and I imagine it could be made to only warn about padded
unpacked structs/unions which are used as nested members of packed
structs/unions. It wouldn't catch everything but would probably catch a
lot of cases that are most likely to be genuine since they would have
been packed at the outer level for a reason.

> Perhaps there could be a command line option or a pragma so that unions=

> will work in the kernel.  We don't care about linking to outside
> libraries.

We still interact with userland via structs and unions, so it would
probably have to exclude anything in uapi/.

Cheers
James


--FU3XnrEtioXfThSukdsKvdelQ5i32u6un
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJS3k2pAAoJEKHZs+irPybfPJkP/Rz2wG7DQZiN5MIMRGYxOzMr
H4s6CrJ8H5BKtOWdmRsDtLbuHVtzotxecYS2hpxPsiPKYdwxhQM7s9nEV1p0mdk7
dFgs/e7zZslWtZ2Hmn8kErXWfGBXkk7sRBH7A5L0laaJA6jqdsnIzP+aXhwVm29r
HVR79LBRpY3o8ygEaNmDvbkJBJfGhhBlQOdsvx96mb89a4r2xnfpcPvWEz8bJ0NG
fdHw01pXeIfTs/7cWFqO77qAJAFXn7cbOkvGLem0elS4syNQd0hj09t+8nX9KPCV
mhpmgAeE9wam8eyAqAqSixFik1+48q5u8bnGt/oZHYGIyxJWnKnbueTirslnZ1z9
qJQgw+QoLqEv7gS/RLsEW+4sn8k98ITSiSkolEwPI6dhuIiUVrQXmmc9/o+wi27P
QF2QftBtGbeK1K+GN+4ua/Yfnh4Gx+WS5RbhnoSmZmRYxmnTYFHgCbDGcEOT0snp
+cdDUPHt0pxWEVoDyxgNd2l5Dx9t44mFhqTOS/BMjcbAruKZfvBt9OmTtJlvIefP
FVlbD65Yy2tFAXbdkKbcwKIw2vutLPEfmVV+zxx/oaQmQvSGhGP20+ALS+vsusAB
rMdfZt0dzTpkoJIsddrduS3wKE3i4b9HyriDUJ8Bl8D/RR4r6R7+Mna8riO6GJVV
vCi8jprxvhomCTMTO4Oa
=Mti+
-----END PGP SIGNATURE-----

--FU3XnrEtioXfThSukdsKvdelQ5i32u6un--

