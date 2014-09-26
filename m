Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbaIZThl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 15:37:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:45323 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbaIZThh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 15:37:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,605,1406617200"; 
   d="asc'?scan'208";a="579657474"
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] Silence even more W=2 warnings
Thread-Topic: [PATCH 0/7] Silence even more W=2 warnings
Thread-Index: AQHP1B6ZqT8VjyQkzkipcFe03W/rTpwNwlkAgAAZ2ACAABpfgIAABS8AgAAGSQCAAAZEgIAAA7mAgAADVoCAAAa4AIAADXwAgAPS5oCAAlk2AA==
Date: Fri, 26 Sep 2014 19:37:19 +0000
Message-ID: <4C887554-FB5F-4634-ABE6-20F41583ABA2@intel.com>
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <20140922153355.GB4510@pd.tnic>
 <AEF1C0F7-239C-436B-97A5-6AFF49FD9359@intel.com>
 <20140922184049.GB4709@pd.tnic>
 <3199350A-89CE-4BE7-8FE4-CA8CE4F87622@intel.com>
 <20140922192152.GD4709@pd.tnic>
 <1411415057.2513.8.camel@jtkirshe-mobl.jf.intel.com>
 <20140922195737.GE4709@pd.tnic>
 <1411416573.2513.19.camel@jtkirshe-mobl.jf.intel.com>
 <20140922203336.GF4709@pd.tnic>
 <1411420912.2513.32.camel@jtkirshe-mobl.jf.intel.com>
 <CAMuHMdU7VO01_qRGc0TV2K+nJJCu4sm0zbH773_zBWdaxSR1aQ@mail.gmail.com>
In-Reply-To: <CAMuHMdU7VO01_qRGc0TV2K+nJJCu4sm0zbH773_zBWdaxSR1aQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [134.134.176.66]
Content-Type: multipart/signed;
	boundary="Apple-Mail=_11F927C8-ABB4-4835-BC68-6D8CAF34F31A";
	protocol="application/pgp-signature"; micalg=pgp-sha1
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail=_11F927C8-ABB4-4835-BC68-6D8CAF34F31A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 25, 2014, at 12:45 AM, Geert Uytterhoeven <geert@linux-m68k.org> =
wrote:

> Instead of grepping, you can feed the build log to linux-log-summary.
> Or when changing a driver, feed the before and after build logs to
> linux-log-diff. That way you won't miss the single new warning you've
> just introduced.
>=20
> https://github.com/geertu/linux-scripts

Thanks for making me aware of these tools. linux-log-summary does reduce =
the totally insane 125,000 warnings to the merely unreasonable 10,000 or =
so. I'm not being sarcastic, they *are* very nice tools that I will use. =
Thank you for pointing me to them.

I still observe that thousands of those unique warnings are emitted by =
the syscall table and its override initializations. I still think they =
should be silenced because they serve no purpose in that particular =
case. That is, the warning is complaining about what it is designed to =
complain about, but in this particular instance, the code is written as =
it needs to be, so why not acknowledge and capture that exception in the =
source?

A couple thousand more come from every use of compiletime_assert, for =
which I do not have a solution yet. Even my macros don't help with that =
one.

Most of the others come from null-entry table initializations, i.e. { 0 =
}, which give missing field initializer warnings. I'd like to define a =
macro something like:

#define ZERO_ENTRY DIAG_PUSH DIAG_IGNORE(missing-field-initializers) \
	{ 0 } DIAG_POP

Then simply using ZERO_ENTRY, a zero entry could be provided without a =
complaint from the compiler. But of course that can't be done if the =
DIAG_* macros aren't there. It also would keep the DIAG_* macros out of =
the .c files and just in the header where ZERO_ENTRY is defined.

--=20
Mark Rustad, Networking Division, Intel Corporation


--Apple-Mail=_11F927C8-ABB4-4835-BC68-6D8CAF34F31A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJUJcBuAAoJEDwO/+eO4+5uNxEQAJ11N/SfFGELFDL0RMgSR1+P
C3tJH5tGK5sEx0eBJNeDCnlNUxrY9y/8fkR/URDIinMVv09i+0N/sH8eclDkgVk/
L8YYu9KxJdIqH7RSgfbwgGpYpRdaZJte1qqwlzTHru5dDXPYtVXKVgwdOs5k9eIT
c9/KViuskr553MikSSDEJC26J5n5z583rZ6ZXK6pc3RWR8ZymTCnfF6sqVMLTH8t
qcBWQqXY5bqXoCma9gFQkLG/KPOIpV+ONSkl0g7rGkeRdoBP+DQUXvT9NkdN/uwI
hmd8PL7gKaVvVViftihMEgI3kPnM6G+nk5PsWUzXK2eKjL8n5QNaq+VmUsyrJ7dc
Qemux10bEB0Ew7FRsyf8b3zkLKj9D5iePPd7nLSfxa4sdIPDFDK+s7030XhU/QYD
ANhuGTR9xaUraaz+W0j0fzt/i75g74C1HqKLfAqBobyKQ3XjprISPf7T25ypch8g
EZs2/LqROUWOuxghGEH1eEf0xcmnFd1WC0omtbDl97nkWfT0knA/eob8M01n5tYg
KBG5wIdkwEk9agsfUITvFdwohnpz//cIyuE7C79JNhDBpVAF5iijo/CDotXwt+4+
qnOJg6SqxPEbaM2hgPfwG7F7D1HJJhEyGONg7kD09xOMsGf4/1YTlqIl9COZtS8x
MNF1qYP4skIVNZM/EFQU
=zXpw
-----END PGP SIGNATURE-----

--Apple-Mail=_11F927C8-ABB4-4835-BC68-6D8CAF34F31A--
