Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934544AbaEFL4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 07:56:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54154 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757279AbaEFL4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 07:56:53 -0400
Date: Tue, 6 May 2014 13:56:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Preeti Murthy <preeti.lkml@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, umgwanakikbuti@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Ingo Molnar <mingo@kernel.org>, george.mccollister@gmail.com,
        ktkhai@parallels.com, Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC/TEST] sched: make sync affine wakeups work
Message-ID: <20140506115644.GI11096@twins.programming.kicks-ass.net>
References: <20140502004237.79dd3de6@annuminas.surriel.com>
 <1399011219.5233.55.camel@marge.simpson.net>
 <53633B81.1080403@redhat.com>
 <CAM4v1pPwe4B0K8MPpf183LqabRoRKRPi_R7n8-Y02aR43M8iQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H2kTGx6mr3R59oXC"
Content-Disposition: inline
In-Reply-To: <CAM4v1pPwe4B0K8MPpf183LqabRoRKRPi_R7n8-Y02aR43M8iQQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H2kTGx6mr3R59oXC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 04, 2014 at 05:14:59PM +0530, Preeti Murthy wrote:
> As far as my understanding goes, the logic in select_task_rq_fair()
> does wake_affine() or calls select_idle_sibling() only at those
> levels of sched domains where the flag SD_WAKE_AFFINE is set.
> This flag is not set at the numa domain and hence they will not be
> balancing across numa nodes. So I don't understand how
> *these functions* are affecting NUMA placements.

It _is_ set at NUMA domains, just not on those > RECLAIM_DISTANCE. That
means you typically need a non-fully connected system and then the top
numa tier will not get wake affine.

--H2kTGx6mr3R59oXC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTaM38AAoJEHZH4aRLwOS6zhAQAIFj7SxkOeqBWYd4NocPkkOf
XTUTS367CsCfo27pFpqm2IT6+nrTaXamGyqWhoU9eo74qf+/Vileq8E2jsyDmGEI
AWOKICtEEllqQZT7onG2W6oBoYXPOMokkOf0GdAnANa7uQsEiSPjOF+cJfdFNjw9
YMgWFhSbwKrjL/MfzO0H+YbK1RxTAGjjbXtiEvL+h4Mw9rojKLT+v0xkkem48EyF
8KGO6bqIMUgG/WOhR86Pvebjd5QsCNoHrrpeyQgj+fgcyg5ngAIMOSPL7yYm0u04
gQhgjaJ+tdjD2E8SbEnKH/EQDxPN6Uv7p8CaPg/6NNkvT7KK6rycocxev1+TIgxq
ejz6jAqvS9Q7Gwbd6Z7FVws/n+zJcVOFn+nv/R7JLV4SfFxsxaKQCMgku6XJB1XZ
mZ8bPOQdbCtMKIKeE4ZUpGl0Pu98fw9Q9tO3VPBKRH+UUQl0cifi8nMOnB76ocac
38fS0MSZtBWYYlEolpDskDtcvjekb5Kqj5fzRn7ytKE4iYoyDvZAML7uHGb5+LGv
Qs4tvqLuVxu5gU98Hr6Ke9kp4i9DWFy8dkyXo/6DWdMUB19BQT6lEb8Wb1fwDAJK
xAqg92/UFoLHdaeCz0FTk1d5994LAqO2chCvBGjvDK7WrB0IEff2fv+MPePMDjKJ
qX5cYPwZfvVHeLktL8df
=4Km0
-----END PGP SIGNATURE-----

--H2kTGx6mr3R59oXC--
