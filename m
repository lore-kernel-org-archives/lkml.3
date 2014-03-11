Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbaCKXzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 19:55:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46363 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535AbaCKXzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 19:55:21 -0400
Date: Tue, 11 Mar 2014 23:55:13 +0000
From: Mark Brown <broonie@kernel.org>
To: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20140311235513.57aadc3a23f88c64cdc92555@kernel.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__11_Mar_2014_23_55_13_+0000_._QCQNGxY1k6L4pG"
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@kernel.org
Subject: linux-next: build failure after merge of the kvm tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Mar_2014_23_55_13_+0000_._QCQNGxY1k6L4pG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm tree, today's linux-next build (20140311)
failed like this:

/home/broonie/next/next/arch/x86/kvm/vmx.c: In function 'nested_vmx_setup_c=
tls_msrs':
/home/broonie/next/next/arch/x86/kvm/vmx.c:2292:2: error: implicit declarat=
ion of function 'vmx_mpx_supported' [-Werror=3Dimplicit-function-declaratio=
n]
  if (vmx_mpx_supported())
  ^
/home/broonie/next/next/arch/x86/kvm/vmx.c: At top level:
/home/broonie/next/next/arch/x86/kvm/vmx.c:7036:13: error: conflicting type=
s for 'vmx_mpx_supported'
 static bool vmx_mpx_supported(void)
             ^
/home/broonie/next/next/arch/x86/kvm/vmx.c:2292:6: note: previous implicit =
declaration of 'vmx_mpx_supported' was here
  if (vmx_mpx_supported())
      ^
cc1: some warnings being treated as errors
make[3]: *** [arch/x86/kvm/vmx.o] Error 1

I have used the version from next-20140307 instead.

--Signature=_Tue__11_Mar_2014_23_55_13_+0000_._QCQNGxY1k6L4pG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTH6JhAAoJELSic+t+oim9c78P+gNakwSWK38ZftdfQThsOlmZ
GhR1i+o5XwnW0/S0pTReAdCEU8azer1n9/lQrLthf0GegJ+7gbAtZMmsCgHJItSQ
Pq12R3QgIJ49w0FLgwCnNQV447/0IpoGW8UkkRNIo2VugJihaMV9/8H9rj/mYT44
Zm+tdDotbW8mg3LHu+/cHAIVYgLXFOkmJbyfH3XT37JoXMByySdGAH3WX/AjAXuX
ZqNWphk7F/PTsbbrJnutj5eqX6qLrG1Oaq8zmHyJOElzgykZb/nisUiG1ysFIgGY
ts2kdncoUmLuKp2/cAEVas4AUeOKED4pi45YiTLe7I1OKMSsZEqGDT02zOZ3Kjoa
nxSQULezKXFZfwdJcb0uV94SkeOjcFVuC8bgFbp5v7EyU8fYIbNS4IT7uOHqFWUw
9ph9hvP+daICMxO5jRC6H01r3lka7ICh8Svuws7tIvV63n58Az8T9btJIquVtS2E
EXrJ8cYSVExR9ty91CnTy5SNwsOxLiBJc5vqc2L4Y5dl/AQXV3Kc3LtdpN4HnKYX
jAGgQl1dGHvwvv5A71/NsuklYI7eIrYksiyLf+bTctMDD9cHyhGWYfffbWlNBXNv
ADoG81Q/xKwEZ5ANCpiFrxpb3u5VV/jbcrbiFUd6GRnqnDLlHFJ5dyTBd0979T6k
Z21EuEifGbqTYeRwvnH9
=cGAM
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Mar_2014_23_55_13_+0000_._QCQNGxY1k6L4pG--
