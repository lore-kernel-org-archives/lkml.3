Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbaFYFbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:31:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44361 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbaFYFby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:31:54 -0400
Date: Wed, 25 Jun 2014 07:31:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, chegu_vinod@hp.com, mgorman@suse.de,
        mingo@kernel.org
Subject: Re: [PATCH 9/7] sched,numa: remove task_h_load from task_numa_compare
Message-ID: <20140625053138.GF6758@twins.programming.kicks-ass.net>
References: <1403538095-31256-1-git-send-email-riel@redhat.com>
 <20140624151454.2a05082e@annuminas.surriel.com>
 <20140625050735.GB28774@twins.programming.kicks-ass.net>
 <20140625052144.GH3588@twins.programming.kicks-ass.net>
 <53AA5D2C.9000401@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hI0LKvM4dmXJ5Wy2"
Content-Disposition: inline
In-Reply-To: <53AA5D2C.9000401@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hI0LKvM4dmXJ5Wy2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 25, 2014 at 01:25:00AM -0400, Rik van Riel wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>=20
> On 06/25/2014 01:21 AM, Peter Zijlstra wrote:
> > On Wed, Jun 25, 2014 at 07:07:35AM +0200, Peter Zijlstra wrote:
> >> Shall I merge this into patch 3?
> >=20
> > Which gets me the below; which is has a wrong changelog.
> >=20
> > task_h_load() already computes the load as seen from the root
> > group. effective_load() just does a better (and more expensive) job
> > of computing the task movement implications of a move.
> >=20
> > So the total effect of this patch shouldn't be very big; regular
> > load balancing also only uses task_h_load(), see move_tasks().
> >=20
> > Now, we don't run with preemption disabled, don't run as often,
> > etc.., so maybe we can indeed use the more expensive variant just
> > fine, but does it really matter?
>=20
> In my testing, it appears to make a difference between workloads
> converging, and workloads sitting with one last thread stuck on
> another node that never gets moved...

Fair enough; can you provide a new Changelog that I can paste in?

--hI0LKvM4dmXJ5Wy2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTql66AAoJEHZH4aRLwOS6XoYP/RqumOoMqFPbPV0ZAdUQFVKe
bOw1AbNmmWefr738Ka4wzqmSkRFwM/0Cgif+GJF/x9fcB1Azajyili1XOVu/JokA
T+VWfpaR/ZVJWFC3YEvEa3370+j3431V+qROz4tWL7P7/BVDIIfUXpsZx1DXQTag
dFsiEJAiMfh8hprKpUWrmr5YitxeL9PpPmR1e7zFgrH5Zat1NigfP9bbs/Zy+uRf
DMhKSMGIxIaM1A/HRzFZ/0bkmfZbDK1PODsdyhocsgEG9/yjymAz/iNOaL36DYXB
Z9BdZo8tWwn1c3/xXw4npqgagaEmRT9zyo3vtFApsgHTjzOrR8rvfmDTYReevMZY
PDnxko0BLWS3olGoUHjO3F2yWDqqOKYlrbjnqHgcq2GEwgfiw7eMki8l70a8OIaQ
MYJM6n2KywLsKmFtQssWrJ7q08RjjlLh9/3zVT18X6HoHQVq7rIqVxGSadh9obvZ
b7Uv0vB45Cw/YcHYs6ii2pxX8XWhfkxmdp4mCxUtRNtX4g021MIJ9ByncHfE4fXl
QptHPi0OxlD8o8ZHPTvfdFQhyeK5uC/Y/zklFnCcr43ekQqTT1ZKiZP7OQDBM597
sqPrNK7c4Zqbi2fF0VBQeUTugakKQDVYiacDfWXAd4MGEsZfmo99UC73q2jipGEm
kR0yw59RoO+TkSLqF+2G
=m8QX
-----END PGP SIGNATURE-----

--hI0LKvM4dmXJ5Wy2--
