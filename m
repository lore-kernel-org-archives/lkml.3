Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbaE2F7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:59:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41565 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbaE2F7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 01:59:36 -0400
Date: Thu, 29 May 2014 15:59:23 +1000
From: NeilBrown <neilb@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.14 000/140] 3.14.5-stable review
Message-ID: <20140529155923.61a11b69@notabene.brown>
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_IIE3Hid42T_Jqshez5dd/_"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_IIE3Hid42T_Jqshez5dd/_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 May 2014 21:32:19 -0700 Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 3.14.5 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sat May 31 04:30:12 UTC 2014.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.5-rc1.gz
> and the diffstat can be found below.
>=20

Hi Greg,
I notice that the patch in commit cc13b1d1500656a2 (see below for comment) =
is
missing. I was hoping it would be in 3.14.5.  Is there a reason I missed ou=
t?

Thanks,
NeilBrown


commit cc13b1d1500656a20e41960668f3392dda9fa6e2
Author: NeilBrown <neilb@suse.de>
Date:   Mon May 5 13:34:37 2014 +1000

    md/raid10: call wait_barrier() for each request submitted.
   =20
    wait_barrier() includes a counter, so we must call it precisely once
    (unless balanced by allow_barrier()) for each request submitted.
   =20
    Since
    commit 20d0189b1012a37d2533a87fb451f7852f2418d1
        block: Introduce new bio_split()
    in 3.14-rc1, we don't call it for the extra requests generated when
    we need to split a bio.
   =20
    When this happens the counter goes negative, any resync/recovery will
    never start, and  "mdadm --stop" will hang.
   =20
    Reported-by: Chris Murphy <lists@colorremedies.com>
    Fixes: 20d0189b1012a37d2533a87fb451f7852f2418d1
    Cc: stable@vger.kernel.org (3.14+)
    Cc: Kent Overstreet <kmo@daterainc.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

--Sig_/_IIE3Hid42T_Jqshez5dd/_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU4bMuznsnt1WYoG5AQLO/A/+IRQdGhh0PnteTCpjmAe3yg10C+AKrK7l
kUWoesfq9qS6LlTqjSNFYpB37eRnkqiX/MTWLTUJH2p05YCnRrOro2fKoNq4BVX7
5OBkKgPowLl+cOuH55rF25s8/idELmLo81nSMgBn+lFRcf+G/aA0rfCGH2/EUctF
qJi6pFaU/C/m1DDzataPQIHFIQnNVZ6yc8ufqnOUDrrEuCegFfkzqOqf+rmiGMcd
znsPkc+HlYfx6w8zJ443wL9rwlkFMpb5WM1gSc5V16gwAHSCCMOSCEZZN6JTvzvn
gYkxUx6oGkp4DcrzurdF25NPEe799ZZhdwk+PqwXsH6rFptBn6MekdcLcVB/phUb
QmBt/DzEGlmXvx8aSjTUQ2cgIKakgO4i2xBpM3lale5fpDkFaRbBX/IFpIIvyd9N
AEPbxeqP9nmeXY3zUlSS+IvfTO33UHT3Ad3x54HYPEDrmcVjoAS7uLvBH8jTxLcm
vHRou/IVZwAAahLWRGn6sIwhmIxGwq5mcWQHIiHk4eKA+c1e/5Tc4Wshz2I7s74N
HKYOcTbJGmqvdGt52HQdwb4UQ1ebWFflZx6Yvda8hxMwgYsLpnepdf99S56HLHwG
pRehInVsWlMYAEzzON3szij84jUNFdaW7pKVUKiNCCrPUbdlIekI+syLtJ1xqYfx
FU5jRkBlvn4=
=+H8g
-----END PGP SIGNATURE-----

--Sig_/_IIE3Hid42T_Jqshez5dd/_--
