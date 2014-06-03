Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933042AbaFCPuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:50:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56462 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172AbaFCPuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:50:23 -0400
Date: Tue, 3 Jun 2014 17:50:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v2 08/11] sched: get CPU's activity statistic
Message-ID: <20140603155007.GZ30445@twins.programming.kicks-ass.net>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-9-git-send-email-vincent.guittot@linaro.org>
 <20140528121001.GI19967@e103034-lin>
 <CAKfTPtDxeBfZK1AxCRqEG91pi--Ti1RYFoQPDhvMVnGTCspQ-g@mail.gmail.com>
 <20140528154703.GJ19967@e103034-lin>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jBytRjlvjIVQOM9g"
Content-Disposition: inline
In-Reply-To: <20140528154703.GJ19967@e103034-lin>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jBytRjlvjIVQOM9g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 28, 2014 at 04:47:03PM +0100, Morten Rasmussen wrote:
> Since we may do periodic load-balance every 10 ms or so, we will perform
> a number of load-balances where runnable_avg_sum will mostly be
> reflecting the state of the world before a change (new task queued or
> moved a task to a different cpu). If you had have two tasks continuously
> on one cpu and your other cpu is idle, and you move one of the tasks to
> the other cpu, runnable_avg_sum will remain unchanged, 47742, on the
> first cpu while it starts from 0 on the other one. 10 ms later it will
> have increased a bit, 32 ms later it will be 47742/2, and 345 ms later
> it reaches 47742. In the mean time the cpu doesn't appear fully utilized
> and we might decide to put more tasks on it because we don't know if
> runnable_avg_sum represents a partially utilized cpu (for example a 50%
> task) or if it will continue to rise and eventually get to 47742.

Ah, no, since we track per task, and update the per-cpu ones when we
migrate tasks, the per-cpu values should be instantly updated.

If we were to increase per task storage, we might as well also track
running_avg not only runnable_avg.

--jBytRjlvjIVQOM9g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTje6vAAoJEHZH4aRLwOS6kEMQAInvizNLVoAp0DllUcRnWCcd
tZE1iuOh0eaDDUwHPMZMi0Ki9hK4kHkFoFTa8RyeYJ2beUe7i3SDcx87ceUCr54o
q2dc/lIeyERngVsLunb3gqmLKnFzmSRAQ7h+k5FmoZgZ9usvyU9bmTuYh5jJLGGt
3AxFoM8yJehKFK/GyM6ykvPYduzbLmTKjUfPLNZSWMcT6s9L1tmz3P4qmyOmsUN9
6q75w3v6Pf6/McfcPsG3ghLeGopyj+jxUGBORyHkH0l9DOcaC5W/Z1i7V1CTASFs
sNOzklIaZdLa3VikiF+jmMhhUcunIeeL+t9nHQwKRd6jIcKnF21OXe9VTHEoswB9
ALIeRcagERXS7V2P/MINPqXlSLOlOiI3XV9QAsb1U8R5JgSVgtpBB1IBbcNnRC4Z
hL/PTYdGVHz6fxo/GXpLUAf6DwMykmPkkdROPt4NxKQg4Vr4bZIdPWZIdvlRFS3l
i/dVCEBFv050Dzc/N1lAz/uUW2puYjKuR+c7tIoZusucHT1jcT5Suntkn8nY36zn
Lsy6VOJ+TRHLXiR30LcBoTP+gfo4GQF2PFHMf66qP0Tpbxze7SeC3JJt5lFfOh9K
+5CLwzgA4Gc1rQIHSq3RoXIsIzdXn1FwPEDw3vnUryv1wfBDpBkIQ3RIe1e4lsPk
ENnkRsxSNq5FNmRXOdTU
=rT1E
-----END PGP SIGNATURE-----

--jBytRjlvjIVQOM9g--
