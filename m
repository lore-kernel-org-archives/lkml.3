Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbaEWItl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 04:49:41 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46659 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaEWIti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 04:49:38 -0400
Date: Fri, 23 May 2014 10:49:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Oleg Nesterov <oleg@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>, Juri Lelli <juri.lelli@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Alex Thorlton <athorlton@sgi.com>, Rik van Riel <riel@redhat.com>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Dario Faggioli <raistlin@linux.it>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        liguang <lig.fnst@cn.fujitsu.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-doc@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH v5 3/6] seccomp: introduce writer locking
Message-ID: <20140523084914.GA30445@twins.programming.kicks-ass.net>
References: <1400799936-26499-1-git-send-email-keescook@chromium.org>
 <1400799936-26499-4-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wqJKAkAJyMuynVpZ"
Content-Disposition: inline
In-Reply-To: <1400799936-26499-4-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wqJKAkAJyMuynVpZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 22, 2014 at 04:05:33PM -0700, Kees Cook wrote:
> Normally, task_struct.seccomp.filter is only ever read or modified by
> the task that owns it (current). This property aids in fast access
> during system call filtering as read access is lockless.
>=20
> Updating the pointer from another task, however, opens up race
> conditions. To allow cross-task filter pointer updates, writes to the
> seccomp fields are now protected by a spinlock.  Read access remains
> lockless because pointer updates themselves are atomic.  However, writes
> (or cloning) often entail additional checking (like maximum instruction
> counts) which require locking to perform safely.
>=20
> In the case of cloning threads, the child is invisible to the system
> until it enters the task list. To make sure a child can't be cloned
> from a thread and left in a prior state, seccomp duplication is moved
> under the tasklist_lock. Then parent and child are certain have the same
> seccomp state when they exit the lock.
>=20

So I'm a complete noob on the whole seccomp thing, so maybe this is a
silly question, but.. what about object lifetimes?

Looking at put_seccomp_filter() it explicitly takes a tsk pointer,
suggesting one can call it on !current. And while it does a dec_and_test
on the object itself, run_filter() does nothing with refcounts, and
therefore can be touching dead memory.



--wqJKAkAJyMuynVpZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTfwuDAAoJEHZH4aRLwOS6ZoQP/29ZW6HhMmxlYpJH6Mwq+ho9
d0bA9y8fJswBsxR/7XMrp8sKsflO6J5Hut5M1E85vul/bGogqcgUY9gvF4S+evp6
ozkcd/ekfBu5iDPpIvsBMxYCMV1vgndpO+ihr2zyrjABmbe5ZJ3pifVvTSjTWAJV
/y/d3BPtyPjnK8gL5PFnPjwJsxSEUsrboCivFZCTVenPZD9m+4wuLxz0hfPfwOdq
HqX8J9iWDqNgnwsNo02FnaumOrWA7GIlqdED6MyriesmaXKhyHyx80dRcK35wmow
CkZNGNFCeXxkheiFL41BJAjcqOZqpA4UfDpVBR23TpyuTyofSruWFDeaT7mAeW/h
vJI8+7+NVQIpHuYdMPtBlT67bDiwt0NUPELgtHE2zJdgnNteJoLPqpu0M10970Zm
kbogt3lDFi0N7RIXhJwKM3e6Uxt3PVYUVWODMS9BoMCkEnVBWfnx0P5DT+Zdvwke
tML6wptg1Jv56oeroytCapT8zJ8iOHyD7oiEFRbz4w7+lBOzwucxe2aCRwPd8PjF
CGZHUnTahxEN9CP8qMtUIDsxqpySXHMpq20Q4n7Ek7C5ymibF1RH7/H5YKUeF9MF
B8L/+NffyLbmb0Fhfq44yALmADjxzlwOpwLy2ky0dMVemr+bwhfSdJ9UNbS9QHu5
4L4p7FL1KL7r1qaTCJ6E
=nL7H
-----END PGP SIGNATURE-----

--wqJKAkAJyMuynVpZ--
