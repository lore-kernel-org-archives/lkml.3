Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbaGaKmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 06:42:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:46524 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225AbaGaKmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 06:42:54 -0400
Date: Thu, 31 Jul 2014 12:42:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Aaron Lu <aaron.lu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, jhladky@redhat.com
Subject: Re: [LKP] [sched/numa] a43455a1d57: +94.1%
 proc-vmstat.numa_hint_faults_local
Message-ID: <20140731104241.GA9918@twins.programming.kicks-ass.net>
References: <53d70ee6.JsUEmW5dWsv8dev+%fengguang.wu@intel.com>
 <53D72FF5.90908@intel.com>
 <20140729023940.37b6aebc@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z7TGvjQjjVo70d0G"
Content-Disposition: inline
In-Reply-To: <20140729023940.37b6aebc@annuminas.surriel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z7TGvjQjjVo70d0G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 29, 2014 at 02:39:40AM -0400, Rik van Riel wrote:
> On Tue, 29 Jul 2014 13:24:05 +0800
> Aaron Lu <aaron.lu@intel.com> wrote:
>=20
> > FYI, we noticed the below changes on
> >=20
> > git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> > commit a43455a1d572daf7b730fe12eb747d1e17411365 ("sched/numa: Ensure ta=
sk_numa_migrate() checks the preferred node")
> >=20
> > ebe06187bf2aec1  a43455a1d572daf7b730fe12e =20
> > ---------------  ------------------------- =20
> >      94500 ~ 3%    +115.6%     203711 ~ 6%  ivb42/hackbench/50%-threads=
-pipe
> >      67745 ~ 4%     +64.1%     111174 ~ 5%  lkp-snb01/hackbench/50%-thr=
eads-socket
> >     162245 ~ 3%     +94.1%     314885 ~ 6%  TOTAL proc-vmstat.numa_hint=
_faults_local
>=20
> Hi Aaron,
>=20
> Jirka Hladky has reported a regression with that changeset as
> well, and I have already spent some time debugging the issue.

So assuming those numbers above are the difference in
numa_hint_local_faults, the report is actually a significant
_improvement_, not a regression.

On my IVB-EP I get similar numbers; using:

  PRE=3D`grep numa_hint_faults_local /proc/vmstat | cut -d' ' -f2`
  perf bench sched messaging -g 24 -t -p -l 60000
  POST=3D`grep numa_hint_faults_local /proc/vmstat | cut -d' ' -f2`
  echo $((POST-PRE))


tip/mater+origin/master		tip/master+origin/master-a43455a1d57

local	total                   local	total
faults  time                    faults  time

19971	51.384                  10104	50.838
17193	50.564                  9116	50.208
13435	49.057                  8332	51.344
23794	50.795                  9954	51.364
20255	49.463                  9598	51.258

18929.6	50.2526                 9420.8	51.0024
3863.61	0.96                    717.78	0.49

So that patch improves both local faults and runtime. Its good (even
though for the runtime we're still inside stdev overlap, so ideally I'd
do more runs).


Now I also did a run with the proposed patch, NUMA_SCALE/8 variant, and
that slightly reduces both again:

tip/master+origin/master+patch

local	total
faults  time

21296	50.541
12771	50.54
13872	52.224
23352	50.85
16516	50.705

17561.4	50.972
4613.32	0.71

So for hackbench a43455a1d57 is good and the proposed patch is making
things worse.

Let me see if I can still find my SPECjbb2005 copy to see what that
does.

--z7TGvjQjjVo70d0G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT2h2hAAoJEHZH4aRLwOS6hhcP/iprgNEBLe+wyPjge+1gyRx4
LVEhFOzev0+0CkZCXYVVzo8jO+xMPR9hIwN4F9FTth+e5TyWxRYXwmX/3VWUNg9f
GfqVURRMhO393JbssPhuHeQkNJ7bWIBowEZnRFw6A3w9rwlu0UQqpFwFLfkhbeH3
PeswLVv+uitBqVG2Edp/DlR/eFV9dXdJmfzYvR6rSOL9yevLdfr/wvsDyr6zgODz
p2zN9azho/j7mt5trHsTAUdXny+7lhya9+23zVLw8JuXtFWTjvbAtpDcbCCOFpwZ
MpGXogXN6uoRbA48aamidg8J+51W+K/w5xHSShC0KZ1o2hGLjI/rDxYeKtKFSWid
ZcaqKz+Tu1ljBCgvHATR2sVFvIBB8z+p1yo7rCjZ0SUHFESIkJ+VsAzNoRCEEfdF
y19fsWCAk/VSinKJaaJAY55l88tvHHNvI214nOPWH8EHGfD09VJK9yWH/WAXg60A
h9i7CyljqsJYtVv6DeTncFoQIv5mZsGwQSzART5z/+YCOcsmzGnhHJFnlqcMAidH
0JojTCHTj5XnRbLVO7CiH8X9Ny18/BIi6q1tM1fuPK1h7Ec6VM/jOy5MDVNmEQYl
B0HPOLGkeAP6l+22m24rhtbdmaaFLsqXRGEDK/5LIBax0+2yRWhjavtIwKTtoLlW
L9t5WM9bPZ7ANBfBNMen
=7Dk0
-----END PGP SIGNATURE-----

--z7TGvjQjjVo70d0G--
