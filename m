Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbaJUAdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 20:33:23 -0400
Received: from ozlabs.org ([103.22.144.67]:59195 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbaJUAdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 20:33:22 -0400
Date: Tue, 21 Oct 2014 11:33:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oder Chiou <oder_chiou@realtek.com>
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-ID: <20141021113314.7d335e3a@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/QvyAVVOSIts1rD.7_C3RzFS"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/QvyAVVOSIts1rD.7_C3RzFS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

sound/soc/codecs/rt5677-spi.o: In function `rt5677_spi_driver_init':
rt5677-spi.c:(.init.text+0x0): multiple definition of `init_module'
sound/soc/codecs/rt5677.o:rt5677.c:(.init.text+0x0): first defined here
sound/soc/codecs/rt5677-spi.o: In function `rt5677_spi_driver_exit':
rt5677-spi.c:(.exit.text+0x0): multiple definition of `cleanup_module'
sound/soc/codecs/rt5677.o:rt5677.c:(.exit.text+0x0): first defined here

Probably caused by commit af48f1d08a54 ("ASoC: rt5677: Support DSP
function for VAD application").

I have used the sound-asoc tree from next-20141020 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/QvyAVVOSIts1rD.7_C3RzFS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJURanOAAoJEMDTa8Ir7ZwVMwwQAI2T+Ip/FTWKpKr3XUl3Xlow
C0Dy03A4EBQ2hUb/bScdzaUEjekEl72nolS/zF07Cx3wr4yvNVvAU3QI4WfY7/Pw
+1ire4o2sGkbZUEe12q4xhU0CKcdayghDwLIEqP9aErD1dp39RLLsyneysXjjqJ4
YsYyKbIajHARq0bMyT5UIrY9vXg1diCw6NwUMNMp2X0SIIlH08JXVz7p5IkIpfJ2
Lm7xXYr/g5Qd4dJly65VLH98ezHgryZOjS3O0eDVZ+zcPLtXUGsdorAjSNFXBn/n
u7Wb3je5O7KJOjRUem7jvhCk/wncdgEKfO77NrK99L92jn1S5y+dfyZziZbcAbaE
ytCxYNE7wurHnKE+vbYHwyFD3Ro5u39kXdBsl5VQN09V0vWZeyMTYPdZqdlgmAl5
xeWnBYJOyfO7dLZsf5f1+4qni1tFlsL413ffYCAjKDKtjCDCIiajFzqLFDz4debW
o8y4/FgvO3kwsJ0DgJ+2N4oE+u+P7e6zzs6en6xuzr8iVatXG6O6GIjw9p7fChAK
YtpU3/IRIVK5nBwZGvqPeR+EKS0TxsIC2L1XOm6j2eHTALiCybOX+A2cLoUQN6lo
5/wSuf14rqCoezEkl8IXh+/YYF72KxExHb1hVljdPx+lrEChy3ILwtBPCt9C0a1i
Z6yqP9269Qri/pEFt/zh
=BrRl
-----END PGP SIGNATURE-----

--Sig_/QvyAVVOSIts1rD.7_C3RzFS--
