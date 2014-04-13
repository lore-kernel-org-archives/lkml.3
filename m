Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbaDMDIN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 23:08:13 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:37071 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaDMDIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 23:08:11 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: Alexander.Kleinsorge@gmx.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: new module to check constant memory for corruption
In-Reply-To: Your message of "Sun, 13 Apr 2014 03:33:10 +0200."
             <trinity-aef9715a-72d2-4824-a3d8-306d5850c633-1397352790457@3capp-gmx-bs18>
From: Valdis.Kletnieks@vt.edu
References: <trinity-aef9715a-72d2-4824-a3d8-306d5850c633-1397352790457@3capp-gmx-bs18>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1397358483_25296P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 12 Apr 2014 23:08:03 -0400
Message-ID: <36478.1397358483@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1397358483_25296P
Content-Type: text/plain; charset=us-ascii

On Sun, 13 Apr 2014 03:33:10 +0200, Alexander.Kleinsorge@gmx.de said:

> 		printk(KERN_EMERG MODNAME "error: const kernel memory is broken (%08lx != 0), please reboot!", g_SumLast);

Make a list of all the things that can dynamically modify kernel text while
it's running, starting with the alternatives code, and adding in the various
tracing and debugging tools, and ask yourself if KERN_EMERG is the right
choice here...

Also, that printk is in the wrong place - it only fires if somebody reads
the /proc file, and it *should* trigger as soon as practical after a
problem has been detected.

Bonus points for computing what percent of single, double, triple, and
other error syndromes your xor detects (hint - what is the behavior of a
dead row or column of bits?).

--==_Exmh_1397358483_25296P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU0n/kwdmEQWDXROgAQJ7EQ//Rahr6YNor1K8raauU3OFUx142qIaeax8
dy4yZefQaLIfg8vW4fUlrux/tHeWEMOEW3xBlVHOOaL9V9rE2Gvsy2U6Jolht6XB
o0A3QKE8XnMIJMTnPg9eClOObT+XZdauzDJgAOfdFmTCE/TN/dAuVBezA3jxBfU+
uqbC9F1qu3ozyVtYWfQjk4fo/CiveOFJ+KK+tRUia7IuEAdLeU9ns8aA9c9pjudZ
rwomJzuNd6cwKIzQ3qZFI93Kfqb5Iy1+xUsoqU3azow0YRL5nCvF49sB8eSW/xc6
YQWt5Qn1udu9id3UqWjq669SmNOxegDZBySL8ffsjaC5WlIMhTJxtMWZb2SqPOqE
yQJ2bknJrwGLAmOtgkcDhZ+Y6+KI8ItrHf36ssTlF93eOk4NTmX/DHmcH37ziTpX
ZxNqh+Jku95yAPGy43ZGCkqADWreYmTDcV+jSl30cE7lj1civsuLvmeOPnJmLl3t
V1LATb+TyBBkVqelRrr38GlizhrvBGDhK5E35vFFuC7/P2ZYIvE3X0X+0lS7bO/T
Mvffi/qU+rGPEby8K19rslAJGKZP4hSmU2++/WDCNiB61E4h/gajFuFeYyU3SHAF
ZqlShwzz+AiM6LkZMULgDK6omGn+oB6CFJWyzk2Oo6CF1UUkzW5VpJHOvryYBwoA
/eKAcWuCBWw=
=oJKe
-----END PGP SIGNATURE-----

--==_Exmh_1397358483_25296P--
