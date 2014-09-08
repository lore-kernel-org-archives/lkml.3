Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbaIHLbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 07:31:41 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57109 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbaIHLbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 07:31:39 -0400
Date: Mon, 8 Sep 2014 13:31:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com
Subject: Re: [PATCH v4 04/22] perf: Add a capability for AUX_NO_SG pmus to do
 software double buffering
Message-ID: <20140908113129.GC6758@twins.programming.kicks-ass.net>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1408538179-792-5-git-send-email-alexander.shishkin@linux.intel.com>
 <20140908071712.GT19379@twins.programming.kicks-ass.net>
 <87oauqv09h.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gLeD4uI0NkB0GjLy"
Content-Disposition: inline
In-Reply-To: <87oauqv09h.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gLeD4uI0NkB0GjLy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 08, 2014 at 02:07:22PM +0300, Alexander Shishkin wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> > In particular this looks like it will allocate double the total amount
> > of pages and 'loose' half of them. There is no corresponding code in the
> > free path to collect them.
>=20
> This code makes the biggest high order allocation no bigger than half of
> the total requested size. Then, when I allocate the high-order chunks, I
> do a split_page() on them and everywhere else in the code they are
> treated as individual pages, including the free path. So this patch has
> no implication on freeing. Is this your concern?

Ah right. I completely misread the patch. Sorry for the noise.

--gLeD4uI0NkB0GjLy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDZORAAoJEHZH4aRLwOS6elcP/3T36PwZYOwc5erdEMQ/0KuE
J3LiQfx395cCF8/+KJ+GkxNLlsorTjeJXAKhx1PXxO5Zlh+M9xlVJhdKxrqZXC/s
5YbpMshURdCsJQhmcHrehJg4J6aRNDSelRP+wbcxMimrxD3maS0T+Uvcot7SfHk7
2PHvrCw6Mp10P6Us4pIJ2hAbXbA9cOic0lPsv0RRsFWPsFU+0pPBSyTMWQLmuPY+
l0YCuSi5HKzW2k7xN7WowKuN5AZcgyosByDbevx8US5rQilJkm0lvlHolmdfJlsu
+FnB2GDcRQPX2PJ/Myh/nEakcs5dBBc0wz1gtfY1UnYGlHf4XRXfKu2hK9txggt+
trFFAzCHNbAcwwC5hi9KcoQEpp5REi46ZcDEXhweFZC09a9tC5dPofQa2guyu1FG
CLJlKWEjJ8M1B4daKW0DuKFttfGjLLRRmwb5mRl6gkV6shiuyyGhK6h5/CZb2iG6
3EKYHJGdcWDTP0scrz+cB8RzTOBqV8zuemBFYDzqHnrjrdZpzaT/TkH6VXLla827
uJ3RBBuIXL/dyRAdLBsxa+q4LNFQsdtPP90WxK09JxtRk2ARe7HAwp968Ks1rQCv
TgUlzmkjmR6ZBJhjAeVqeUQMzD8LzWyrGEQNUKQLFoQinubI/9zwU5RtV6picR/7
J6N2CW2SqvPVONZTXVTO
=9E+k
-----END PGP SIGNATURE-----

--gLeD4uI0NkB0GjLy--
