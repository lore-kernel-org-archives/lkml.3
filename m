Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbaGaHHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 03:07:41 -0400
Received: from ozlabs.org ([103.22.144.67]:55462 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbaGaHHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 03:07:38 -0400
Date: Thu, 31 Jul 2014 17:07:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        David Riley <davidriley@chromium.org>,
        John Stultz <john.stultz@linaro.org>
Subject: linux-next: manual merge of the driver-core tree with the tip tree
Message-ID: <20140731170735.5cf2062b@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_//ZUfVbT=irnzWLeV+vtEufW"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//ZUfVbT=irnzWLeV+vtEufW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
lib/Kconfig.debug between commit e704f93af5a0 ("kernel: time: Add
udelay_test module to validate udelay") from the tip tree and commit
0a8adf584759 ("test: add firmware_class loader test") from the
driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc lib/Kconfig.debug
index 7cc4e8aff5df,213cd9f7e957..000000000000
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@@ -1659,15 -1649,19 +1659,28 @@@ config TEST_BP
 =20
  	  If unsure, say N.
 =20
+ config TEST_FIRMWARE
+ 	tristate "Test firmware loading via userspace interface"
+ 	default n
+ 	depends on FW_LOADER
+ 	help
+ 	  This builds the "test_firmware" module that creates a userspace
+ 	  interface for testing firmware loading. This can be used to
+ 	  control the triggering of firmware loading without needing an
+ 	  actual firmware-using device. The contents can be rechecked by
+ 	  userspace.
+=20
+ 	  If unsure, say N.
+=20
 +config TEST_UDELAY
 +	tristate "udelay test driver"
 +	default n
 +	help
 +	  This builds the "udelay_test" module that helps to make sure
 +	  that udelay() is working properly.
 +
 +	  If unsure, say N.
 +
  source "samples/Kconfig"
 =20
  source "lib/Kconfig.kgdb"

--Sig_//ZUfVbT=irnzWLeV+vtEufW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT2es4AAoJEMDTa8Ir7ZwVJUkP/Rij3M95nq21JFFFQPC/yrdF
e9oYmiNUxlbiyY+tVgujAFglZM7UMSA6QaDsLZIiitX/XOxwj2MoMeD4tsAKZUgB
IcVbCmi6n+deiPlCh4tD0kra/8+d5OIq4O9YHDtbH0818n+nB32J1OrtGN5ayJHq
L1gTIR6DTfMeYFSM34UsA2pMj1qWboHYWYQUpoLNmyjzK5RiIVDGRiaX1snVuD+r
QypfI29eNfcp/XMAPrrMuHoDLDFElamPbmovWABpz8XRxpHVQEXzy8cPF7+cg05q
fGYQTw3NbajTCuWxSGUy0gSYBo952A3hni3fQRMOARyYOHPfRmmJvSUTrHFf6pNr
tz4oB6SM16qH5S8fAsbH5LvEbQO0uhDoaKm+WpAkPSiVDQsa8d7TTUif4avmfHcu
D28JnJUtI0fYjAWaUa/NogFlBD0S0utNPBd+MeN+uc/EtguKIx4BY08XKdy3N2YN
bQEkAE+AUtQS4qKsR6Wp1iRaQ/MnE0ia2xSdPKEWWFi6XQebbpma/qNcAjhPzFK8
yGozXr/2eTg4Zps0jdKJV22iPadbvzIWDY+9kv2HGcrS+vj+hvjP8X4myh0IUO60
W0Qy/w65x+a+eH6nAKwT2d6b+Zobl1gyEaxD6KEKNlnIa9dQOGAgoTOh9crY8Oeq
7dx9C1vmR7d1naxzW23H
=CWyw
-----END PGP SIGNATURE-----

--Sig_//ZUfVbT=irnzWLeV+vtEufW--
