Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab3KUEZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 23:25:07 -0500
Received: from dspam.tip.net.au ([203.10.76.12]:39746 "EHLO members.tip.net.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750827Ab3KUEZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 23:25:04 -0500
Date: Thu, 21 Nov 2013 15:24:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>, linux-aio@kvack.org,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [GIT PULL] direct IO support for loop driver
Message-Id: <20131121152453.056a6417df2f342d898864ad@canb.auug.org.au>
In-Reply-To: <528D3BCE.2060703@oracle.com>
References: <528A648F.1030007@oracle.com>
	<CA+55aFyF-Za7B=1kVDodbn942hETsWixAHCsh_wBA1b6pnUigQ@mail.gmail.com>
	<CA+55aFwgGg2yzoUukVuAz2Feo4kU4=8CNBGY7phUHGSBDt8xwA@mail.gmail.com>
	<528D3BCE.2060703@oracle.com>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__21_Nov_2013_15_24_53_+1100_3B0zM8IlZpb5T4Iu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Nov_2013_15_24_53_+1100_3B0zM8IlZpb5T4Iu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 20 Nov 2013 16:46:38 -0600 Dave Kleikamp <dave.kleikamp@oracle.com>=
 wrote:
>
> Yeah, I'll work on something cleaner. The vital piece is some container
> that can either contain an iovec or or an array of kernel pages to be
> passed to the filesystems. The iov_iter structure was a reasonable
> choice, but the implementation is a bit sloppy. Kent wants to pass the
> bio structure itself, while this patchset used the biovec array. As long
> as I'm reworking the patchset, I'll see if I can accommodate his
> requirements.

So given this rework, I think I should drop the aio-direct tree from
linux-next for now.  We can add it back (hopefully with a better name)
when the rewrite is in a reasonable state.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__21_Nov_2013_15_24_53_+1100_3B0zM8IlZpb5T4Iu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSjYsaAAoJEMDTa8Ir7ZwV3N8P/0s5K4k/s6/fR8vuMBeQ6OvU
EBs8sC7SURrsttRziM1C2DT40xuwPcpIL4u1Mij3jbKhHiu3NlPhEspimYdO5YLm
dIRXVBAZAO1DeM2aYDkOMArhZgo9bJBfaLPZHsbekhnExvNMNVFze8XoQjcSd35B
CO1UWObY48+CuvQ1fLxtcdOxPsYrDbZwh3nXepJw2dIylF55jscu0gbWIUpirwwL
NCsHEdTMFntaEy1jBIMgu6HHCz4hphSrq3d4REuHo0MkgwZMU5HCh6A4wDQLUo8+
rUGfWBZtNy0iKkmQ4dBo79l7C3e8yhbeiEL5+dV6iJFf7delY/JzLorhMmJrJXyR
4ckNMLLJmXD7uv1MDtRaDCGYNRjWKTeXzaOXawl5wvG4q/njp7mBUj4gN220eAZ9
CexTGlfm6vlaU9nd3wuCbNUfeae7/pT5rbfXe/PzPjL1IKXMBqC+aH5hcj3J/yZa
Zg8p6w7nNRefe1nKfSklx5E8t1NC+lAsLOIffueDsJL4+MtOYPW6DWui39oFRd/f
xikwrVwXic01pySjku4KP1BwuW1rtn9hilNwd5gOJFtL2XQRR5mqk4ZXdhykD9GR
JOmMxq5Lr4fIDePSJVAFZatnIGVOAt9n8417/VrtxZQg+YVGZHV0Bh8QparvkIID
wsOQhP71JFDJZA0DtoXi
=ivSB
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Nov_2013_15_24_53_+1100_3B0zM8IlZpb5T4Iu--
