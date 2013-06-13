Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab3FMBWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 21:22:48 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:42887 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932314Ab3FMBWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 21:22:44 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: next-20130607 BUG: sleeping function called from invalid context at lib/idr.c:424
In-Reply-To: Your message of "Tue, 11 Jun 2013 11:38:20 -0700."
             <1370975900.1744.20.camel@buesod1.americas.hpqcorp.net>
From: Valdis.Kletnieks@vt.edu
References: <19828.1370975638@turing-police.cc.vt.edu>
            <1370975900.1744.20.camel@buesod1.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1371086526_3690P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 12 Jun 2013 21:22:06 -0400
Message-ID: <4972.1371086526@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1371086526_3690P
Content-Type: text/plain; charset=us-ascii

On Tue, 11 Jun 2013 11:38:20 -0700, Davidlohr Bueso said:

> > Looking at 'git blame', I see a bunch of patches from Davidlohr Bueso on 06/07
> > that hit ipc/util.c and friends.
>
> Yeah, this is my fault. It was originally reported by Fengguang:
> http://www.spinics.net/lists/kernel/msg1545633.html#.UbYI9qqdmV8
>
> Sasha proposed a fix to use GFP_ATOMIC in idr_preload instead of
> GFP_KERNEL:
>
> http://lkml.org/lkml/2013/6/10/322

Confirming that Sasha's proposed fix eliminates the BUG in my kernel,
so if GFP_ATOMIC is acceptable otherwise, feel free to stick a Tested-By:
on it of you like.

--==_Exmh_1371086526_3690P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUbkevgdmEQWDXROgAQKeCw//WQGBfWNhMV1fjFprzRwlQpzTnIRnkglD
RigNJM72VYs5ZnyS9NZx37aM1LpUKJYAIGziraRqXomgHnNaCY8rqH9Ir1FMleFm
rzWjGNSMsv1A6GvUdbSMgxXuWZ0JnccDR1cDZvWfhhrn9cWX67wR8vwb86pyTRvZ
lFrGgVj/+1zOP50vLYr2Wlhs7bFfuY74kXOYdovvouqcitT6dMAbsvqVh4ggpkbk
Qbk5Iog4WBj62lQc1BBCe5xz1FybmlamfcgXUkF1a91Dyx/WFdkO/OiAfMtJjMkc
VJv2/RExnejNdwor8ooXbyuuVVcSb4aCrDGd5SiiuqlHP03+2sCq9pvrfXVTpZ6Q
B45TwC3lCi4GlAHxJ1/PWpFqB+kyvFEw6yedB58Sh9h8pRWufV4a0B3hChoMHXYa
uym9S+FIv3cWkX3nfnGlHCH/p7prb+MEPaSyEzVP0ojdMZ0hC6ZqQGgS7JhOlTiV
99Hlv+eGuwM8pzqabn5OrvqeJrZzcDRFFClUz+2dt4l1kVoAiU2rxSk2zJlC85RH
HIuavTEnQ7+HhsWn0jlnoyempUhbPZ7XCs8xmUGjAT8cnfJ1rPPxZE66r07FEivN
Tr92wQqQsgWgtJV4kpyFjquS0adyraZsxEAQBYlyQpINaUTgScaZjtedY74o0WG8
spuF8VLebM8=
=Jdzp
-----END PGP SIGNATURE-----

--==_Exmh_1371086526_3690P--
