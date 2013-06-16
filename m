Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab3FPApG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 20:45:06 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:44397 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765Ab3FPApE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 20:45:04 -0400
Message-ID: <51BD0A66.4070003@gentoo.org>
Date: Sat, 15 Jun 2013 20:44:22 -0400
From: Richard Yao <ryao@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130522 Thunderbird/17.0.6
MIME-Version: 1.0
To: shencanquan <shencanquan@huawei.com>
CC: Jeff Liu <jeff.liu@oracle.com>, Mark Fasheh <mfasheh@suse.com>,
        linux-kernel@vger.kernel.org, kernel@gentoo.org,
        linux-fsdevel@vger.kernel.org,
        Ocfs2-Devel <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH 1/2] ocfs2: Fix llseek() semantics and do
 some cleanup
References: <1371237814-59365-1-git-send-email-ryao@gentoo.org> <1371237814-59365-2-git-send-email-ryao@gentoo.org> <51BBF6FE.6080502@oracle.com> <51BC080D.1090405@huawei.com>
In-Reply-To: <51BC080D.1090405@huawei.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2FLXEQILIHNTRTMUXPQIE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2FLXEQILIHNTRTMUXPQIE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/15/2013 02:22 AM, shencanquan wrote:
> Hello, Richard and Jeff,
>    we found that llseek has another bug when in SEEK_END.  it should be=

> add the inode lock and unlock.
>    this bug can be reproduce the following scenario:
>    on one nodeA, open the file and then write some data to file and
> close the file .
>    on  another nodeB , open the file and llseek the end of file . the
> position of file is old.

Did these operations occur sequentially or did they occur concurrently?

If you meant the former, the inode cache is not being invalidated. That
should be a bug because Oracle claims OCFS2 is cache-coherent. However,
it is possible that this case was left out of the cache-coherence
protocol for performance purposes. If that is the case, then this would
be by design. someone who works for Oracle would need to comment on that
though.

If you meant the latter, you should ask yourself what would happen when
you run two separate programs on the same file in a local filesystem.
There should be no way to avoid a race without some kind of a locking
mechanism.


------enig2FLXEQILIHNTRTMUXPQIE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRvQpsAAoJECDuEZm+6ExkMR0QAIVIM/GQSjPWLBdmhnQ8L9Jw
BVwMjAzbchP65uoDoXvvdNECoPHfDirwNzojecO6b2MKI9T7c1hMoA10bfysPV1W
YtqpuCdxx5kLHFlcdcVGyK/a9cndOrjIBGlLQeVVJmDrowHmxk26ReQ39GNX1pDx
AZ2GOZuRtSmBTdbohTWQ6GAkelpkbLLOIdPQypOMhjUpokyInsnoR/4pwpz0NrNk
47NtXsglc5thTIVoAqvdbHS1d/2prj+fcUqfRXsrkMGHK83cpeDfMQv2XOA510i9
qyPu2xjivKeL+uRcvlC90mT8GZupIakWfyshz1vMwsmPRw1XwmOZn/1dTLdA4fKH
lUHq1YSWidwb5m8zdQgDAiagtVFuYDtlAFALnx+NiHjc5N7h+DwVQnTuXt4R/+tp
tsJn39Ldne7QNDZxj25UEBKvBm6RhLVeHj4W1Io19m1226Qvwslc7rGdP61tbTS2
DZoaXIHkDVVHG+CT1nQojTl8YNQ1nVCRqhBCKBqEvWnrbzyoNNPJgj+uONzfum/O
4TDkKAB1KMaL7qvKteUh2OA1ZdnahciWUpfltm3o2bX2Zjj2wgofV58C8Owdo5SD
aIdP6q872M6QBPeaGryVdvGDEuT0dyu9V0DXEskpYFA5HqdvyTzskGgHPAXbHKmX
VI04dztHzltQ1fUQzZqL
=o84J
-----END PGP SIGNATURE-----

------enig2FLXEQILIHNTRTMUXPQIE--
