Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbaE3MEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 08:04:37 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34399 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbaE3MEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 08:04:36 -0400
Date: Fri, 30 May 2014 14:04:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, mingo@kernel.org,
        rjw@rjwysocki.net, vincent.guittot@linaro.org,
        daniel.lezcano@linaro.org, preeti@linux.vnet.ibm.com,
        dietmar.eggemann@arm.com
Subject: Re: [RFC PATCH 06/16] arm: topology: Define TC2 sched energy and
 provide it to scheduler
Message-ID: <20140530120424.GD30445@twins.programming.kicks-ass.net>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
 <1400869003-27769-7-git-send-email-morten.rasmussen@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WXBLDYRe6ft2Yf8u"
Content-Disposition: inline
In-Reply-To: <1400869003-27769-7-git-send-email-morten.rasmussen@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WXBLDYRe6ft2Yf8u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 23, 2014 at 07:16:33PM +0100, Morten Rasmussen wrote:
> +static struct capacity_state cap_states_cluster_a7[] = {
> +	/* Cluster only power */
> +	 { .cap =  358, .power = 2967, }, /*  350 MHz */
> +	 { .cap =  410, .power = 2792, }, /*  400 MHz */
> +	 { .cap =  512, .power = 2810, }, /*  500 MHz */
> +	 { .cap =  614, .power = 2815, }, /*  600 MHz */
> +	 { .cap =  717, .power = 2919, }, /*  700 MHz */
> +	 { .cap =  819, .power = 2847, }, /*  800 MHz */
> +	 { .cap =  922, .power = 3917, }, /*  900 MHz */
> +	 { .cap = 1024, .power = 4905, }, /* 1000 MHz */
> +	};

> +static struct capacity_state cap_states_core_a7[] = {
> +	/* Power per cpu */
> +	 { .cap =  358, .power =  187, }, /*  350 MHz */
> +	 { .cap =  410, .power =  275, }, /*  400 MHz */
> +	 { .cap =  512, .power =  334, }, /*  500 MHz */
> +	 { .cap =  614, .power =  407, }, /*  600 MHz */
> +	 { .cap =  717, .power =  447, }, /*  700 MHz */
> +	 { .cap =  819, .power =  549, }, /*  800 MHz */
> +	 { .cap =  922, .power =  761, }, /*  900 MHz */
> +	 { .cap = 1024, .power = 1024, }, /* 1000 MHz */
> +	};

Talk to me about this core vs cluster thing.

Why would an architecture have multiple energy domains like this?

That is, if a cpu can set P states per core, why does it need a cluster
wide thing.

Also, in general, why would we need to walk the domain tree all the way
up, typically I would expect to stop walking once we've covered the two
cpu's we're interested in, because above that nothing changes.

--WXBLDYRe6ft2Yf8u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTiHPDAAoJEHZH4aRLwOS6tucP/iTuckKfdc9mkECvulMrjk2h
n71ZRVb3E0AOGt+NW4Q+vuoASjq9WrN4ChyQujGHNAFWvipVqGB6lQ+xtLNG/KXe
kDaNncVY2tzqIHSqArD8biAztD/PljYos+7L5kl2ZUvkJaU0AiEBlo4yfHyf/WKN
PVw/ZkwlvY/jhK4DvJu0SCPLHVw/iSMlDrBhbb69vpWT1ATIzWNXOXa4BoYgMIDm
B6zm1VnTAngRKwUsACYx0ZGKo1qZiNVyyKIZDhxf5lWYT/Sdv+U3MYtLaqKbuX7W
nTmHiLMiTKh2aPFT/8EFpkavGDiZYbu8M0oKoJ/KjDoQlnlhfqKgXgLgEQrHAXcW
y0DggRgz+iHUnHZ0+qmELSary54EhfNUhLHTq79doYODoPJ09jVObKNkcspXsX7p
dEhczGeuZp+hupB0+fXZ7HM0l/dSvZ9sya2NKMz35lK5RqDkaJMEt+VwB6NmKT/1
HvqRPEWK5d5VYVmCb8eywBJvrFznT1zdRKvpYTnvbahF7BadtCp5zxNJNrCuKclY
xr2vOxy3BU3hpXArKfqHmGI2hFThMi21etxsA0C9sZ8jBO4VQDJFnRKcwcbSdFmy
9EMX13RSh6EmWdTry+n5QQIkhxbvQioXMEqnYy3MuEOpgIBVV3QA1Y1wtmph/mAw
e632upw3X3P9sXrjtK2i
=3XHB
-----END PGP SIGNATURE-----

--WXBLDYRe6ft2Yf8u--
