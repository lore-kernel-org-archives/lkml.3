Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab3EMCHm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 22:07:42 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40566 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab3EMCHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 22:07:41 -0400
Date: Mon, 13 May 2013 12:07:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>, Eric Paris <eparis@redhat.com>,
        Kees Cook <keescook@chromium.org>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20130513120728.f3f469e5d71b39ec78800175@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__13_May_2013_12_07_28_+1000_AdYT7yY=huZ6G7hi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_May_2013_12_07_28_+1000_AdYT7yY=huZ6G7hi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
kernel/auditsc.c between commit b24a30a73054 ("audit: fix event coverage
of AUDIT_ANOM_LINK") from Linus' tree and commit "audit: fix mq_open and
mq_unlink to add the MQ root as a hidden parent audit_names record" from
the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

BTW, commit b24a30a73054 from Linus' tree has Eric Paris as Author and
Committer, but is only Signed-off-by Kees Cook.  It is part of a long
series that did not go anywhere near linus-next.   I do have an audit
tree in linux-next
(git://git.kernel.org/pub/scm/linux/kernel/git/viro/audit.git#for-next)
but that hasn't seen any recent activity.

There is also another commit in that series that doesn't even have a
Signed-off-by line at all (4d3fb709b285 "helper for some session id
stuff").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/auditsc.c
index 3c8a601,f9eaa16..0000000
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@@ -1399,8 -1695,11 +1399,11 @@@ static void audit_log_exit(struct audit
  	}
 =20
  	i =3D 0;
- 	list_for_each_entry(n, &context->names_list, list)
+ 	list_for_each_entry(n, &context->names_list, list) {
+ 		if (n->hidden)
+ 			continue;
 -		audit_log_name(context, n, i++, &call_panic);
 +		audit_log_name(context, n, NULL, i++, &call_panic);
+ 	}
 =20
  	/* Send end of event record to help user space know we are finished */
  	ab =3D audit_log_start(context, GFP_KERNEL, AUDIT_EOE);
diff --git a/kernel/audit.h b/kernel/audit.h
index 1c95131..52dfbfc 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -97,6 +97,7 @@ struct audit_names {
 	struct audit_cap_data	fcap;
 	unsigned int		fcap_ver;
 	unsigned char		type;		/* record type */
+	bool			hidden;		/* don't log this record */
 	/*
 	 * This was an allocated audit_names and not from the array of
 	 * names allocated in the task audit context.  Thus this name

--Signature=_Mon__13_May_2013_12_07_28_+1000_AdYT7yY=huZ6G7hi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRkErgAAoJEECxmPOUX5FEmVAP/j04d6CdK+qItwc5SIjsdPQ3
2+cNFI1DrMVdD6AY+awiDvU9/bQQr1Wgwx7X6yqq3VBk7k+VsO98DYOyligtDcYf
P1hhLYnMFsqOA3y5WrqQ1D1Mu40TtsDeYcguc2PgqxnX5cus+VFXZieumjrYEXLl
uIip9d6wbMZ195glreUK8oz/Y/c8LC+6guJYGvtFeC3z5UpME5QbweivFJwg+sZv
T+RcbC+OgrinWrifS7oSFwxmSFsDisELXyGNwe1kZBUAPiKyoUnGpIgv4rA5W9KT
aAGK5KZLazyvn1CXI2nNW9pmluY4VgY/UqjAbIA6krPe8KIg6tyWaaNvAL7HFTkw
GdjxDpnMXHWIPm/DXlbVt3aUaV3Peal7LTk5b/dVlfetB37XCU9hhb/hSN6++HTq
pWEIgdCSI+rTBxU4sDd8ggSDh4a4wvwur/KyfAeG2EeugzA0vAbpF4WwsVVdyUe4
4rC6KZLWxVXHcXpZrsJQcveBnTjCK8d93K9/+0c3fIFKeVS4k5/SKHR7FJAVDYot
/C/72VQZr9Aeem0y3NN6dxuNFElZMPchTFBMSZbPVuL5mRk36rH+/zMhwppC8aDE
CZCLpB6wz35K1C9261ipx9uQEYrKoVifPAfH6YRxGcvzZILMWDvsTy1BG2x5jfpr
FK3HnoUqyAKgz4soHEFe
=j3ku
-----END PGP SIGNATURE-----

--Signature=_Mon__13_May_2013_12_07_28_+1000_AdYT7yY=huZ6G7hi--
