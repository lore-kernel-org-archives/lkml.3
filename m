Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750897Ab3IFHT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 03:19:28 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41041 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab3IFHT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 03:19:26 -0400
Date: Fri, 6 Sep 2013 17:19:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Subject: linux-next: build warning after merge of the final tree (Linus'
 tree related - vai vfs tree)
Message-Id: <20130906171916.41b5f48d1aaccca594d1e760@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Sep_2013_17_19_16_+1000_PAEwcxlffxqathur"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Sep_2013_17_19_16_+1000_PAEwcxlffxqathur
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (arm defconfig)
produced this warning:

fs/direct-io.c: In function 'sb_init_dio_done_wq':
fs/direct-io.c:557:2: warning: value computed is not used [-Wunused-value]

This is:

	cmpxchg(&sb->s_dio_done_wq, NULL, wq);

Introduced by commit 7b7a8665edd8 ("direct-io: Implement generic deferred
AIO completions").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__6_Sep_2013_17_19_16_+1000_PAEwcxlffxqathur
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSKYH4AAoJEECxmPOUX5FElpYQAJ9VUnNQLEvZS1IhCHi1ZwDS
NIHnr2OO6NxaXkVPjxluH7hNh8nAWdJEIYe6Eq5tEZd+U67XluNVRYzeoaJMfZD5
bbX09sVYBjt7WM0VkOyoehUOJProQNhbCLA7Fh+V2NTahDzhQVKMdqQSX7Wy/HUI
+v9mViNHFScTSaJamuZqhTfKCGFbPSxEoBvdFrqDONvn5+5w3XEfDydWwSzRXwuj
4epBA+h3Wn2OE/UHB6CAmJ5+oi87NDOImVN5ZBanIeAMLPQjFLLujokFQHIjCQjZ
EIsenCNP8ncGkAZ9n6PhDTwjN/EnKTBiYVtfJLUWIDmM03E3MJRqgxtzSNBYtjYq
+fA5rKrlcVsMPpJ4YcdsveOM21HdyglL8e/OZo8hpSNOvHOHeyP9p9ulZYRng2DF
1n1E7wm3B74ZmKmhFCDR1cLsfvdkZVHfOQV0C+u1Czgpz791g7yrNDBid3yXIJJJ
OJR1rQxYfd5hU9Hj37T6nxfgvG3S9pybpng8WapfS9BMhBagLtra99QiM8LcUzL6
sTc97y8mp7jMB0mhVELliwofu5TXJJhUnVp0pzR9A0XeOzPggrgLgqe/QHYrjC7h
pGCXmA1U7tuf1TfZBE4B8yjtatAmVmxjD4HvdLKlf0Erf0EJN5NRf73eLbQYurEF
qzeDYnodA/ZzN6rQDtVf
=aM2t
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Sep_2013_17_19_16_+1000_PAEwcxlffxqathur--
