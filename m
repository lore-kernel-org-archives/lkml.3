Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbaEGRfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 13:35:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:39516 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaEGRfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 13:35:37 -0400
Date: Wed, 7 May 2014 19:35:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH v3 2/3] perf record: Propagate exit status of a command
 line workload
Message-ID: <20140507173532.GV30445@twins.programming.kicks-ass.net>
References: <1398346054-3322-1-git-send-email-namhyung@kernel.org>
 <1398346054-3322-2-git-send-email-namhyung@kernel.org>
 <20140429105654.GB1148@krava.brq.redhat.com>
 <20140429111939.GP11096@twins.programming.kicks-ass.net>
 <20140429113747.GD1148@krava.brq.redhat.com>
 <87tx9boeaf.fsf@sejong.aot.lge.com>
 <20140507150404.GO30445@twins.programming.kicks-ass.net>
 <CABPqkBTC-MjMB0U0+NjqrdKFFuoQt-N7MZJikcbcWJpLLgVRRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K4LMwn8CgX2KMboP"
Content-Disposition: inline
In-Reply-To: <CABPqkBTC-MjMB0U0+NjqrdKFFuoQt-N7MZJikcbcWJpLLgVRRg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K4LMwn8CgX2KMboP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 07, 2014 at 07:19:14PM +0200, Stephane Eranian wrote:
> > $ while :; do ./foo /bin/sleep 5 ; done
> >
> > and try and break out using ^C
> >
> What I usually do here is hit ^Z, then kill the job.
> But I agree it would be nicer to handle this case automatically.

So that used to work. And note that if you take out the signal(SIGINT,
SIG_IGN) from the proglet, it will actually propagate the SIGINT and
work as expected.

So its only because perf handles SIGINT -- to be able to finish the
stat/data record, that it doesn't. Which is why I propagated the signal
the child got killed with.

Now apparently someone broke that again.

--K4LMwn8CgX2KMboP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTam7kAAoJEHZH4aRLwOS6ZbkQAKJCOUGeU2YE8Dzi3Zy8oano
qFAMgp4c30ftEGcaitP/hlZFlEtXBaSTIMuI671rxWTDs3SXBqFdb+bwwLdHJcaF
p2HkgoTi6WTTIUO7oSeF5hV5BWcwkQpc4je5mdjslZ0XnG7b3DNZZLHn0jmCNquJ
02rz04QmBOgZeHA3O2SirPSw33Ygp14AuOQuIcF8Fd8nNlqegv207D5qs6PTWokD
6v5G65IjJvZlkxQv+0mXUvFu2jRi99+dS7a7oHDc120nD8mkzBq79vgGthx8X9G/
gi0QyKgHqmqPrVdA6SXn/cUQ/t4OGb+alcZSpqP3KMhufwV3cfzQu3uDtP168NKc
+0vW/UtsP4tM7jrv0mQywkMf9imo16YR14ZtufQ2GqdGyNxlXG/8YHynqA7BxzlV
Vbm8CVTz8ZQHqKjEcZAYgn9RSpxCi4VMXHy70JbDHCj6Lwuwyxip4lETAjFHF5xF
twGEG6JxZkNJHRRmcLp/C7w7wwc94P37fO1QsNNCD39RWFZvNgkFTXfP9+h1uKdQ
QLEEFdLVTdKo2DpWqAxAY6ehwx5YBIryTc7D7rvEFSdzft5uue/RGJvXFR520iG0
n+gRxDrSA43Xs3RtbhfsP6ct2CqOvuNjC/vwk8uGR+hv2DJtrxh4HG9a5PsEDCzW
D374Gto5l7EunTtDI9ip
=XOSr
-----END PGP SIGNATURE-----

--K4LMwn8CgX2KMboP--
