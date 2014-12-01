Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbaLAHmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 02:42:14 -0500
Received: from ozlabs.org ([103.22.144.67]:58357 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbaLAHmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 02:42:12 -0500
Date: Mon, 1 Dec 2014 18:42:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arend van Spriel <arend@broadcom.com>
Subject: linux-next: build warnings after merge of the driver-core tree
Message-ID: <20141201184205.08a8f7aa@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/mrVtLRuL2fZyAHZ_dVb0_MP"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/mrVtLRuL2fZyAHZ_dVb0_MP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the driver-core tree, today's linux-next build (arm
multi_v7_defconfig) produced this warning:

In file included from kernel/power/main.c:16:0:
include/linux/debugfs.h:105:10: warning: 'struct device' declared inside pa=
rameter list
          void *data));
          ^

And many more like this.

Introduced by commit 98210b7f73f1 ("debugfs: add helper function to
create device related seq_file").  See Rule 1 from
Documentation/SubmitChecklist - though in this case a simple "struct
device;" would probably do.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/mrVtLRuL2fZyAHZ_dVb0_MP
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUfBvSAAoJEMDTa8Ir7ZwVh2wP/i+6xV6yZHYDpYYyAKcd1q8T
2PvSJJTzD4y5TmtHUL0+C82cphSC8b94pFCIHuE0qIBSuL7dO/6/B4mesMN/4Koe
FqK4aOYnXCv2S6RgF7ShGGgNz0eBclysp7xnUz/wLs9GfwKXBvBWPsra56zhpFdJ
qMjSXXdh4m+NJvLbQb9pfTpYT2m7vcNdFoTetzOYEKPaI4H3MRJvvwZS6HlQSP1F
U0DuBRg3Zht8jJ//pAj3CSgUbkdLyEILPXJpB6NAUuczSkIei/wr3D0bFTEz/7Ue
sSkhEbmXLofAw32Sz3NE10gg7aO8k7HEqgwUO3yhtgi1jSajhZ3OMJusLvACwRUx
s9W0N6B5SZGjZVxkhr/lsk3zY7nihoXb2Msvhdx5k9Pv3chJFRxlZkl4d3f13TBQ
tc68Bksf3eO9weFIQYG84VFUsDH0lwCmITvemsvb/eW7Jw/FIoL4xPBggnsrGamr
SEGP36yjKn+beuhUyzPxFWF0pkXCEG98AcTa8YaPEVg3fUty6UPMI+7ET8YlaiAH
8D+8SphVkeG8ISA9imGYSbYEOfKWex3bXFbEtQOHxxvIWahuSqER8CJH7sccEMwf
zaFq8p/wZDoaeAEn4XpGKbtbmzHTVXRNUZEPvrAUzDn7D2/eqoNFWHw8RHINOfpD
XrNY7v4UbGpQC4kNPU+q
=ygh5
-----END PGP SIGNATURE-----

--Sig_/mrVtLRuL2fZyAHZ_dVb0_MP--
