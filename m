Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161549AbaJaA6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 20:58:52 -0400
Received: from ozlabs.org ([103.22.144.67]:53387 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161391AbaJaA6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 20:58:51 -0400
Date: Fri, 31 Oct 2014 11:58:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>, Olivier Gay <ogay@logitech.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: linux-next: manual merge of the hid tree with Linus' tree
Message-ID: <20141031115843.155b65e0@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/uniAoZLte/5lQ=AKeEaZKKB"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/uniAoZLte/5lQ=AKeEaZKKB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the hid tree got a conflict in drivers/hid/hid-=
input.c between commit f974008f07a6 ("HID: add keyboard input assist hid us=
ages") from Linus' tree and commit afdb5cce979b ("HID: input: Map unknown c=
onsumer page codes to KEY_UNKNOWN") from the hid tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/hid/hid-input.c
index 725f22ca47fc,7ea582be9c9a..000000000000
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@@ -865,14 -862,7 +865,14 @@@ static void hidinput_configure_usage(st
  		case 0x28b: map_key_clear(KEY_FORWARDMAIL);	break;
  		case 0x28c: map_key_clear(KEY_SEND);		break;
 =20
 +		case 0x2c7: map_key_clear(KEY_KBDINPUTASSIST_PREV);		break;
 +		case 0x2c8: map_key_clear(KEY_KBDINPUTASSIST_NEXT);		break;
 +		case 0x2c9: map_key_clear(KEY_KBDINPUTASSIST_PREVGROUP);		break;
 +		case 0x2ca: map_key_clear(KEY_KBDINPUTASSIST_NEXTGROUP);		break;
 +		case 0x2cb: map_key_clear(KEY_KBDINPUTASSIST_ACCEPT);	break;
 +		case 0x2cc: map_key_clear(KEY_KBDINPUTASSIST_CANCEL);	break;
 +
- 		default:    goto ignore;
+ 		default: map_key_clear(KEY_UNKNOWN);
  		}
  		break;
 =20

--Sig_/uniAoZLte/5lQ=AKeEaZKKB
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUUt7HAAoJEMDTa8Ir7ZwVBAQP+gM1nEWl/2/KQTyAtDv+H/LX
SRuUrVYS7ii1zbC9Ptasu3ooZdeMj9oQU08L4hnJUJ9NJYIlpU58q24IfUIFAKMY
zBs6E9UWXWWsusHX51J0oeAxmmQOjfNS/n6HiB24kdCDa4ttC3uLoZJ7xpaJfdqX
96f8Fa3/puFfufFKeGzdpSJ1orsjwTNgSX0NWdirW7vF2G4PkW5GoY0uK09nt5cP
xlXIc/wVL2WwVPDCcwjXvxjgtzQFO58cxyFFQulmw6fRJ6Zb0C7+4zaBnKBynZGp
b3WMoy8u+mvhRHZlQa+5op4rFuZwI7JT6Rn6YKcGS8iNBSsc68qsetLDsywnOzlh
aS6GQ/A984Q5gBZpkS9PO5QMOSJvGspzds8842OavmB5Nu51VTvydPNzUV+4V8C5
xSKtxlnRHnn+rl+rM6eBfSy17emC7NxZb0lER+VyDnMXYUnPMDPrBKJ05NV8MWLV
D1auiwsPP+k4uWKhoomFlYYHMX2HjlVTrmQDjR6ekDL9ghLad92xukaRcYrjF/7c
AUig4GKqF1o5yvWhRf43o8aw0hhYCZ8Xzs8ZOc5/Z79p0FwpTpVmRg912S/e9aRS
xj0G1xBF7igvvm+YWm02tb/1yd0BPexgAj3/DJLDb4KfRcfA9KhniSEg37SSBnxh
KZ1MAIQ/SeL+mYSTEGWt
=FFmM
-----END PGP SIGNATURE-----

--Sig_/uniAoZLte/5lQ=AKeEaZKKB--
