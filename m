Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab3H0CvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 22:51:01 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44171 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab3H0CvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 22:51:00 -0400
Date: Tue, 27 Aug 2013 12:50:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lu <aaron.lu@intel.com>
Subject: linux-next: build failure after merge of the libata tree
Message-Id: <20130827125049.62d12bba371fe8d9df85a227@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Aug_2013_12_50_49_+1000_=k7K61buwNQ=beQf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Aug_2013_12_50_49_+1000_=k7K61buwNQ=beQf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

After merging the libata tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from drivers/ata/libata-pmp.c:14:0:
drivers/ata/libata.h:136:1: error: unknown type name 'acpi_handle'
 static inline acpi_handle ata_dev_acpi_handle(struct ata_device *dev) { re=
turn NULL; }
 ^

And several others.

Caused by commit f1bc1e4c44b1 ("ata: acpi: rework the ata acpi bind
support").  All the world does not have the ACPI include files
included via some other path ... nor wants them, I suspect.

I have used the libata tree from next-20130822 for today.

P.S. drivers/ata/libata.h seems to assume that a lot of other stuff is
included that it does not include explicitly ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__27_Aug_2013_12_50_49_+1000_=k7K61buwNQ=beQf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHBQNAAoJEECxmPOUX5FEzCgP/Rr758i/nJeBaVal/H4XxTwM
UxfYZXJZ5dAKV/ht7HZLNJ3xxj0efKEzZ8mH3hLDy05JRBDZILA+StLgBjsoD004
tM+IWYiootA2aDBUKOGzt2JcS2t61AWXZmxFhesdU+CiUzvu4fnVVF2sdR3WLBY2
Xfh0N3S3aqcudLeXPPAsz0UgcQCYOn8st45Nd3Q3j57SwwOxW4ycnk7FPTrAtCP4
3+k6TfC0w+flrbLOqWGZlJQG7yU9t7aqGCywl0CZCN9U9cGIsWKf19149wPnfLhY
kASn2Xi6RIx21eUpdKXLmO/7Rt20PDLfAqeihp4b0+ySne+oRjAvZuzA0gtgfRh2
JLreCGHRsTrSlca4pFi95xjeCnkfle2o69osXggGw6Yx093OW2AcV7cBdD56tQ0I
6uGXCRhAr0+LrNarvz75SDBy6Y0FNoTmzNm2BLxVjIv321aQtM5AZmqTCb2XHOCP
0EngFX84VaTxMunNi7CIiskNxIsxnALOqjdDx/cWgbgLCdGLeXYvRWEjjigFc3es
kv6FrOAlJ0bydcB7Q8o9rb0MDxn/G13eTAcBotMqnow/ck6Fv46A+0GuLNjUMkg2
MiYRMF7g9nMq80YkDQFISJxS6q/wZ/cX23CASzOEyN3bJhY+ryjz7BkukbQW98Kc
jiKZ5kzRgZsDFV1H1uMb
=FLgJ
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Aug_2013_12_50_49_+1000_=k7K61buwNQ=beQf--
