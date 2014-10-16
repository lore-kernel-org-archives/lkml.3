Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbaJPBxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 21:53:31 -0400
Received: from ozlabs.org ([103.22.144.67]:55237 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbaJPBxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 21:53:30 -0400
Date: Thu, 16 Oct 2014 12:53:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the thermal tree
Message-ID: <20141016125321.20509c53@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/HRYdY8r3JID.Axv=KS1gLVn"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/HRYdY8r3JID.Axv=KS1gLVn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Zhang,

After merging the thermal tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/thermal/thermal_core.c:1183:1: error: redefinition of 'thermal_cool=
ing_device_register'
 thermal_cooling_device_register(char *type, void *devdata,
 ^
In file included from drivers/thermal/thermal_core.c:34:0:
include/linux/thermal.h:345:46: note: previous definition of 'thermal_cooli=
ng_device_register' was here
 static inline struct thermal_cooling_device *thermal_cooling_device_regist=
er(
                                              ^
drivers/thermal/thermal_core.c:1221:6: error: redefinition of 'thermal_cool=
ing_device_unregister'
 void thermal_cooling_device_unregister(struct thermal_cooling_device *cdev)
      ^
In file included from drivers/thermal/thermal_core.c:34:0:
include/linux/thermal.h:351:20: note: previous definition of 'thermal_cooli=
ng_device_unregister' was here
 static inline void thermal_cooling_device_unregister(struct thermal_coolin=
g_device *cdev)
                    ^

Caused by commit 571ed5a8177a ("Thermal: int340x thermal: fix a Kconfig
dependency error").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Sig_/HRYdY8r3JID.Axv=KS1gLVn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUPyUWAAoJEMDTa8Ir7ZwVk4sP/0CdbOy+PdOVLQDE+oNHhnFz
DxYCBQ1NrRc7brjtpmb5LeM1xc2UB11HSNGQpSR4QChImARy7bz3Lm9tWX2lCly4
3neDBzRS5bM71er3hB3mrUVeQMiz7As632rOFJlZGVMXvKLgXup9HNo9sNF8xRVb
bznf7m+cDoDEasWMt6XEdsFl/mcKFOuloxdRK5ToKtXX1+PZ8s5x8o8w3q4fJjJb
D9yUrCyqkl56tMFaS30M4yDoLF5aSTwz5G2XM3LO7b3+ebsdZRzxqoWYEcwKFYuG
tLhBcM1iRW0npKb4lfIfNZGnasl4FeUlPmnRHCHaN8BPCDQOMwAdXm7hye6ut6/7
1jLMw/E15UONRvTqzNa/Pp5j3RcGeQJVQHsVHEb6a1pCYtL1Pv3wTw3zoqTf0fSI
/srAxOjLcJ/j+EF5Na8LKFOoo9TrSUdt0RI84lXHJu4FubUSebshl5HJ6hG7O1rb
JwdYv9zDr+TV51yqQfiK3JcP+vhHuvEgFDL0++22X6CaFF+Aoat4/ZlSad3Odw8V
gPr+M5OQP12OtEBR2soCKqCel3h5hk9vx/0QWodYrAfN8S8k4ZDfsuafg3Geoo9S
vsNjUAvWyOWFLzHXjxzveYTG34/rX9htJ4pjqQuRFJwNEHTE49Hu37ytH7uPo2bo
5wx1jEcCVbXXw0ioMRBy
=xnD5
-----END PGP SIGNATURE-----

--Sig_/HRYdY8r3JID.Axv=KS1gLVn--
