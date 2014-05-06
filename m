Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbaEFNZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:25:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:60925 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbaEFNZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:25:22 -0400
Date: Tue, 6 May 2014 15:25:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Preeti Murthy <preeti.lkml@gmail.com>, umgwanakikbuti@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Ingo Molnar <mingo@kernel.org>, george.mccollister@gmail.com,
        ktkhai@parallels.com, Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC/TEST] sched: make sync affine wakeups work
Message-ID: <20140506132516.GJ11096@twins.programming.kicks-ass.net>
References: <20140502004237.79dd3de6@annuminas.surriel.com>
 <1399011219.5233.55.camel@marge.simpson.net>
 <53633B81.1080403@redhat.com>
 <CAM4v1pPwe4B0K8MPpf183LqabRoRKRPi_R7n8-Y02aR43M8iQQ@mail.gmail.com>
 <53663565.9080306@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mjrw6G9AoRBv8oQK"
Content-Disposition: inline
In-Reply-To: <53663565.9080306@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mjrw6G9AoRBv8oQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 04, 2014 at 08:41:09AM -0400, Rik van Riel wrote:
> Even on 8-node DL980 systems, the NUMA distance in the
> SLIT table is less than RECLAIM_DISTANCE, and we will
> do wake_affine across the entire system.

Yeah, so the problem is that (AFAIK) ACPI doesn't actually specify a
metric for the SLIT distance. This (in as far as BIOS people would care
to stick to specs anyhow) has lead to the 'fun' situation where BIOS
engineers tweak SLIT table values to make OSes behave as they thing it
should.

So if the BIOS engineer finds that this system should have <
RECLAIM_DISTANCE it will simply make the table such that the max SLIT
value is below that.

And yes, I've seen this :-(

--mjrw6G9AoRBv8oQK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTaOK7AAoJEHZH4aRLwOS6POQP/RYEAOLSE+6n+YvhuKQS+DNg
FWtX5DBd+dQohIY3i3Bmj5Z+YGWaZePHzxp6N/fxwN9B6q6uBlMtM+CmrH7Z8HfX
rOWvv8eFXaxE1r1+5qqpzXeyE8eAxF5ydagElgOcYg3rPY+SCxxH7hUKUKGBRqMA
y8BHpDCK7hfas3LLARCqyCY6SHEMjTlmXtO2L7c9s4sxYHrcSayoBp96eA4WTnGD
vCBTuOl7fommuQEHegZtaumNlrgql2M6yI+b3SvSRz3C5gJeCQ8NO5EdYE9cqMwF
p3x3A6Bi4skL5vIIW5I3xWGVDIGelJOUgZRy+CsMvs+3+Vf3ff+5Kho2xKr8kCUq
TJ+Sp8j9TpFabeI7wg37ExLzMSx2ogF8ep1eAjvVecdcAnjCAS7xN12pCzzShNIz
0EVoat0pPlM6s7jVEmcLCAUXJY0yOHzfK4irvj+qguM9a/0JRjKgWakljV+yHbyP
Kq4wJsYzUrPPSotTVkeY4K1W9sJ7/JZGpaBO2RAML1Xw5EiniYQUTv+3n5x3qlYj
rmaw9aZawp1Q+TMZzOsEfixuy6AXvnsYHYnKWrDe3S3/uOIsXW/4tEHTViwfeWVk
xkNK4dCCi+w8UJUYs9/m6TvCkDx67kL6dRF9Qwz6jCTHnfyajuwT1N/fUhT7PORF
7Pg9jznAbLGKB/nn6Tqu
=o3Dc
-----END PGP SIGNATURE-----

--mjrw6G9AoRBv8oQK--
