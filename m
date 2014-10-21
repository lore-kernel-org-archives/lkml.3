Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbaJUIbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:31:41 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:48644 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423AbaJUIbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:31:37 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, hch@infradead.org
Subject: Re: [PATCH 2/4] fs: add fadvise file_operation
In-Reply-To: <20141019145138.GB9593@infradead.org>
References: <1413645688-13524-1-git-send-email-dmonakhov@openvz.org> <1413645688-13524-3-git-send-email-dmonakhov@openvz.org> <20141019145138.GB9593@infradead.org>
User-Agent: Notmuch/0.18.1 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-redhat-linux-gnu)
Date: Tue, 21 Oct 2014 12:31:26 +0400
Message-ID: <87iojdygbl.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain

Christoph Hellwig <hch@infradead.org> writes:

> On Sat, Oct 18, 2014 at 07:21:26PM +0400, Dmitry Monakhov wrote:
>> sys_fadvise result in direct f_mode modification, which  may be not
>> suitable for some unusual filesytems where file mode invariant is more
>> complex. In order to support such filesystems we have to delegate fadvise
>> logic to filesystem layer.
>
> Is there a real use case for it?  So for it seems mostly about ecryptfs,
> and even that use is lacking a proper explanation.
Fairly to say original issue was with vzfs (COW stack filesystem for
containers from openvz). As far as I understand direct analog is
unionfs. We asserted  v_file->mode == lower_file->f_mode, but
fadvise (POSIX_FADV_{RANDOM,RANDOM,SEQUENTIAL})changes v_file->mode directly.
>
> Also fadvice and set_flags seem entirely unrelated, I don't understand
> why you're throwing fadvice in thise series.
It has semantic relation. Both methods manipulate filp->XXX internals directly
No problem I can split this to separate patch set.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJURhneAAoJEFzOBSYIXfveKJYP/iGdzYvrfQfdv4uksMJFYIU6
MNrW0E3rEnoWenE9/0Mi4lh0NIJivG/HXReIlzvmY4WrV7v3V1jgdo6MsR7Hca2u
mfb6dC+skG7KN952hmyo+NB4aO9xIS/3GNnUpJpWmhyf70ChnYjwd0B0gWygN8hz
KF/bY1ppwd/rIdishdFL5VhJRsbhdLjLsThU+kkJO6rTItn3LS+9xXgbhh/0s4aZ
UHJBHeehA7CGUXXey8edDnKXF9MPck+omL8ATzBU/cvx5yFVx35RQtU8sObvcBNt
KdmbdV6vU4+deWwsjSDv1LBWgR1yJoyqTf2IBAbnElSTjidvuWRl/jKBC5N5JBjr
UC32jzA5OaxV6LvhDuOSxYdRZ+ps706+hbojZf+QzEz9BIhxF0oCqRlvFMXLyYaS
cO0ns6JNtiGiTIz3oP3aE6+bXmSyPwO919XvxmsUNEVh0XHT2zyWSix25Xg7ZDn5
ONs6rKZurSb5jXz7GPLH2YiNCcu6CdBrmU2vSqoX0F/TA+1e6WVEwrUdjWIiAdtN
F9/8Now0yDDmtNjq85/3In1mJrXNTgU2jym+Dfvi/A9rfeDg/MfLuNCI30SA92ju
w91PvcYe6oUsqwNDff8Ui2dIUun+0Md2X7iqdALwhqUGZDX3rAto2XXO/gaecxFB
Y+ooSbg2b5gF6B/60jBi
=Y14b
-----END PGP SIGNATURE-----
--=-=-=--
