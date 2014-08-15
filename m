Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbaHOG2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 02:28:40 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55939 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaHOG2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 02:28:39 -0400
Date: Fri, 15 Aug 2014 08:28:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH RFC] time,signal: protect resource use statistics with
 seqlock
Message-ID: <20140815062819.GY19379@twins.programming.kicks-ass.net>
References: <53EA94DD.5040900@redhat.com>
 <20140813172230.GA6296@redhat.com>
 <20140813133526.1eb5526f@cuia.bos.redhat.com>
 <20140813180807.GA8098@redhat.com>
 <53EBADB1.2020403@redhat.com>
 <20140813184511.GA9663@redhat.com>
 <20140813170324.544aaf2d@cuia.bos.redhat.com>
 <20140814132239.GA24465@redhat.com>
 <20140814174849.GA5091@redhat.com>
 <1408079971.5536.37.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="316gXmQqBlehv1j9"
Content-Disposition: inline
In-Reply-To: <1408079971.5536.37.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--316gXmQqBlehv1j9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 15, 2014 at 07:19:31AM +0200, Mike Galbraith wrote:
> For the N threads doing this on N cores case, seems rq->lock hammering
> will still be a source of major box wide pain.  Is there any correctness
> reason to add up unaccounted ->on_cpu beans, or is that just value
> added? =20

That delta can be arbitrarily large with nohz_full. And without
nohz_full the error is nr_cpus*TICK_NSEC, which I bet is larger than the
reported clock resolution.

Having a non-constant error bound is annoying for you never quite know
what to expect.

Also; why do we care about PROCESS_CPUTIME? People should really not use
it. What are the 'valid' usecases you guys care about?

--316gXmQqBlehv1j9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT7aiDAAoJEHZH4aRLwOS6vnEP/1sC2CQvMPa86tXhppFwpMgg
Pc9sg+cmdp2Ozlg/UIr+lOhZTDcDSXuZ7oLvYTIoTPAilEzvI8ZKB6af2LFnHqiD
QrMgbchBhp/wN+2+yQD+eAoxj7Ekd+R6+nf9wMrFAly5PttvlRusaMBmMOHvVxix
ljpvgr4MyUSRf0Dh2d9ptMbrFyh7PHXrz15R26GFV1NAoz/18UcYwuBvGwVHsrwB
odRh4wcxkS47tRf8Neqp8B8Mghk+n4B49afVclmz2d4g5sbYA6Ci+f695ltJl/wP
C/HHnAuJvfWbhvlbXB6n/c6hi/hbl0vCXwaj+Q/Zta/3B27OaDCIZew2B7B5NgfU
pM/++igptVnqbpUK9QDnQLzooik9YEbhoGPwVqRXHjTKroFW8F7cYZPUU/KmOfza
mR9eOcAlYQdbhZkp3eyH+b9hI1DwQwJ2MDsjZs+Hzht56zCZgfOVBGeHIXC9Vpnl
eHlmBGUkhmUwKoSvJZYT6idWJ0+3IJ2pjXhUFAKscDZg4obKXtZL8c1xez13XL/5
Vs5uAqgVVsKUHyJWt7ZZlXR0+jEbN57gEzRo7tTEU47wvf+MC7nymceL4KuoYVf4
lg12fL5tLOWy/Eg6ayfLIaNzKtGJvHLzwwFBHlVF29UD7i3hFB8+Q3Yin50XmPfg
gGPLEFuHS/JkbPebIl7Y
=/WAf
-----END PGP SIGNATURE-----

--316gXmQqBlehv1j9--
