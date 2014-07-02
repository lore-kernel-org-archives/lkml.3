Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbaGBQ2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:28:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:33306 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbaGBQ17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:27:59 -0400
Date: Wed, 2 Jul 2014 18:27:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        mingo@kernel.org, Waiman.Long@hp.com, davidlohr@hp.com,
        linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, hpa@zytor.com, andi@firstfloor.org,
        James.Bottomley@hansenpartnership.com, rostedt@goodmis.org,
        tim.c.chen@linux.intel.com, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [RFC] Cancellable MCS spinlock rework
Message-ID: <20140702162749.GP19379@twins.programming.kicks-ass.net>
References: <1404318070-2856-1-git-send-email-jason.low2@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6o78gXsyQHm68LY/"
Content-Disposition: inline
In-Reply-To: <1404318070-2856-1-git-send-email-jason.low2@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6o78gXsyQHm68LY/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 02, 2014 at 09:21:10AM -0700, Jason Low wrote:
> The cancellable MCS spinlock is currently used to queue threads that are
> doing optimistic spinning. It uses per-cpu nodes, where a thread obtaining
> the lock would access and queue the local node corresponding to the CPU t=
hat
> it's running on. Currently, the cancellable MCS lock is implemented by us=
ing
> pointers to these nodes.
>=20
> In this RFC patch, instead of operating on pointers to the per-cpu nodes,=
 we
> store the CPU numbers in which the per-cpu nodes correspond to in atomic_=
t.
> A similar concept is used with the qspinlock.
>=20
> We add 1 to the CPU number to retrive an "encoded value" representing the=
 node
> of that CPU. By doing this, 0 can represent "no CPU", which allows us to
> keep the simple "if (CPU)" and "if (!CPU)" checks. In this patch, the nex=
t and
> prev pointers in each node were also modified to store encoded CPU values.
>=20
> By operating on the CPU # of the nodes using atomic_t instead of pointers
> to those nodes, this can reduce the overhead of the cancellable MCS spinl=
ock
> by 32 bits (on 64 bit systems).

Still struggling to figure out why you did this.



--6o78gXsyQHm68LY/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTtDMFAAoJEHZH4aRLwOS6TsEP/1AS89ZXstQ0Nzd7AyFYin/u
hEnS9lH7cOR1qR8bvxmsa+wyLE3gjq9SRgMS1cwfmoFQV/cQ3wSK/MHvfhw/6Gho
O96myUUtOueNx6J8zjKsGK9uVVYjbXbM+1D29DpVcmhYGhz8FeLYv12X9tRuZNB8
AExK7G83e5QiFrLFKvKmuMssh9Ca3QOstCoC65zNHfYT9xxDtCDgYVsquIeMtyTF
QLAPrR1Sow6Nx2QE4xsNqs/jt99tdqDr/AGLi/OrobNwMYPdkrCGznz5lgNFw+pU
bNmI76GCF7dsXFrXpZoAvy+GRqlTJASxoqd7epStY7GWDx4S+Vxn6RlqqiBUO3S2
eZjqs3DO/lv4OlQ4pUXdTXeQP6RArQWzhrR3+YxfnzpZ3Vpkyc4tDaAfl4jwvO9v
IclLutxjo3SpYiBbWbQ4wwUMVwRniXzqjJCP2rffT3f5E3MQ8EWwIICRWHFI+gwf
YjZgFZwffVcz8J+4iGeBeVVlV2vhpkaAVsxXyY7DYK9H7SXpFODIwN5DxZsfrw4s
n9+z83l3nU5358lOA0zkw/cSMcOoJAstDFug1I+J+J9JUdhjDYmxlPypSANFit9x
2qYVUvWo6n9ly6T+zBOkY1CKhTl9GP4WMPpk9IwhmFNpwE8N5l3CLYgsAfR51a8Y
fvintNW4BIrzal/7oj2I
=31Ip
-----END PGP SIGNATURE-----

--6o78gXsyQHm68LY/--
