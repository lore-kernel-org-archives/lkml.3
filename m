Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759970AbaEMJ2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:28:07 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53095 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759378AbaEMJ2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:05 -0400
Date: Tue, 13 May 2014 11:27:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, linux-kernel@vger.kernel.org, eranian@google.com,
        namhyung@kernel.org, jolsa@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, tools: Support spark lines in perf stat v2
Message-ID: <20140513092748.GT30445@twins.programming.kicks-ass.net>
References: <1399935686-26940-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M0++IvaR8xIqBMhe"
Content-Disposition: inline
In-Reply-To: <1399935686-26940-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M0++IvaR8xIqBMhe
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 12, 2014 at 04:01:26PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>=20
> perf stat -rX prints the stddev for multiple measurements.
> Just looking at the stddev for judging the quality of the data
> is a bit dangerous The simplest sanity check is to just look
> at a simple plot. This patchs add a sparkline to the end
> of the measurements to make it simple to judge the data.
>=20
> The sparkline only uses UTF-8, so should be readable
> in all modern tools and terminals.
>=20
> The sparkline is between the minimum and maximum of the data,
> so it's mainly a indicator of variance. To keep the code
> simple and make the output not too wide only the first
> 8 values are printed. If more values are there it adds '..'
>=20
> The code is inspired by Zach Holman's spark shell script.
>=20
> Example output (view in non-proportial font):
>=20
>  Performance counter stats for 'true' (10 runs):
>=20
>           0.175672      task-clock (msec)         #    0.555 CPUs utilize=
d            ( +-  1.77% ) =E2=96=88=E2=96=84=E2=96=81=E2=96=81=E2=96=81=E2=
=96=81=E2=96=81=E2=96=81..
>                  0      context-switches          #    0.000 K/sec
>                  0      cpu-migrations            #    0.000 K/sec
>                114      page-faults               #    0.647 M/sec       =
             ( +-  0.14% ) =E2=96=81=E2=96=88=E2=96=81=E2=96=81=E2=96=88=E2=
=96=88=E2=96=88=E2=96=88..
>            520,798      cycles                    #    2.965 GHz         =
             ( +-  1.75% ) =E2=96=88=E2=96=84=E2=96=81=E2=96=81=E2=96=81=E2=
=96=81=E2=96=81=E2=96=81..
>            433,525      instructions              #    0.83  insns per cy=
cle          ( +-  0.28% ) =E2=96=85=E2=96=87=E2=96=85=E2=96=84=E2=96=87=E2=
=96=88=E2=96=81=E2=96=86..
>             83,012      branches                  #  472.537 M/sec       =
             ( +-  0.31% ) =E2=96=85=E2=96=87=E2=96=86=E2=96=84=E2=96=87=E2=
=96=88=E2=96=81=E2=96=86..
>              3,157      branch-misses             #    3.80% of all branc=
hes          ( +-  2.55% ) =E2=96=87=E2=96=88=E2=96=83=E2=96=85=E2=96=81=E2=
=96=83=E2=96=81=E2=96=82..
>=20
>        0.000316660 seconds time elapsed                                  =
        ( +-  1.78% ) =E2=96=88=E2=96=85=E2=96=81=E2=96=81=E2=96=81=E2=96=
=81=E2=96=81=E2=96=81..
>=20
> As you can see even in the most simple run there are quite interesting
> patterns. The time sparkline suggests it would be also useful to have an =
option
> to throw the first measurement away.

Hmm, my first looking at the spark thingies interpreted them as a
histogram. But they're not really.

Would it be possible to make it a histogram of -2sigma,2sigma around the
avg value? That way you can plot all data and get a good idea of the
distribution. I'd suggest using 9 buckets for it.

--M0++IvaR8xIqBMhe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTceWOAAoJEHZH4aRLwOS6iaAQAKYpp9xJtPFN0wofEDc72HiY
SEgmwSB21qi03Jyz6G4HWMeOr/6Ocbk4XLV8qNFb7ZFpJ/7WoRkmxTVdevLhYB7s
ZSxqBx37HZdCvcELvhn9ZwNuKd+kbrHRQ3oBajellvhzVrwIAyohL8wkftZIvv5P
Qvrr2P06GFe/f9NDVXnEw1K7DpdGBTIS6jBPHjc7/RwtatWmnuguX+x7/zwQOnZj
1kSVVAhvmdKqDNpzMn2Mhs7C/F6oahmy/IWGFvsqpKryaExzmF/UzRBHnFqEsX6J
nfzseGfUicAjHtKMzkKC+dMRjXJoZZZSWECaTORC9jJ+OYij03jloVGRcYeOZ/lf
Q53RbRhOuzMXIhz/uj9+732moQaBHJX1+/UMiHNBwftmuSB9dmfjG3a/BZh85gTz
8W68KWduu0RoWNt7seOiG1dga3jyC89J3f/Gf4MesiX4F3yucWlt/mI2bE/ZbvCr
+De3dJ/+MVpCWM0PKAY+4xHe0aYzNM+BYuBJ9Icb1GKJV0qQpj0ozzIwcm5Lz4d4
dOgLP9meZyw0fU9NGZEclvpQY3ixoWGYR/GlUvHzZBCiolUBszo3Wx6g2fvIJAvi
+1lLc6RM1o3KrzTc3NS9ODxeqCBaLmB5dcoE2HlciAHinzH/DBffQzIkSXQj48bt
cHz5mqmItW2xS00+TzGn
=ta2Q
-----END PGP SIGNATURE-----

--M0++IvaR8xIqBMhe--
