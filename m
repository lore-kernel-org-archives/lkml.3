Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbaGaRhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:37:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43794 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbaGaRh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:37:29 -0400
Date: Thu, 31 Jul 2014 19:37:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jirka Hladky <jhladky@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Aaron Lu <aaron.lu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [LKP] [sched/numa] a43455a1d57: +94.1%
 proc-vmstat.numa_hint_faults_local
Message-ID: <20140731173705.GC19379@twins.programming.kicks-ass.net>
References: <53d70ee6.JsUEmW5dWsv8dev+%fengguang.wu@intel.com>
 <53D72FF5.90908@intel.com>
 <20140729023940.37b6aebc@annuminas.surriel.com>
 <20140731104241.GA9918@twins.programming.kicks-ass.net>
 <20140731155723.GY3588@twins.programming.kicks-ass.net>
 <53DA6BDA.8080000@redhat.com>
 <20140731162702.GZ19379@twins.programming.kicks-ass.net>
 <53DA7129.7020100@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0L8GnrW3Ijgkafis"
Content-Disposition: inline
In-Reply-To: <53DA7129.7020100@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0L8GnrW3Ijgkafis
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 31, 2014 at 06:39:05PM +0200, Jirka Hladky wrote:
> I'm doing 3 iterations (3 runs) to get some statistics. To speed up the test
> significantly please do the run with 20 warehouses only
> (or in general with #warehouses ==  number of nodes * number of PHYSICAL
> cores)

Yeah, went and did that for my 4 node machine, its got a ton more cores, but I
matches the warehouses to it:

-a43455a1d57	tip/master

979996.47	1144715.44
876146		1098499.07
1058974.18	1019499.38
1055951.59	1139405.22
970504.01	1099659.09

988314.45	1100355.64	(avg)
75059.546179565	50085.7473975167(stdev)

So for 5 runs, tip/master (which includes the offending patch) wins hands down.

Each run is 2 minutes.

--0L8GnrW3Ijgkafis
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT2n7BAAoJEHZH4aRLwOS6+o4P/3rmYTiWHHuXz9rouXN6v8Lx
3oi5BctNHPr7oIiwJHxiaL5Ct3Ez4XS5XKP2ZFxo5+WE1s4B9/POUIIzrITl4HeC
2/ruTz1ja415P2Arn+zmDvFhb0FS8mTglByBOc68DntZvnCZpICmpn6UIwHFkrDv
VX8eW5tBd05Zq2gsbcdDmMrADLJPCKs7cpKRXNdXVNnt5FA0OtOvtSdqctjLsVHB
/t6Pq2mfqXtlivQepHnPXzVTUI1sr1EzycePnM43NgKB+FuJguVCWmXpQLP7QrgH
2Ecg6YYuPtCPKarRRS10foXmy1j1Ko+urFQ9RdrhUXVHJ0Zrp0Fb1vaB3pedEdDt
u80kNf9AsKPIKW4LYq3FZq/nmabK0yrutc46ksLzlHg3hSC7n4o6e3fXgL68H8Lq
gi/gp4tLXiA6cz/BaE5GlJ9bEKqujXwhZmGR9YzPN9CbeK/zxVHemGHu1xofVQih
KzVszN71TH1B/gmJAio2fiAp2g6nILXzHnfcdKtgNgHrh6x7Bg2x7JZcbSEeDcIu
YjEC9dn6Z+Z1VD8FKE8g3bBDoUNwrIjOn5rFwgqV0stGPUy2skPDa1twk6af6Tuu
fTGQqef+Og86sJ8dcE3BstnrqBed11r/z2tHm7xttCRKqhbp0CMPmB03oDwLxMfu
+xpkWxHF0EO31k35MB3z
=iIoP
-----END PGP SIGNATURE-----

--0L8GnrW3Ijgkafis--
