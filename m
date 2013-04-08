Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934353Ab3DHE40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 00:56:26 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45468 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab3DHE4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 00:56:25 -0400
Date: Mon, 8 Apr 2013 14:56:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Guenter Roeck <linux@roeck-us.net>,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Convert compat_sys_sysinfo to COMPAT_SYSCALL_DEFINE
Message-Id: <20130408145616.fc074f04c4c813fd2eac96a1@canb.auug.org.au>
In-Reply-To: <20130408144341.7738da3c31074f7098898029@canb.auug.org.au>
References: <20130408115325.1e4b35359271383b9c459ef9@canb.auug.org.au>
	<20130408144341.7738da3c31074f7098898029@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__8_Apr_2013_14_56_16_+1000_zONsf_9ZuoQ.58JJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__8_Apr_2013_14_56_16_+1000_zONsf_9ZuoQ.58JJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 kernel/timer.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

This depends on my previous patch "Make do_sysinfo() static".

diff --git a/kernel/timer.c b/kernel/timer.c
index 06b3245..f0e6588 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1661,8 +1661,7 @@ struct compat_sysinfo {
 	char _f[20-2*sizeof(u32)-sizeof(int)];
 };
=20
-asmlinkage long
-compat_sys_sysinfo(struct compat_sysinfo __user *info)
+COMPAT_SYSCALL_DEFINE1(sysinfo, struct compat_sysinfo __user *, info)
 {
 	struct sysinfo s;
=20
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__8_Apr_2013_14_56_16_+1000_zONsf_9ZuoQ.58JJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRYk3wAAoJEECxmPOUX5FE6UMQAJJ8yJ70VhURQgrlproJEIBo
F5zBAVCRgvuDmAZ0McV73eFmMVnVkvvk2uVLVlMyBynNoA2TEauOExiOqdX8QNBA
nyqm3qDB07lMbmULkIjY6Mf122IFWe0lRCwHJ02kUfEBj0rMVlPhDs+Uz4QQ8Zz5
2ZG/tv1aMthotbvgYAE8GgCgLlkqgPEKPulW7OGKleWuzq/ixs8frXqrCaXpoff7
oAjoxEYSosyXrCQnS4CQ71ihmlWV1jaKY07q86EeTmLkYg5McPBnt/35b7ALIpb9
XogDe96OQO+d1QqGvNsxVuqi4IlXCfUtRuLnsMidU/Mcn75ZxDiFExJMCP83eVRC
5wo6rAt+o7VDnA7TND2g3omO8fkqhdF/a3Z3k3s7bQvOiIJLQKsEurZhypyu5Pgm
9FhSrobM2+Uql2CIOCfyHnF1ZiN49Op/g/HppohJNpkxOvWVMOCWAszSHoWjtTdR
f5wbk2/JoU37cZmXhlsP16i8b7olBlbaBgRvn/JmNewMSAdT9zmstHRrT0xrTh0d
Qx7++Url/bbMI3n6SwCqOjLl8sXNiPL7uAvafzAJKQ4fqwr9iVL76pcUv5E4lael
OQ6RuK1ca/CCyatPmq0sO+lkg+gMXinFQ9NiOoRU26IWn8birsV5paoV7xT/nqDm
YI97udOVHENDpjsJmOKX
=D3kh
-----END PGP SIGNATURE-----

--Signature=_Mon__8_Apr_2013_14_56_16_+1000_zONsf_9ZuoQ.58JJ--
