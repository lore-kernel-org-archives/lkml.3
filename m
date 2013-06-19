Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab3FSIAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:00:40 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46616 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436Ab3FSIAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:00:39 -0400
Date: Wed, 19 Jun 2013 18:00:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>
Subject: linux-next: build warning after merge of the final tree
 (driver-core tree related)
Message-Id: <20130619180027.ede041e59b1c642c7e5c603c@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__19_Jun_2013_18_00_27_+1000_IziZqzEeFkv4niUT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Jun_2013_18_00_27_+1000_IziZqzEeFkv4niUT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allnoconfig among others) produced these warnings:

drivers/base/firmware_class.c:1254:12: warning: 'cache_firmware' defined bu=
t not used [-Wunused-function]
 static int cache_firmware(const char *fw_name)
            ^
drivers/base/firmware_class.c:1281:12: warning: 'uncache_firmware' defined =
but not used [-Wunused-function]
 static int uncache_firmware(const char *fw_name)
            ^

Revealed by commit 93232e46b209 ("firmware loader: don't export
cache_firmware and uncache_firmware") from the driver-core tree.  These
are only used if CONFIG_PM_SLEEP is set.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__19_Jun_2013_18_00_27_+1000_IziZqzEeFkv4niUT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRwWUfAAoJEECxmPOUX5FEwCQP/3ymflDo+0Kl4wLPPnB/PFd8
9RtJMAphcHtxdWKP+dMoG9hegPNBXGgqP7lX/Wu40FLpdVz1vuK8xwUAkDOH/DZy
53QCWK8CNCU3yB956JqYQew8vTDWMhC/bwwYm3bhIb6bOak3SbMxLfJJLHCfKpvz
Ulxwr2YY6oHqCqeDmnrEog4t25CciIfiOS7DhwtfVcaXAlTMvpZp19F4BaoC11/V
1QdQGiYypxhGo8cAHr5gopLavCdg/YE5XTIHjzNJZL7iVWSdD9LOBoIz/k5DD2fF
9H8dCARqedCcHx05Zpzd9ChmeHf37UAMmdrc4xAhH3biVyFAu6bFMQeyysuQecm4
it1B2GKZenr9R1uO68akOaF9aMC1LMiyiwVA9OfqTMljzANdBtl6pe32XT+Guj4J
/5Pgeubx6vF/cml7nwd+A2ePfL1k5NdbiPExr2fzQiurqxSotQmjVYVO301fZE2J
XDP7DABLkucRtT2IZ8XG2krJ9Fijzl2S11HJ27dhD7PAOqmuLXeVkpPGkvoqbNhD
Fv11xLq5u7PgEvE0MCvqpROoXO6tDppw8En+Mxd15HYndpksJ4kaAOkuqAthcIVF
QaZCP+49vZdy/fcloGcfDM/mzW9isEwANbtKfwmwrEwwbrvC1RYoGQOKIawnLpcX
CNAfO5sakNCTkZQFIa8p
=BwFN
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Jun_2013_18_00_27_+1000_IziZqzEeFkv4niUT--
