Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbaEIJIM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:08:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:48110 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaEIJIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:08:10 -0400
Date: Fri, 9 May 2014 11:08:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        daniel.lezcano@linaro.org, alex.shi@linaro.org,
        preeti@linux.vnet.ibm.com, efault@gmx.de, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, aswin@hp.com
Subject: Re: [PATCH 2/2] sched: Fix next_balance logic in rebalance_domains()
 and idle_balance()
Message-ID: <20140509090805.GK30445@twins.programming.kicks-ass.net>
References: <1398725155-7591-1-git-send-email-jason.low2@hp.com>
 <1398725155-7591-3-git-send-email-jason.low2@hp.com>
 <1399568364.2030.9.camel@j-VirtualBox>
 <20140508173835.GB9838@gmail.com>
 <1399587244.2030.59.camel@j-VirtualBox>
 <1399596562.2200.7.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VmlJMtejgecKmNHY"
Content-Disposition: inline
In-Reply-To: <1399596562.2200.7.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VmlJMtejgecKmNHY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 08, 2014 at 05:49:22PM -0700, Jason Low wrote:
> On Thu, 2014-05-08 at 15:14 -0700, Jason Low wrote:
> > Hi Ingo, Peter,
> >=20
> > Were there NULL domains on the test system? If so, I think we can
> > address the problem by doing update_next_balance() only if the below
> > rcu_dereference_check_sched_domain() returns a non-null domain.
>=20
> Also, below is a patch which has the change:
>=20

Thanks, and yes, NULL domains are a perfectly normal thing to have
(though not common on normal boot paths).

--VmlJMtejgecKmNHY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTbJr1AAoJEHZH4aRLwOS6NcYQAKX6ijtWOWfBLoMBDXjIepRx
hGOWc55Xx6kjVZZQQ8+C6XlBdDHKyteLGuFuYR4Rx1g31I3BW7YnBi2yn3HF0LoP
pKCRZOBPgA2Lo2XWBE9B2SYhoSgQMacsu+mXnuWEsia+oEQQCEsjJIBOiA/f2XQq
3YXUSWZklVJGRSkmQsDMYJhtPfRT9FAqMt3ApgA+f/l9ezFmKFyTMs8Tmi19ZoY+
HpyG1tFkMB0YYyniFW13qUcikwEOy4N0aexcYt0pqwfthBoYPWDIejY2y2SfxGOM
P8KVg76YjJ03wmP6/OR/qH/JE7PM5I+x5pb+hquU5wbo9mFAJOPSdaInhBPzAGGt
dWei7+b68riMHFG6Ir8P6BGeIFELy7u75VsnuZ82CQmIyRIuCyr0Zgf1AltLJHlZ
0c/xqqARo6YsxeREC0dmPt4Dkgv1CiB8GC2H3WX8EDBcQjUrTMsuQA154/8xUwvU
eUil2QF6GDGOfNz2I4q/+IBqQRtHH2LbhoO0Lt+eNqcfcOFdAAXjbsW9rlQa3eZz
jZhZRLm7LuLx2DxbekCvRg/YwRRqpvC+64XLhNbKkOIqkTxXsr+eOeBJLkm9x/jC
FdFcfccrPRw5HbVYr/XCHfCDpLECxCalrE8wjCqGYOlYw7YVr41SkmQvTDiapd76
9spWFZQGhodL5t/qTVp/
=Sv+o
-----END PGP SIGNATURE-----

--VmlJMtejgecKmNHY--
