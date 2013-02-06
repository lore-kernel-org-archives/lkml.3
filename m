Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab3BFRRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:17:08 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:47090 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab3BFRRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:17:05 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Kent Overstreet <koverstreet@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hillf Danton <dhillf@gmail.com>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org
Subject: Re: next-20130117 - kernel BUG with aio
In-Reply-To: Your message of "Tue, 05 Feb 2013 09:20:15 -0800."
             <20130205172015.GA27179@google.com>
From: Valdis.Kletnieks@vt.edu
References: <3544.1358774694@turing-police.cc.vt.edu> <CAJd=RBBBbv07aoOTF=PNy1FpCyuRV7fnQEGX_DXEYFSSknKtqQ@mail.gmail.com> <2553.1358890098@turing-police.cc.vt.edu> <20130131135952.77cf5d3a.akpm@linux-foundation.org> <20130201003727.GK12631@moria.home.lan> <5602.1360079580@turing-police.cc.vt.edu>
            <20130205172015.GA27179@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1360170941_2167P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 06 Feb 2013 12:15:41 -0500
Message-ID: <3423.1360170941@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020202.51128FCF.003D,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1360170941_2167P
Content-Type: text/plain; charset=us-ascii

On Tue, 05 Feb 2013 09:20:15 -0800, Kent Overstreet said:

> The "smoosh struct kiocb" patch also needs to be dropped. That causes
> aio_rw_vect_retry() to check ki_nbytes/ki_left after they've been
> overwritten by aio_complete(), which causes it to return an error when
> it shouldn't have, which causes aio_run_iocb() to double complete the
> iocb causing put_reqs_available() to be called twice and the count
> screwed up.

Hooray! linux-next-20130206 builds, boots, and VirtualBox 4.2.6 runs
without producing any kernel messages.  Feel free to add the following
as appropriate to this version of the patch series:

Reported-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Tested-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>


--==_Exmh_1360170941_2167P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBURKPvQdmEQWDXROgAQLn9w/9GxWXsoNtdMvUUQIyoWTbhnnrSNmHIMSK
RccRx51AhsVbfuxFx1iDt43PaF90HP7Gdj3av8/RnesPC9Hk0VbipMKVyawThAYP
CY8Nx/wbnvfC5skavgO8XP/fI0ASVp1m90Xurq9wNvWRGaLWoil0sqrhDsmBfEN5
aTDHVcbVE9dwlLHCthfO5H1UNq6U11uaS5zGmvysnWqG64TXY1TYJd/zOuTg/x7v
EQg+aj+FvAEzyNs1AHLzgm6p3WxQ8YZyBfEhq5nYox0EAItD6tFEwlwzKKt/KiOm
OGusMW1hNYlAFV0Z9IHtWFdKpxM0IoNGvtEuA/jxZNAXJR3Qg2BWc/alcduZH7Zb
TeVzhlObGrDtbX/ExyEfeGjzIT3+0m6Xq4F54KvDXKtdQfo/YJzmGU1cYHM98ol4
PixKO05l+LFdSyRKR8Qh84quWYlHfborOcL7MG5HK9SlTl0XPzOXUmh64VErQEHz
YCoqZy62uEuwSQwHx+bUdU3U2oImgfkVkPSkNqyx7viatU4yxLojpb3oAzbdq0do
cWjYRLf1SG9r5ZRS8HjoxTvgU/l/qm2nT+GCp59Og1sDLNdX51jZI4SbXbGD+8wg
1YXtiE6KPxxBeXww87C+FX9bVeB+vJdC9H9ApPsmDkaydK/XUYkOjlJi1q8EUgS7
1BwK8fryVmU=
=do3D
-----END PGP SIGNATURE-----

--==_Exmh_1360170941_2167P--

