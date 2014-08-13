Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbaHMRxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 13:53:45 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54568 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbaHMRxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 13:53:43 -0400
Date: Wed, 13 Aug 2014 19:53:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH RFC] time: drop do_sys_times spinlock
Message-ID: <20140813175328.GY9918@twins.programming.kicks-ass.net>
References: <20140812142539.01851e52@annuminas.surriel.com>
 <20140812191218.GA15210@redhat.com>
 <53EA94DD.5040900@redhat.com>
 <20140813172230.GA6296@redhat.com>
 <20140813174048.GV9918@twins.programming.kicks-ass.net>
 <53EBA560.8030404@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tWQUY0ZOa68uKY24"
Content-Disposition: inline
In-Reply-To: <53EBA560.8030404@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tWQUY0ZOa68uKY24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2014 at 01:50:24PM -0400, Rik van Riel wrote:
> On 08/13/2014 01:40 PM, Peter Zijlstra wrote:
>=20
> > So the problem with the above is the lack of fwd progress; if
> > there's enough clone()/exit() happening in the thread group (and
> > the more CPUs the more possible), we'll keep repeating.
>=20
> We can fall back to taking the lock if we circle around,
> or if there is a writer active when we are in seqcount_read,
> similar to what the semaphore (ipc/sem.c) code is doing.
>=20
> read_seqbegin_or_lock would do the trick...

Yep that would work.

--tWQUY0ZOa68uKY24
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT66YYAAoJEHZH4aRLwOS6lqUP/iiaejELVXnt8tVDbPNUnaQw
liucjE6dYyBskNmuU/BDo5HwmiwqsvtcIB3FdiSK9QQVonGumZxMvy0+bOLHiNeX
ogUqz8xBbzxNSzY9IwNwmlECbI56NkaGJCGy2O0Ui0FDGbrsxbpw6vqCKgB5Qbz1
grnG5JJEo+HLfWbIi3Rcs1weeal+M/8AvmF4PYEqnb+mYxKp7u6PuCFQktUlNX5s
+rjPyP1wSzV2hEGJN9RJDrO+ixmjlpgMm6q5cnRncAY4a8SzZZG/XBI1S7IaUeSe
cnk1WXlk0heXIcAGIMRA1MncFdkk94E5Sznm+1e9ZPVKK1v0k/TyEjxXwOJPFqf3
xcho8lPGW173xM3e3WmhnYXkNseGNvffbHthwG2cEmeN8F+QySmDsuGPtiyXCZuE
Qo6NW3YtdMVljs2drHG99sP/Z9XbNexVxQukBn8G8+iH0JaZQ+MuClsZMaDmmVx9
vlMZBDK5WsNa6GayvIYnrV/GIzrCDc7UN46BHEA/gNBVETwoc6kHJPdz83IgMhB7
ZdaKpLx1v8XagIARWAuJHeAS2dG/ZWLNw2/MVQEnutoy7YtyqZJ6sOMwbSxI7+ee
8Y8kBMaa59SO8xH6Q4kLI315xQWJo+9ubIfBSFvBT4hF7y4U5tvdNIOc/bA4i8UJ
nuBD1NwLQpD5SZA8NcjZ
=MINk
-----END PGP SIGNATURE-----

--tWQUY0ZOa68uKY24--
