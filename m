Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbaGGPYB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:24:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:50397 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbaGGPX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:23:58 -0400
Date: Mon, 7 Jul 2014 17:23:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Waiman.Long@hp.com, tglx@linutronix.de, mingo@kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, paulmck@linux.vnet.ibm.com,
        riel@redhat.com, torvalds@linux-foundation.org,
        david.vrabel@citrix.com, oleg@redhat.com, gleb@redhat.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Subject: Re: [PATCH 11/11] qspinlock, kvm: Add paravirt support
Message-ID: <20140707152350.GW6758@twins.programming.kicks-ass.net>
References: <20140615124657.264658593@chello.nl>
 <20140615130154.400698797@chello.nl>
 <53A70602.8020000@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="le3rj4S+jilWgWjH"
Content-Disposition: inline
In-Reply-To: <53A70602.8020000@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--le3rj4S+jilWgWjH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 22, 2014 at 10:06:18PM +0530, Raghavendra K T wrote:
> On 06/15/2014 06:17 PM, Peter Zijlstra wrote:
> >Signed-off-by: Peter Zijlstra<peterz@infradead.org>
> >---
> [...]
> >+
> >+void kvm_wait(int *ptr, int val)
> >+{
> >+	unsigned long flags;
> >+
> >+	if (in_nmi())
> >+		return;
> >+
> >+	/*
> >+	 * Make sure an interrupt handler can't upset things in a
> >+	 * partially setup state.
> >+	 */
>=20
> I am seeing hang with even 2 cpu guest (with patches on top of 3.15-rc6 ).
> looking further with gdb I see one cpu is stuck with native_halt with
> slowpath flag(_Q_LOCKED_SLOW) set when it was called.

Like said in 0/n I think, I only booted the kernel in kvm, didn't
actually do anything with it.

It took me most of the day to figure out how to get paravirt working at
all, didn't feel like spending another many hours trying to figure out
how to make the crap thing do actual work.

But I'll see what I can do after we can 'conceptually' agree on the
paravirt patch.

--le3rj4S+jilWgWjH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTuruGAAoJEHZH4aRLwOS67I4QAIcJ86JFQTzlVTnDFdzCM8es
Xe06S3HLj1KAVhYTDjpIbcI41zKR6NAu5vtnyU6sFTJIfOK9sUaIzQ8KMxEZQxWe
uuhKhfeVjPSJ1Yxm+Itv1KHCwzIbF91PlvmgB2GIloF3vfJ8AgvdMZlanWrrseC+
R+zgYDA0Sov39tZ3YGAZydD/tdy9nXABUcFLMngGJpf0QU2VftTMgVPeJYs2dUGf
nDTSoAfAtRw1HIJsrLiyX2llQjtbQXhk5EC0nzq5ZuLy7x6eNug4bd6AYy16WQO5
jLKEe0ulTLaGTwZVgnqpSPnqpliwmP++4HlxbT2tMN3sEaNxrjJC3WsZElZJcCMA
YkArNQaIi144RH1KK6kOaZyxbto983ffBJGs0qp80mhPS27DbqAANvKzNmpqT9tJ
5hGNIMOO2JI0/gIWEcQynz69yD+X2iAzkNYMwi51g1khE+PSC1S5iQxhVMj6aYNc
RWtzJrPHKGv1TbdXZG/nDv8KdNZyhJR5u1K2vZK8JcD4+qHyIpM2XF9GhtgTF58X
1knzEbqG31fk6SbnvqCjG+upb+UkybxmXpGphaT+KPuQ/r24yRuHUV5ZikFbaggR
Be6ZeyrqLMoC9/NCBNMMx+mOyHRNP3yrjdsAySXuiVD+7OCX+8UtBYbBjV2diL3D
YGPdmLAD8N5s2iyw5OLJ
=Q7O/
-----END PGP SIGNATURE-----

--le3rj4S+jilWgWjH--
