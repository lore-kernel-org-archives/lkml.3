Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbaE3DXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 23:23:34 -0400
Received: from ozlabs.org ([103.22.144.67]:43504 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbaE3DXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 23:23:32 -0400
Date: Fri, 30 May 2014 13:23:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Ball <chris@printf.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David =?UTF-8?B?TGFuemVuZMO2cmZlcg==?= 
	<david.lanzendoerfer@o2s.ch>,
        Hans de Goede <hdegoede@redhat.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: linux-next: build failure after merge of the mmc tree
Message-ID: <20140530132324.757076ca@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/75Pg84MoVKxTgJg=.EQ_ATJ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/75Pg84MoVKxTgJg=.EQ_ATJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Chris,

After merging the mmc tree, today's linux-next build (arm multi_v7_defconfi=
g)
failed like this:

drivers/mmc/host/sunxi-mmc.c:25:29: fatal error: linux/clk/sunxi.h: No such=
 file or directory

Caused by commit 19b7f796c375 ("mmc: sunxi: Add driver for SD/MMC hosts
found on Allwinner sunxi SoCs").  Something has changed to turn on
CONFIG_ARCH_SUNXI in the arm multi_v7_defconfig build since yesterday.

linux/clk/sunxi.h is created by a commit in the clk tree
(git://git.linaro.org/people/mturquette/linux.git#clk-next) which I
don't include in linux-next until much later than the mmc tree.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/75Pg84MoVKxTgJg=.EQ_ATJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTh/mxAAoJEMDTa8Ir7ZwVJPsP/RDhZ2hsuABYExENx1XSnR0p
MDfRNH7WBII0NKmniWGMtXeA/XfLwLry9j5yRPblaoAZbzcMbmoKDarTwOXW1LId
3j5jRyEbS5MgjBk86Gwy/dzK5M0S/oU1+QwR+ApaNfwphtRVRoqaP33CCHdVAGRk
5OJwu2y2WaSRURifVdVqdNvuUUXnCSMN5JWc4Sn9VIm4/L33Nb9/srL7sVwlG1wQ
xHLYG/Yr1xeTIUMTpShPL/A1c3NSAqamQMHrXLcMKbby4YYYBZ8zYLgTIwmBYPws
HhWBty1WzhaFGGiROjfvNWejQUmfGgWEu4khi9cyfzlj0xcDJuUOoj5p0HnLMOrD
V9uMibIRvWVUlkIfPZbhkfxHxpsi1F/DefchwTRMAmLJLmu8myHoBp1vdo1oLh6y
bKjvvwEvO0wSpsoOnheKfZOk/7vYU9L11gkta3WXHvZCwXgRu2zok1JYIEPjpIuU
qaMfEDnUebAJia/nzEObO9RYgQQf5c7385z5LD065jzGkgLzseBIK0xRT3oLa3QY
TctCgRBj/rJvIBZ+EsYlgO2Z4kpisujAI/xbK7i9XQOt+pjgjMkX3TjRE+qCRmgb
blNFKIXLpW8eUnxIxMifXWsyolbKI4Fn2mlU03w+gvuRJzrZ4ttOwiVQPsOyzZvu
yzdRTnudBs2XtsihTIWD
=jzGX
-----END PGP SIGNATURE-----

--Sig_/75Pg84MoVKxTgJg=.EQ_ATJ--
