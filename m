Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbaBZIQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 03:16:35 -0500
Received: from ozlabs.org ([203.10.76.45]:55174 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbaBZIQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 03:16:34 -0500
Date: Wed, 26 Feb 2014 19:16:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Subject: linux-next: build failure after merge of the final tree
 (akpm-current tree related)
Message-Id: <20140226191627.9adf3c8e1548e2016c16557c@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__26_Feb_2014_19_16_27_+1100_fkq=PmvfOsfuA.xv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_Feb_2014_19_16_27_+1100_fkq=PmvfOsfuA.xv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc64
allnoconfig) failed like this:

arch/powerpc/kernel/built-in.o: In function `.machine_check_queue_event':
(.text+0x11260): undefined reference to `.irq_work_queue'

Caused (or exposed) (along with a lot of warnings) by commit 3dd6115cd60b
("kconfig: make allnoconfig disable options behind EMBEDDED and EXPERT")
from the apm-current tree.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__26_Feb_2014_19_16_27_+1100_fkq=PmvfOsfuA.xv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTDaLgAAoJEMDTa8Ir7ZwVN68P/RLn4jRBNDZxw9Q+LrqdEZZz
ULRJyqLEDGpXBvjqHLnJqFfsIuHAhpxYHn4WUwvQfrggA8p8BmpRdQzA/9lVU0vh
ScGuRK556hqGpWHBeVj73inULU9PimuE4Onu7vaydXSDgSUyyS1LCdEAGfQgdGgr
sE/jUBqJgCx3fn6rUTkjB2RA4fCwD1vN6RkO2mvLQBY4e/pC/I9u+RDMnzEyMPRu
DHkqqrCPqyJHW8L2fPQdk8x26CgI2GCU9IdjI7zipoPDIsi8itoCH3ZVFMfgpxpp
odG/sfuZm+J76EV9C1ipG+jC7dOlXadpX6aBIKu9GMGfwH4OkrKvVLG+6xQyvmTC
kFUzQwLtXRMBHDYWISClGANUlrXM45YxJz02UlGCXVKaSnQkt6rqXVHILWXXG5Kz
DhP3tjX2XSTyOqfSP43HBSMD5urNjGKqnq9xDArmTtwX2Y70IzlqHVxlDrMkJHVw
1lLGGNxNmgSykRiY2Bukw2ujv+SfRqbKMAhPOhbHlJ5CRWbb9Tg7PKfG8jwCXcxB
Wn/2v7B/2gravEJ+1cRFmKA4PYYmI6pX708ZQBdAigzgTiRU+BPuXfOdsTXll8eg
/vU5Rd1SeCvjyMGDZMAuXFCNlNe3LgXVf13yO0vmSvPnBDjZCW8U+mwCjuqqxG8q
ZW8bZ0lc6qEduOP3oky7
=GjK3
-----END PGP SIGNATURE-----

--Signature=_Wed__26_Feb_2014_19_16_27_+1100_fkq=PmvfOsfuA.xv--
