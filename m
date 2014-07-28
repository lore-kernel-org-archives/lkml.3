Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaG1Ki2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 06:38:28 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46765 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaG1Ki0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 06:38:26 -0400
Date: Mon, 28 Jul 2014 12:38:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pjt@google.com" <pjt@google.com>,
        "bsegall@google.com" <bsegall@google.com>,
        "arjan.van.de.ven@intel.com" <arjan.van.de.ven@intel.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "alan.cox@intel.com" <alan.cox@intel.com>,
        "mark.gross@intel.com" <mark.gross@intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>
Subject: Re: [PATCH 0/2 v4] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140728103812.GP6758@twins.programming.kicks-ass.net>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
 <20140718153931.GJ8700@e103034-lin>
 <20140727190237.GB22986@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lnoGpPIaYJcLEQ+J"
Content-Disposition: inline
In-Reply-To: <20140727190237.GB22986@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lnoGpPIaYJcLEQ+J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2014 at 03:02:37AM +0800, Yuyang Du wrote:
> > Another thing that might be an issue is that the blocked of a terminated
> > task lives on for quite a while until has decayed away.
>=20
> Good point. To do so, if I read correctly, we need to hook do_exit(), but=
 probably
> we are gonna encounter rq->lock issue.
>=20
> What is the opinion/guidance from the maintainers/others?

So the entire point of this per entity tracking was to make sure load
numbers reflect reality. We account migrations etc., it would be weird
to then throw all that out the window and let task exit accumulate crap.



--lnoGpPIaYJcLEQ+J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT1igUAAoJEHZH4aRLwOS6NysP/jASppusl3byM+7LXAGMlbdC
rN5her6OFUFmxLVbY6jKa40H9xuaUezGUC9x5IFxYUgQDADu0RHCGmQFJwMNBp/J
rZ8K3HhZ7jo8q8PzSWTc1DririxlW50tcc/Dcw63scyjydFwsHbtVvlcbxGv5blc
udhcduw2F6DAM6RoFQcdfnxmVKSt8RwdUI1UjwaUzBl8dTflTHWaQWrmm0BGABiz
+4Zy8sF81B+UwLImMf18TS+DMptBta0NxLvCtJT3fzfgmGrIEDlbohnpTod3mLWl
cWLg7j3RDZXn+FEUdWRpqZqF4JzTQgk2L+B3khBzebm8cSZznVrZkBGiJbVIdyWu
e9To34USfrPsaleEYyKrCSpM9MQHw2IOAmlfrdz8NEsDLmHlBARGyLEkJ79qDARN
qxjbx1R3RIjel7q5q194JvR7jBwURTS1+X0FiY046wiL5/H4vM+VBhOyfAJNaJi9
A/ek/mYp21X2zSIwMy0fuERcdrovxfkj0gSVE8jIvQN/CGb0YPqXcLhIKWKmU1Wk
RD4paL5dx4YKQHdc7KkdlKtbe2oGtGzuptoQIardJu0fsE5fRhuKTD9ub4MvV+z/
qVwp1g155zZXf2Bcj/6c3L6umvZrPU2ByywQ9Mfu9z0LAbC7edsI1r/PeV3jXV1Q
NmaoV7JedU9Pvcjy6pfV
=9zVw
-----END PGP SIGNATURE-----

--lnoGpPIaYJcLEQ+J--
