Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbaGNNvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:51:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47276 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272AbaGNNvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:51:23 -0400
Date: Mon, 14 Jul 2014 15:51:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH v3 08/12] sched: move cfs task on a CPU with higher
 capacity
Message-ID: <20140714135106.GZ19379@twins.programming.kicks-ass.net>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
 <1404144343-18720-9-git-send-email-vincent.guittot@linaro.org>
 <20140710111833.GY3935@laptop>
 <CAKfTPtD=TiURcppZ+oVUmhMf6Ofxbp4BPA0SCFViu0SDb05oRw@mail.gmail.com>
 <20140711145138.GC3935@laptop>
 <CAKfTPtCdd6uR_qBuW2W4asMgEV=OfsNvrOCVQCci+w3C8RAoCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gwj7ZfuSpvxprVSd"
Content-Disposition: inline
In-Reply-To: <CAKfTPtCdd6uR_qBuW2W4asMgEV=OfsNvrOCVQCci+w3C8RAoCQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gwj7ZfuSpvxprVSd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2014 at 05:17:44PM +0200, Vincent Guittot wrote:
> > In any case, its feels rather arbitrary to me. What about machines where
> > there's no cache sharing at all (the traditional SMP systems). This
> > thing you're trying to do still seems to make sense there.
>=20
> ok, I thought that traditional SMP systems have this flag set at core
> level.=20

Yeah, with 1 core, so its effectively disabled.

> I mean ARM platforms have the flag for CPUs in the same cluster
> (which include current ARM SMP system) and the corei7 of my laptop has
> the flag at the cores level.

So I can see 'small' parts reducing shared caches in order to improve
idle performance.

The point being that LLC seems a somewhat arbitrary measure for this.

Can we try and see what happens if you remove the limit. Its always best
to try the simpler things first and only make it more complex if we have
to.

--gwj7ZfuSpvxprVSd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTw+BKAAoJEHZH4aRLwOS60K8P/RepPIpuAO5/UYo2sz9cAG85
vBXXmfIbf2YhDF7h2UWZ2xpzvN3ql3UfqUbGj6S6I2P2LDST9HcEUXB0/G/VPZQ+
N6IsuK2pMR5ncizZwTB4B412Ch0bYxkYW3AYBOzQdWbtaMtRA2S7BmDWoB1/5M2o
edWdFRe3gpU9wAgtAIvDo3lnWF5FRjZmFy9br/NHcUC36KgXyplTX53dueHL047F
2kMf5PCxJ1FkiuqAvPkWE9qcRyO7Gz0c8BstP8/Ytdp2y4iSjgtbieHAsmkfmPn7
Ob3TWLV0af9unx1YTXVnEzhFeJoqsCgoXE2rEqOmQKRRW4O9puo0l6tlB8Nr+/tn
OkTjQyxJNSz3Wc61uvb/KFCMpB2km2wkId/G8/6ZCfcjkUzXnI3t5htW5RUCVT7r
OWYk4pIjZhrMLhN+MaWXkaeSdWUV4G5YqS4DieRlD/aT0//JCc41Noe7+KuWbBh/
Jir/SO6PVEC9C4/TGMqj3S1JMLMnYvvpNbNTJW+amw8AZ9qpx6uX7mJ/kDblOZFh
UOxtnZ3AQh/GhP/Kh+Eoxf0slWOcg38TphD8wh1ADhSTlbdppAa/5FxNa7f0EUKR
Oj06VidiOl2Wx6pTVQo7jvqHAckUyb1eoaT4QDnwNq/YG80h0HzSc4je1TktkEG7
kVN3NOc4NDYqnkslyN4q
=0/7X
-----END PGP SIGNATURE-----

--gwj7ZfuSpvxprVSd--
