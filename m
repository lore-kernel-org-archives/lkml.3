Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaGaQ1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:27:22 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49750 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaGaQ1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:27:13 -0400
Date: Thu, 31 Jul 2014 18:27:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jirka Hladky <jhladky@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Aaron Lu <aaron.lu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [LKP] [sched/numa] a43455a1d57: +94.1%
 proc-vmstat.numa_hint_faults_local
Message-ID: <20140731162702.GZ19379@twins.programming.kicks-ass.net>
References: <53d70ee6.JsUEmW5dWsv8dev+%fengguang.wu@intel.com>
 <53D72FF5.90908@intel.com>
 <20140729023940.37b6aebc@annuminas.surriel.com>
 <20140731104241.GA9918@twins.programming.kicks-ass.net>
 <20140731155723.GY3588@twins.programming.kicks-ass.net>
 <53DA6BDA.8080000@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="My06KtENIn8d38lB"
Content-Disposition: inline
In-Reply-To: <53DA6BDA.8080000@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--My06KtENIn8d38lB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 31, 2014 at 06:16:26PM +0200, Jirka Hladky wrote:
> On 07/31/2014 05:57 PM, Peter Zijlstra wrote:
> >On Thu, Jul 31, 2014 at 12:42:41PM +0200, Peter Zijlstra wrote:
> >>On Tue, Jul 29, 2014 at 02:39:40AM -0400, Rik van Riel wrote:
> >>>On Tue, 29 Jul 2014 13:24:05 +0800
> >>>Aaron Lu <aaron.lu@intel.com> wrote:
> >>>
> >>>>FYI, we noticed the below changes on
> >>>>
> >>>>git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git mas=
ter
> >>>>commit a43455a1d572daf7b730fe12eb747d1e17411365 ("sched/numa: Ensure =
task_numa_migrate() checks the preferred node")
> >>>>
> >>>>ebe06187bf2aec1  a43455a1d572daf7b730fe12e
> >>>>---------------  -------------------------
> >>>>      94500 ~ 3%    +115.6%     203711 ~ 6%  ivb42/hackbench/50%-thre=
ads-pipe
> >>>>      67745 ~ 4%     +64.1%     111174 ~ 5%  lkp-snb01/hackbench/50%-=
threads-socket
> >>>>     162245 ~ 3%     +94.1%     314885 ~ 6%  TOTAL proc-vmstat.numa_h=
int_faults_local
> >>>Hi Aaron,
> >>>
> >>>Jirka Hladky has reported a regression with that changeset as
> >>>well, and I have already spent some time debugging the issue.
> >>Let me see if I can still find my SPECjbb2005 copy to see what that
> >>does.
> >Jirka, what kind of setup were you seeing SPECjbb regressions?
> >
> >I'm not seeing any on 2 sockets with a single SPECjbb instance, I'll go
> >check one instance per socket now.
> >
> >
> Peter, I'm seeing regressions for
>=20
> SINGLE SPECjbb instance for number of warehouses being the same as total
> number of cores in the box.
>=20
> Example: 4 NUMA node box, each CPU has 6 cores =3D> biggest regression is=
 for
> 24 warehouses.

IVB-EP: 2 node, 10 cores, 2 thread per core:

tip/master+origin/master:

     Warehouses               Thrput
              4               196781
              8               358064
             12               511318
             16               589251
             20               656123
             24               710789
             28               765426
             32               787059
             36               777899
           * 40               748568
                                   =20
Throughput      18258  =20

     Warehouses               Thrput
              4               201598
              8               363470
             12               512968
             16               584289
             20               605299
             24               720142
             28               776066
             32               791263
             36               776965
           * 40               760572
                                   =20
Throughput      18551  =20


tip/master+origin/master-a43455a1d57

                   SPEC scores                                             =
                                          =20
     Warehouses               Thrput
              4               198667
              8               362481
             12               503344
             16               582602
             20               647688
             24               731639
             28               786135
             32               794124
             36               774567
           * 40               757559
                                   =20
Throughput      18477 =20


Given that there's fairly large variance between the two runs with the
commit in, I'm not sure I can say there's a problem here.

The one run without the patch is more or less between the two runs with
the patch.

And doing this many runs takes ages, so I'm not tempted to either make
the runs longer or do more of them.

Lemme try on a 4 node box though, who knows.

--My06KtENIn8d38lB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT2m5WAAoJEHZH4aRLwOS6GoQQAIe8KwcQxgmLFLDvbjBwbNRi
Pu/duTQfNLDjMsiwNfbXh1RzJIdy3OLHjYJ0fK+Ucgrkl1jH+qH/CjpX3yd5EELg
x4sUf9KACxpU795vZ0W6NGhVPSP4+50vrDmYdJdigC+BbNsCBWdAjUxguHsZYNkt
C6RXjWCCTpewdkTQFyjRPSdO0uRce2PKi/m5EpI+n32WNpnFs0jQQrIBqXzYp3Du
ERtPBkjUpHvvE5Wwo0efi1DVUNz+yBt/i0YeUcYpSi2OnHIvp2n0lzJWl7rHQv0e
//siXRFVBnJSxP2weycOvTr60YJCK1Ki2xRxLAq1EVKFLDLZUvaaN3uYhKPqIDC4
LalgU/VX1LsRCIRDOzkfBnIUOGi/aG974XytqStAWuw6m2zY6VmdZ/i2lVpSyk45
WPUzFs4SS2gi38EV/Ofg/XrWnmT+fhkrf9URqMCE0NZv02C8ZSQHyhwH2sd6Hf0F
AjH/HKJ0OAg82WP+TI5C52LsX9moIvl2tRcNGOxXr3BHkkAD28m/lNn/5a5fwH+i
hrPv9lKAFJWBlN0Q7FWNmfkqULGHy9kknZ3uuoKxk97XbdtqinE+SnpG8FpEt4W6
mX4w4/asWrGbUTAL1dgCHU3x3G6tYDcqLkvf7XmzIEuHCawROdl6abDDyEQHwgFd
jjGWZeCS80KRLzFRM/Y6
=0uGq
-----END PGP SIGNATURE-----

--My06KtENIn8d38lB--
