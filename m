Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab3CMFMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 01:12:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58827 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab3CMFMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 01:12:43 -0400
Date: Wed, 13 Mar 2013 16:12:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>
Subject: linux-next: build failure after merge of the final tree (cgroup
 tree related)
Message-Id: <20130313161236.760c25633a4e8ea8d4847ccb@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__13_Mar_2013_16_12_36_+1100_AqYCaqDMOr_YKbvE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__13_Mar_2013_16_12_36_+1100_AqYCaqDMOr_YKbvE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allnoconfig) failed like this:

In file included from include/linux/memcontrol.h:22:0,
                 from include/linux/swap.h:8,
                 from include/linux/suspend.h:4,
                 from arch/powerpc/kernel/asm-offsets.c:24:
include/linux/cgroup.h:748:13: warning: 'struct cgroupstats' declared insid=
e parameter list [enabled by default]
include/linux/cgroup.h:748:13: warning: its scope is only this definition o=
r declaration, which is probably not what you want [enabled by default]
cc1: all warnings being treated as errors

and many more similar.

Caused by commit c2c9ad164fa3 ("cgroup: remove unneeded includes from
cgroup.h").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__13_Mar_2013_16_12_36_+1100_AqYCaqDMOr_YKbvE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRQArEAAoJEECxmPOUX5FE5AYP/jDkTkqIMC+X6xys8RP/JfUJ
Nopq6OCc2962v2hXdEWxcPgwihcItRdxeoI7NQYx1ndMXk57/CwT+xVTKFxdBQNH
Q0EtGMN30j5twcqQXSYk2bX4iAG0dsnjXK6pqtYk0dR5yCrr9trMZPm+XZdCUT7/
zU096e8xzvZGwa/s7gp84/hMPartBnu0XeX/1WpdP+CCcLrd8u9gpoATg1P4M07e
bRdah8pnueHMs1T9Yt/E7kPR4ZIij4hHdGXyv9geUUO7e4OtHuk0mP/qDkLkspoh
3i21wnbROiu5O3JTRH1zK0B/qH/fldjorBW8343IdqXUbfFL/nJPouAdHogZKUrj
iNhQtLckDMxsgGoyoGlFb0kLhP/PNQNrWS2cFuIeihOY4Pgz3uV5Eg4gAN78Mtmh
x0Cb5iObQidoLUMGbOJAH0lRiwQpY1tmZDjK5Ovzd2ztBqisBBvBo/+3n02F5e6Z
02UWEo0Q4opUouOpzBnI+nYQrA4ltFB6A8a95/8fJaw+UBVGKMRR9wl+D/7CoDpu
z+5sG/Sw2lbajl6lNLbRGAHqqcdPk/kn4G1pyn+m8phyB5OMqkBCdXwghVprKpHz
MbotdsoCSGljuZOkvmtup2xCJtaCtNi5AR3xD0jopSCnxtR3eo1JXAE54TI2IF+z
TdIkdkBQZRgPU4pcqn35
=TfYy
-----END PGP SIGNATURE-----

--Signature=_Wed__13_Mar_2013_16_12_36_+1100_AqYCaqDMOr_YKbvE--
