Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbaIVRHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:07:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:41634 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419AbaIVRHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:07:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,572,1406617200"; 
   d="asc'?scan'208";a="606670077"
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] Silence even more W=2 warnings
Thread-Topic: [PATCH 0/7] Silence even more W=2 warnings
Thread-Index: AQHP1B6ZqT8VjyQkzkipcFe03W/rTpwNwlkAgAAZ2AA=
Date: Mon, 22 Sep 2014 17:06:27 +0000
Message-ID: <AEF1C0F7-239C-436B-97A5-6AFF49FD9359@intel.com>
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <20140922153355.GB4510@pd.tnic>
In-Reply-To: <20140922153355.GB4510@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [134.134.176.145]
Content-Type: multipart/signed;
	boundary="Apple-Mail=_34064EFF-5F2E-4C73-B53B-680890049B30";
	protocol="application/pgp-signature"; micalg=pgp-sha1
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail=_34064EFF-5F2E-4C73-B53B-680890049B30
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 22, 2014, at 8:33 AM, Borislav Petkov <bp@alien8.de> wrote:

> On Fri, Sep 19, 2014 at 08:29:33AM -0700, Jeff Kirsher wrote:
>> The following patches silence over 100,000 warnings in a W=3D2
>> kernel build. This series does most of it by using the compilers
>> diagnostic controls. The first patch in the series adds macros to
>> invoke the pragmas for those controls. Macros are provided for GCC
>> and clang. Although they are highly compatible in this area, macros
>> are provided for compiler-specific controls, and there is one
>> example that uses a clang-specific control (look for =
DIAG_CLANG_IGNORE).
>>=20
>> Some missing-field-initializers warnings were resolved using
>> the diagnostic control macros simply because so many lines
>> would have had to have been changed. At this stage Mark thought=20
>> about avoiding possible merge issues. If the maintainer would=20
>> rather resolve them by using designated initialization, just=20
>> say so.
>>=20
>> The combined effect of this patch series and his other patches
>> that did not use these diagnostic control macros was to reduce=20
>> the number of W=3D2 warnings from 127,164 to 1,345!
>=20
> Sorry but I don't see the point of actively adding macros to the code
> just so that gcc is happy. There's a reason why a bunch of warnings =
are
> disabled in the normal build and only enabled with the W=3D switch.
>=20
> The W=3D things are supposed to be used when developing code and have =
the
> compiler tell you about *possible* issues. That doesn't mean though =
that
> we have to actively "fix" otherwise perfectly fine code.

The problem is that the kernel include files throw so many warnings that =
it really discourages anyone from ever going through them, even for a =
single driver. The warnings are far more valuable and usable when known =
acceptable usages are silenced.

> Having the need to actively go in and add code so that gcc doesn't =
issue
> obscure warnings is going too far, IMO.

Well, the whole series of patches that I made definitely went too far - =
only the first 5 out of about 30 have been posted, but if we can make =
some progress on generating fewer warnings out of the include files, I =
think it would be helpful. Already the patches that use them have =
triggered some activity that has resulted in resolving warnings without =
use of the macros, and I see that as much better than simply using the =
macros.

The macros can serve a useful purpose, but they should not be widely =
used. When to use them is definitely a judgement call. If the macros are =
accepted, it may be worth adding a checkpatch.pl warning for adding a =
DIAG_*IGNORE macro.

--=20
Mark Rustad, Networking Division, Intel Corporation


--Apple-Mail=_34064EFF-5F2E-4C73-B53B-680890049B30
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJUIFcTAAoJEDwO/+eO4+5uFTUQAIY1lqS7YPj8vUH0olVYqFis
QwpBEQvv62uGXqVt5fu/hjckvI68sN3CpYhiUmoapCACbQsh1uwuVBgAL0FX0jRb
jALCquPt5mqCPsjARCiS2hwVKMHdz2Je4rpgB231CeCxgko8pGcSXz3vrTLrJpRT
lpVdMjGfqrh0cHLIE5mDtyWJOL6LX6FvqT9/FE9zrnHyYcU9DVNxGNZJZ9Pi0L9S
oeJXuQAUbs2quNolF7kJb3BxakIrKdCSbKFEOTcUgDI7cWZ7sDkqffpjhHAXMqGZ
+PVgrKBK49ZZ05EJnTpYWtLjHqSz3Kf9U749Ofmg9fnWZCfADpJyCGpFUS8fDxaP
jmn6yzPCPf3JHHoYMhu6GV3teQP3NTYFl9pn89NE5IP1xFyIdLmqnun0H3H1Cc/p
98R2Qa+xjy6vOcq1yxva4xGju8sN70UEdqZlprFonkPd+dDidYKJsjQ62lpdSE/E
7OFLvJtEKYFhf5DquVp7NLB+zRa2xoOiPjV6KnncPi985yAIQC+YuqbPu3427ESg
FI5h8M4vq5CJqh043WgX4z+97SvC3AJDgcuXesFWFoRR/mdABsQ7qe/Af1wBMvha
3zY3+d9dgvTyWbpbHBKWm6Tp/VPJyyJgknlRcP4JoknHThDz5MA6tua08f9w6r/7
78NQyva9rjpvYLwgNoxV
=bBeg
-----END PGP SIGNATURE-----

--Apple-Mail=_34064EFF-5F2E-4C73-B53B-680890049B30--
