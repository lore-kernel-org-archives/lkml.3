Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbaGGJNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 05:13:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:48817 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaGGJNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 05:13:17 -0400
Date: Mon, 7 Jul 2014 11:13:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Christopher Covington <cov@codeaurora.org>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RFC: perf: Make overflow signals inheritable
Message-ID: <20140707091308.GH6758@twins.programming.kicks-ass.net>
References: <1403727129-20665-1-git-send-email-cov@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3wDDcJ525A5nbDoJ"
Content-Disposition: inline
In-Reply-To: <1403727129-20665-1-git-send-email-cov@codeaurora.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3wDDcJ525A5nbDoJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 25, 2014 at 04:12:09PM -0400, Christopher Covington wrote:
> In order to get a signal from the perf events framework (use an
> "event_limit"), one must not not only call perf_event_open() with the
> appropriate sample_period, watermark, and wakeup_watermark values,
> but also set the FASYNC flag on the resulting file descriptor with
> fcntl().=20

Tell me more; why are you wanting this?

> If the inherit attribute is also set, one would expect child
> tasks to cause signals like their parents. They don't, though,
> because their FASYNC setting isn't set (and can't be by the user
> since only the parent has a file descriptor). To fix this, allow the
> parent's FASYNC value to be passed along to child events when the
> inherit attribute is set. Overflow counts are still per process and
> per CPU.

There's more issues though; the comment you deleted isn't explicit about
this (it maybe should have been).

This would mean the inherited children would get signals; they might not
be expecting them.

When they do get a signal, they should be calling IOC_REFRESH to re-arm
the signal, but that explicitly doesn't work for inherited events. Which
leads me to believe you didn't actually test this.

--3wDDcJ525A5nbDoJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTumSkAAoJEHZH4aRLwOS678oP/i9FXC2S/2Jt/cy5QFe1vmX1
LaWXMjWbvwYC1YvtAJ6RllPzTp3LjXC39pXQKrFeGSZJe5tShdPdmhTE2rcaqqzz
Ym/LUV3/dgYfFJS6IbNg39RFF4RsImssdfi4fGBTFvaU4pjnIPnm4nk3Bj2jUu56
QcKm/AAQ2hisMmG3dyvzOLdcI8UO7wkbW+5nZnxuJ6wo4F7lvZ0S4VHkTA14xnUP
Jgyi+pUz1LsBvfA7Se5E+A4eRP6VY86wdMZl0SvjIu5b3koI7jPAycxxVQQ7KQME
nKxo/vcGd2ivxEbIsXZ5/BybI6e0Eh4/ieAs63YYePqCgNEpZY0c8kv/0khkYImK
piNNWsneBlLnq7NbiEZfMTOx5eq+4N73xBwwRsV0zDZURxLCyllG2TmwaNYZrp6l
k9dmmMtl8CwSrrOm8T4gSvuvbBuuUQ2KHXumT66f5/EtMn//7qaI7e+ilpszts9T
7FnPiq1peBymn/HyIkQF8sG3BMBzRJxqyb3TxBptCv+vKKn7cAqVFTFDZd0q9bGF
L2fgEgCCE0LLmjTAuL2sk8sjyJHOLz6PDLnUX74b38WbaaKy71XJWXD0foYjIMMw
qAlGGf6URjxKb07urc+AVpLHjj5VHXO43nM5IbvWhiSCl5e5uV+psfX+U5MOpQZU
6Xu6YuZ9gU+ETHiSny8d
=mBC2
-----END PGP SIGNATURE-----

--3wDDcJ525A5nbDoJ--
