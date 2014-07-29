Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaG2H4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 03:56:10 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42179 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaG2H4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 03:56:08 -0400
Date: Tue, 29 Jul 2014 09:55:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 2/9] rcu: Provide cond_resched_rcu_qs()
 to force quiescent states in long loops
Message-ID: <20140729075536.GZ19379@twins.programming.kicks-ass.net>
References: <20140728225556.GA19493@linux.vnet.ibm.com>
 <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1406588180-21933-2-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XGMVbVQaXwwZxfEN"
Content-Disposition: inline
In-Reply-To: <1406588180-21933-2-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XGMVbVQaXwwZxfEN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2014 at 03:56:13PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>=20
> RCU-tasks requires the occasional voluntary context switch
> from CPU-bound in-kernel tasks.  In some cases, this requires
> instrumenting cond_resched().  However, there is some reluctance
> to countenance unconditionally instrumenting cond_resched() (see
> http://lwn.net/Articles/603252/),

No, if its a good reason mention it, if not ignore it.

> so this commit creates a separate
> cond_resched_rcu_qs() that may be used in place of cond_resched() in
> locations prone to long-duration in-kernel looping.

Sounds like a pain and a recipe for mistakes. How is joe kernel hacker
supposed to 1) know about this new api, and 2) decide which to use?

Heck, even I wouldn't know, and I just read the damn patch.

--XGMVbVQaXwwZxfEN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT11N4AAoJEHZH4aRLwOS6JDAP/2ENQDhPn17kIGLJsXwskbSp
aB2aB9DithSPVPAVptBHbH+HNskQWkRA5hR5sDqVFb+cXRM1QiVbPKHhLjs2cGfh
21jHqGX75ZsrJB6yWeyGTJbNQUdSvE+skr3WWwuVUEFMYKXQX5c6/1gxvZIB/OLM
7AIriiUSBnjLzxGRHddMD2srgqaSE4NEYLD+xSZJbP2aoafi08oqmZhycMu8YqCE
t9ZV2XuMfOzoTGPtmECww4AIAVB6Qu6l6k16ZWpKBs0MDr/41MTGTxbcnlFBQXRK
Ce4o/V383rQjaCCueUn8GuXV7xAk59MrwrVgpT9W5ufLUA2BfT4Zmy38MfPhn3ht
ly94cukUebRwIJ3wTGMMrXK7TtWuHLOVaFrCmHL6SAENEurtzR3gkv1EnMbPrxzO
xA72mtULYVNSm/WwvdKSdWQrmXAZ4b1rBoGisKIDq2g+SJaqZSxDlmNSXgPXfbDJ
wcM3ACIC9nzbDeTq0PdtXNgrEMlLYpP2PLK5NE0a/4HhyCK0vkO+DyDT4hP9ehin
Bj1xEc1ar75hCuqdxqoAHSB/VxE5Yi9AJJl8jiTeq8pPew4isheKUm/sW46yP1bQ
Ryfbc6WKx/TRJbq6cwj5SguAMzFwnp+t7aT7Mip1t6Qrfe6/0/k8zUTH7ErpcgR8
dO/vnajtxDJRA6x5MN3U
=uyUj
-----END PGP SIGNATURE-----

--XGMVbVQaXwwZxfEN--
