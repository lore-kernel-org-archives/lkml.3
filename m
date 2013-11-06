Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab3KFG1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 01:27:46 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58030 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab3KFG1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 01:27:45 -0500
Date: Wed, 6 Nov 2013 17:27:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Guy Briggs <rgb@redhat.com>
Subject: linux-next: build failure after merge of the audit tree
Message-Id: <20131106172734.28986a5907009f84aead4e8b@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__6_Nov_2013_17_27_34_+1100_b6AjtAdFqg2oX2Ih"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Nov_2013_17_27_34_+1100_b6AjtAdFqg2oX2Ih
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

After merging the audit tree, today's linux-next build (x86_64
allmodconfig) failed like this:

kernel/auditsc.c: In function 'audit_set_loginuid':
kernel/auditsc.c:2003:15: error: incompatible types when assigning to type =
'kuid_t' from type 'int'
  oldsessionid =3D audit_get_sessionid(current);
               ^
kernel/auditsc.c:2016:2: error: incompatible type for argument 3 of 'audit_=
log_set_loginuid'
  audit_log_set_loginuid(oldloginuid, loginuid, oldsessionid, sessionid, rc=
);
  ^
kernel/auditsc.c:1967:13: note: expected 'unsigned int' but argument is of =
type 'kuid_t'
 static void audit_log_set_loginuid(kuid_t koldloginuid, kuid_t kloginuid,
             ^

Caused by commit da0a610497ce ("audit: loginuid functions coding style").

I have used the version of the audit tree from next-20131105 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__6_Nov_2013_17_27_34_+1100_b6AjtAdFqg2oX2Ih
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSeeFaAAoJEMDTa8Ir7ZwV2PYP/A+jkpXiuQvx5c2crUC2WUEK
WmzNPn67YsnPakU1mRZwJQA0xFrgZMui6R5i8isOuo2DRWINPIQaMqY/pMN5BncP
/0F0CoKpvUg5yiE4d3aBHkjTiKbVt9119lL1Z8hi+uPdM5EQHwHBP+ZeWkoDY/ZF
JCtZjsnZ6J8v3fzlTtadfetQ4nTcmXgtJF4MKBwqqZcSswWideTRdMgZEZnr8tw7
rFiujJQ1gi3FUqMqlJk5GbNl36Ohcpu1SngA/s11HX4V8LKjLphWWA5/PF1Iti6+
rKxTNbYdRRvutaOiYKIBJkXI/lMSIgCepqB8nqPI+KGuDYBXPP4WWcSijrOTuOrs
ilckRNgnSVPp7XsCDgfk+8VLN6RXhdka6fytR1Lf8UgQ//xmQf33s8RG++z2HSco
Xd5/iYKYCSQLxLDKz7/GR21EuyWWc1K3S5717bQCMq9KvrP4NEPM63Sbqej4ugx7
578vcJw4tlWHhwSuiAzna6WirNgZXpe8cIKQQUIJ84QDS7yA/emmzb+ZHTCE8vcq
XCaXZ86/gD3k/NYq5/DWVLfHc+9er1u6J/VbA7nvA038H2KYG780nY7B5ZnCfK80
hjy9/P7GKYQAKXQEYHl4MZkyJjP8Vh1sJFAPe6ga5FFPQIFBI76GyDZzf2Pox7SM
ccGN3QPZXOirWYsz8pk/
=kfK1
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Nov_2013_17_27_34_+1100_b6AjtAdFqg2oX2Ih--
