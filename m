Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249Ab3BGLkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 06:40:49 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37062 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757874Ab3BGLkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 06:40:46 -0500
Message-ID: <511392B0.4040409@ti.com>
Date: Thu, 7 Feb 2013 13:40:32 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Rob Clark <robdclark@gmail.com>
CC: <linux-arm-kernel@lists.infradead.org>, <patches@linaro.org>,
        <linux-kernel@vger.kernel.org>, <arm@kernel.org>,
        Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] OMAPDSS: enable omapdss for ARCH_MULTIPLATFORM
References: <1358891160-9534-1-git-send-email-robdclark@gmail.com> <201302051631.40254.arnd@arndb.de> <5112659D.50808@ti.com> <3969096.QosOfOb9QT@wuerfel>
In-Reply-To: <3969096.QosOfOb9QT@wuerfel>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigFD72BD47E733E0266FB97E50"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enigFD72BD47E733E0266FB97E50
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-02-06 16:29, Arnd Bergmann wrote:
> On Wednesday 06 February 2013 16:15:57 Tomi Valkeinen wrote:

>> I have patches to add the ARCH_MULTIPLATFORM for omapdss, and to fix t=
he
>> omap_vout and omapdrm Kconfig files. Each of them changes only one lin=
e.
>> Arnd, are you ok with queuing those patches via arm-soc/fixes? Or shou=
ld
>> I send them individually to respective maintainers?
>>
>> I can send the patches properly for review, but I've also attached the=
m
>> here so Rob can test.
>=20
> The second and third attachment in your mail seem to contain identical
> patches. I suggested a similar patch myself, but Rob thought his

Hmm? They look different to me...
0002-omap_vout-fix-the-dependency-on-OMAPDSS.patch fixes the dependency
for omap_vout, 0003-omapdrm-fix-the-dependency-on-OMAPDSS.patch for omapd=
rm.

> version was nicer to give better build coverage. We only need either
> Rob's patch or yours, but not both, as far as I can tell.

I read the related posts, but I'm a bit confused here. Let me summarize
what has happened and what are the issues:

I changed omapdss, omapfb and omap panel drivers to be platform
independent, and after that they compiled fine on OMAP and x86, and
should compile fine on any other platform as well. I thus removed the
Kconfig build dependencies for OMAP. This is what I sent for 3.8 merge
window.

However, Linus complained that now he's getting asked if he wants to
enable omapdss driver when he's building x86 kernel. So Tony made a
patch that added the ARCH_OMAP2PLUS dependency to omapdss (and some
other omap drivers), which went in.

Now, if I'm not mistaken, Rob then added possibility to build omapdrm on
ARCH_MULTIPLATFORM. No problem with that as such, but omapdrm's Kconfig
uses select to enable omapdss, which does not work. omapdss was not made
to work with others using "select" to enable it, but one should "depend
on" to it.

This caused omapdss to be enabled partially when omapdrm is enabled on
ARCH_MULTIPLATFORM, causing build failure.

So the real fix to the issue is the 0003 patch, which changes omapdrm to
use "depend on", not "select". However, adding only that patch will
prevent omapdrm to be built on ARCH_MULTIPLATFORM, as omapdss is not
enabled on ARCH_MULTIPLATFORM. That one can be enabled with the 0001 patc=
h.

Adding only 0001 patch will also "fix" the build issue, as then omapdss
is properly enabled on allyesconfig ARCH_MULTIPLATFORM build, even if
omapdrm erroneously uses select to enable omapdss. However, adding only
0001 will still allow the user to manually break the build by disabling
omapdss (I think, I didn't test that).

The difference between my 0001 patch and Rob's patch is that Rob only
enables omapdss to be built on ARCH_MULTIPLATFORM, leaving omapfb and
omap panel drivers out. Leaving omapfb is not an issue, but if the panel
drivers are left out, I don't see how omapdrm can function properly,
even if compilation works fine.

> Olof can correct me, but I think we currently don't have any other
> patches queued in arm-soc for 3.8 (after Linus announced he did
> not want any of the less urgent ones), so I think it would be more
> fitting if you send one of the patches to Linus, rather than having
> an arm-soc pull request that only contains one patch in your domain.

Ok, I'll do that. I'm still not sure if I should send only the 0001
patch, or all three. I guess I'll go for all three if nobody objects.

Rob, can you test the patches so we're sure they do what they are
supposed to?

 Tomi



--------------enigFD72BD47E733E0266FB97E50
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRE5KwAAoJEPo9qoy8lh713I8QAKtNdVZIpAaJoRwtvtBru32y
nvAvcu/aF3hj7PyHyTtJtzPq+Zo81wX7ZU1hj7/WzxiHBlxfUi1cQnL/GIl93FDX
uhflNw9ivon9rai/EJ1SViq519D4gKk1nLdyth9a2cCDU6mJVl9leLgtUM0huN6T
HkxDdCMwWJaHi0p8h1A7+DWOGac7mz7Y5wQrFwQFP8Ju9DlQKLo67+vKuOnllY+c
F0BVjSkVwuGBvq1cvSFGpdZ+HX6PYFPA188uL3wZTlylyXKBDWut67sJ4thLWjkL
tSC789jhZyOnWj+lLq8xOIfdl6587l86X0qkW1Kv6y7ZgK3iT6NXGf9+BEQI5Msm
DzTadJpNGmTLGaLv9IG71VWfkzB2gwS0eZ/O7MW7udbm8XaYDDS+ooivpSdsOrKo
TUB7lpVNiODkEcJfTymSububipxOFTnPovYSbwOCbmSJ1BTD+OADMG2n9LFVAbJZ
1tFF+Q3ku3V9CXFC7+iX79498DCBJHLuWPKqJ8xP8mfcUPtTagnf4rlVCsnWIuyw
Q6xIs1HNj/qTJUdPKX5hNJSuClkcQ+UGf2RoU1+LqS72yQC0hVBVhSct2lJuY3tl
qFizy/S5NgDc9Betedg7ZY1e08BKQSwU5WiAkyGdPnyz2mB7hyCZjf9yioTjCNLp
LjbY2v6mkI0Zsk4AhfqK
=lK28
-----END PGP SIGNATURE-----

--------------enigFD72BD47E733E0266FB97E50--
