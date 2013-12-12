Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab3LLPOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 10:14:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452Ab3LLPO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 10:14:29 -0500
Date: Thu, 12 Dec 2013 09:14:22 -0600
From: Clark Williams <williams@redhat.com>
To: Ciprian Barbu <ciprian.barbu@linaro.org>
Cc: RT <linux-rt-users@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Linaro Networking <linaro-networking@linaro.org>
Subject: Re: [PATCH] rt-tests: hackbench: fix for uninitialized start time
Message-ID: <20131212091422.3b909d99@sluggy>
In-Reply-To: <52A9CC77.20904@linaro.org>
References: <52A9CC77.20904@linaro.org>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/gkPuJVomdyUk_aqQsKsKgqF"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/gkPuJVomdyUk_aqQsKsKgqF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Dec 2013 16:47:19 +0200
Ciprian Barbu <ciprian.barbu@linaro.org> wrote:

> Hello,
>=20
> While playing around with hackbench I discovered that I would sometimes=20
> get an enormous time reported, even if the run time would be less than a=
=20
> second or so. The problem was that the struct timeval start was not=20
> initialized until after all children have been created. But if the=20
> program receives a signal before this is done, the start time is left=20
> uninitialized.
>=20
> I propose that in such situations an error message be displayed, like=20
> the following patch does.
>=20
> Please let me know if this is acceptable.
>=20
> Regards,
> /Ciprian

Looks good to me. I've pulled it in for the next release.

Clark

--Sig_/gkPuJVomdyUk_aqQsKsKgqF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlKp0s4ACgkQHyuj/+TTEp1YWwCgx4Mc0kMgY4KfKEPsAQhcGT8+
zJAAoMGiTCqYLYWm8cV+qg/D3aEaVONx
=ED79
-----END PGP SIGNATURE-----

--Sig_/gkPuJVomdyUk_aqQsKsKgqF--
