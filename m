Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281AbaKKGnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 01:43:14 -0500
Received: from ozlabs.org ([103.22.144.67]:39044 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbaKKGnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 01:43:12 -0500
Date: Tue, 11 Nov 2014 17:43:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Catalina Mocanu <catalina.mocanu@gmail.com>
Subject: linux-next: build warnings after merge of the tiny tree
Message-ID: <20141111174304.69b9ed45@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Em6oQDHW=RxLHcc2/ISiHsA"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Em6oQDHW=RxLHcc2/ISiHsA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Josh,

After merging the tiny tree, today's linux-next build (powerpc64
allnoconfig) produced these warnings:

kernel/compat.c:33:12: warning: 'compat_get_timex' defined but not used [-W=
unused-function]
 static int compat_get_timex(struct timex *txc, struct compat_timex __user =
*utp)
            ^
kernel/compat.c:63:12: warning: 'compat_put_timex' defined but not used [-W=
unused-function]
 static int compat_put_timex(struct compat_timex __user *utp, struct timex =
*txc)
            ^

Introduced by commit 7beb114f18e0 ("kernel: time: Compile out NTP
support").  Neither of these functions is needed if CONFIG_NTP is not
set.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/Em6oQDHW=RxLHcc2/ISiHsA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUYa/9AAoJEMDTa8Ir7ZwVMQ8P/2oAK7b/lUOuHXwH8wFY4Bi9
WxTVsjf39FlGUJMuWc5Yp6PdyqRinzU2QbJ73Mz46LUAuIbgt5RaDbA3czOEOjl1
iREV+4c6wDcEWkeLaxD/8RcnMyiW2PgJzyYCZjYCgKP4K+Ok3bSlci9On3OBba37
SySkJ0mIDFBPbhdFtYan3jzcnecbhOo0dsO8Gt8TWDnG19OjHI3fU1q8/Q3imxeW
Ghbj79x89Rzhah2E9jED8p5hH3YdwQF31VIzWXdpNwnM6PDUGTAHRmazM28eRmSh
R3fI+aWc5ocl2iPHwIBJH/iKmndRXKSvPaSBMsM+zdt0jAfV2cdUNRTybRWnWBQu
trtK1VyHxPy7AD9v4NIZlfD03lmWV+ffoIDx9oxK8M+pPA4wCnuaOha5W/ZeGYHH
qNwM26eqK/n04zdyN6cD6+ELb2yg5hccyIrD6owXPR1VXwZnhQtt+sexVJ4nOq+r
Ta07l/b2QwahQ62Sm6Urg9xwejT5VQ2UHFhULlKF6NzO7wGtPOPzA175FwkN8b4G
6q88ikQNiSbCHqSzHjepIMa3+cAxjEPzUyS2DwAq/HQo29UqUtMnAEsP3hGEdhTZ
WTQMw7IAxjXqDnEOGpFFOAdnOvTYTAH7+T8qXFkOLbtKTd5L0ZLkiplaicQCdwua
3f/10TpSOPNecRHM+rkB
=x5YZ
-----END PGP SIGNATURE-----

--Sig_/Em6oQDHW=RxLHcc2/ISiHsA--
