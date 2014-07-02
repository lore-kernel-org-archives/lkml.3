Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbaGBMt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 08:49:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:60638 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbaGBMt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 08:49:28 -0400
Date: Wed, 2 Jul 2014 14:49:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Alex Shi <alex.shi@linaro.org>,
        Paul Turner <pjt@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: select 'idle' cfs_rq per task-group to prevent
 tg-internal imbalance
Message-ID: <20140702124918.GE19379@twins.programming.kicks-ass.net>
References: <53A11A89.5000602@linux.vnet.ibm.com>
 <20140623094251.GS19860@laptop.programming.kicks-ass.net>
 <53A8F1DE.2060908@linux.vnet.ibm.com>
 <20140701082020.GL6758@twins.programming.kicks-ass.net>
 <53B273A2.5050500@linux.vnet.ibm.com>
 <20140701085658.GM6758@twins.programming.kicks-ass.net>
 <53B372C6.5000107@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="N1GIdlSm9i+YlY4t"
Content-Disposition: inline
In-Reply-To: <53B372C6.5000107@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--N1GIdlSm9i+YlY4t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 02, 2014 at 10:47:34AM +0800, Michael wang wrote:
> The opinion on features actually make me a little confusing... I used to
> think the scheduler is willing on providing kinds of way to adapt itself
> to different situation, and some features do help on that, make them
> only a debug option make the scheduler more static to users, but I know
> that's not what I should touched...
>=20
> Anyway, the problem is still there and seems like we have to adopt some
> optional solution to address it, we'll still working and practice on
> that, please let us know if you have any ideas we could help on ;-)

No, its very much not intended as a user knob to adapt.

The problem with that approach to scheduling is that one set of knobs
runs workload A, while another set of knobs runs workload B, but what
happens if you need to run both A and B on the same machine?

So optional things and knobs are a complete fail and will not happen.

Clearly I need to go take out all these things because people don't seem
to know this and SCHED_DEBUG isn't a big enough hint. Tedious.

--N1GIdlSm9i+YlY4t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTs//OAAoJEHZH4aRLwOS6pD8P/39iviJIUNlR2adHta1DCSY9
1efcFK466GQWg7lnb0fSOaseOec04NYJfbmymEQZSp8AmOELuBshjtdaeiCzDQkc
hc6lrE2xROMRPDf5eZqSfNVdJZo45mzoK6Mxid6EPl0rsso9/thBdyMLgqjME+vZ
CpT94lk4GOzxDSLgvoa2Dy8jLeKpGAqqhoWXHmMkQtzj+Ls0AENhzQsUmge0Qkti
b+DM3vpikdEPMP8Rs1NcO1e0YKL+hfGBf+g9fkFOv6Dzq2hzk7SYY1yTLYZlNx8K
vqYuQ5JCPcdYMhGD8cpvQHXQuFdtmTzrmpyn2yzBqMB8Is2ycAQopPOuoAVEg4kp
70Np4T6Dj0r4g3dWK/xxhQ9iW6Rn7gUorxnfNXTjdlXC072/pX7gvCV6cADSVLMn
xPRNtzaIh5bQG6sBZD2TcXaKjxxbWTo7bistPJADHar2n9tLvRwHtL7Q0zAhzzCS
lXhl0dNtd3fkJXyWuH6JNv1Md03niES0cJM73cQ1reS1JwlHephm5fwRzr1cnsN4
OtgthwjratWeBk/wsVaEPtVpS/46LjHo/bdp90Y3G03AAkU7P3PL15W7t4ItZ/ZE
FyfrVSNaYwsRCJCWnVuqtY1+a3SNYgudxFl2PX6Sq/ptkAf1Czs7UqLWwP8QsCu+
Eh655+YygKy/+SR6XG55
=Rb9c
-----END PGP SIGNATURE-----

--N1GIdlSm9i+YlY4t--
