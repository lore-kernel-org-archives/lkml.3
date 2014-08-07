Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbaHGJ64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 05:58:56 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52717 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131AbaHGJ6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 05:58:55 -0400
Date: Thu, 7 Aug 2014 11:58:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        Scott J Norton <scott.norton@hp.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH v7 2/2] locking/selftest: Support queued rwlock
Message-ID: <20140807095835.GM19379@twins.programming.kicks-ass.net>
References: <1407345722-61615-1-git-send-email-Waiman.Long@hp.com>
 <1407345722-61615-3-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qd3M+OfNeQcOexxj"
Content-Disposition: inline
In-Reply-To: <1407345722-61615-3-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qd3M+OfNeQcOexxj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 06, 2014 at 01:22:02PM -0400, Waiman Long wrote:
> The queued rwlock does not support the use of recursive read-lock in
> the process context. With changes in the lockdep code to check and
> disallow recursive read-lock, it is also necessary for the locking
> selftest to be updated to change the process context recursive read
> locking results from SUCCESS to FAILURE for rwlock.
> +static void rlock_AHA1(void)
> +{
> +	RL(X1);
> +	HARDIRQ_ENTER();
> +	RL(X1);	// this one should NOT fail
> +	HARDIRQ_EXIT();
> +}
> +
> +static void rlock_AHA1B(void)
> +{
> +	RL(X1);
> +	HARDIRQ_ENTER();
> +	RL(X2);	// this one should NOT fail
> +	HARDIRQ_EXIT();
> +}
> +
> +static void rlock_ASAHA1(void)
> +{
> +	RL(X1);
> +	SOFTIRQ_ENTER();
> +	RL(X1);	// this one should NOT fail
> +	HARDIRQ_ENTER();
> +	RL(X1);	// this one should NOT fail
> +	HARDIRQ_EXIT();
> +	SOFTIRQ_EXIT();
>  }

Thanks!

--Qd3M+OfNeQcOexxj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT403LAAoJEHZH4aRLwOS6UCwP/0Z5fZdLTsWIyceBBtM/Jpi6
e82pBbYKgaQ5vSJCziMrdtqMR76vCMI5ysR4xLMQAedEVCPLpdTnXFVpsxdyPmq8
H+zx12Bg4qf6bhelNkcudmzSU/jC7LCsL/xElK+i3C50PD/MXB7LEGx7Jz6rkyQp
2v60a0Pzip8Wh6UvqeVir7BqGrDRfJbUYi00rpPsCJCOrtNrULAeW3cgjRdXmGzr
PSHKMUikgcec2Jg6PVjlxMiRNjOpMaOTNOJ8WNiuexF++bFpqsRQ76YKu/eHW04R
BFJ08BJvWEb4iXRA8XQ+lKckMNrvJTGaQBBJv+DZJYRMotiUHbxeD4vrC2S86lOr
M1SU74QW7hylKASf1b4vT0M/0W7/mbFlEX76RP8zzsmk/4Zwpwp89PUtKUaDQQGL
79BcZeYjHGs04Pxt5PLWYvQOgC0PKxPr7mI98yFZu7O1rlzxc1GyRRli1Z3z6dO0
fGKgrt0x1nTdziuH/cJ+ZmBt4N7BNBEmIw55gOgUZEGnr5uhr9vGPNQkYw1ayFrr
vvqkv/eSEwiuhhvI4iODPTQ+pedsQja9crUlg+z2S8vGjgEm7gGOB/4NNO07r+vG
ka9HsezJla8yb+iqM5C/hb0crlk4EAhWQ0pQYoNsZKY/jEmgX+SUIHPwiSkvjel/
TWcstoRsfnyYWIFkaX6X
=EVoO
-----END PGP SIGNATURE-----

--Qd3M+OfNeQcOexxj--
