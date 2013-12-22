Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab3LVFK3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 00:10:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:50151 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab3LVFK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 00:10:27 -0500
Message-ID: <1387689024.5412.49.camel@marge.simpson.net>
Subject: Re: CONFIG_NO_HZ_FULL + CONFIG_PREEMPT_RT_FULL = nogo
From: Mike Galbraith <bitbucket@online.de>
To: muli.baron@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Date: Sun, 22 Dec 2013 06:10:24 +0100
In-Reply-To: <1387685830.5412.37.camel@marge.simpson.net>
References: <1383228427.5272.36.camel@marge.simpson.net>
	 <alpine.DEB.2.02.1311061842160.23353@ionos.tec.linutronix.de>
	 <1383794799.5441.16.camel@marge.simpson.net>
	 <1383798668.5441.25.camel@marge.simpson.net>
	 <alpine.DEB.2.02.1311071158350.23353@ionos.tec.linutronix.de>
	 <20131220154146.GA18672@breakpoint.cc>
	 <1387617104.30230.7.camel@marge.simpson.net> <52B5CE09.5030908@gmail.com>
	 <1387685830.5412.37.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:Tt4eG9qgv9Lf/9MNc2rcsMoMUn7t1CaMMC1VMJybUcD
 TLA8COFo1ubkamWScGY9Dl4op6jDD1heEqKjElo4Soe5+IwYO4
 DEl1MpVjRZUrf/xdTmfB22bHYJvF/6ms4bm4fi/ukBZyTuLhNW
 s67eEUS5GprxyKZzmu3NA0rG8W12HmTJKJYV7ZsZuYNSmRdMMa
 8pMSo7t/KX32HtTyIUqdMuL2CDTUvAdrWQTYfpNqm2nhXgdK9y
 OPn3DdHAeh6cy7ZHYBsNA5vpkUSsUXatNdM1eVwazwB2iYVFYI
 JL9gjGkIvZo9QjoiL7H9ekQ38UpQSxTiUCxzQC9YfJ+F283KQd
 r93+4DLEWjYSfJDi/PheZ3eOuQ0QM8Rx5OnXHZqIq4UzUsV2ca
 6TBcFUTe71ehA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-12-22 at 05:17 +0100, Mike Galbraith wrote: 
> On Sat, 2013-12-21 at 19:21 +0200, Muli Baron wrote: 
> > On 21/12/2013 11:11, Mike Galbraith wrote:
> > >
> > > Works, modulo noisy workqueues.
> > >
> > > rtbox:~ # sleep 35 && killall pert& cgexec -g cpuset:rtcpus taskset -c 3 pert 5
> > > [1] 5660
> > > 2400.05 MHZ CPU
> > > perturbation threshold 0.018 usecs.
> > > pert/s:       33 >15.75us:        2 min:  0.04 max: 24.14 avg:  2.51 sum/s:    84us overhead: 0.01%
> > > pert/s:       35 >15.54us:        3 min:  0.04 max: 24.89 avg:  2.39 sum/s:    84us overhead: 0.01%
> > > pert/s:       30 >15.27us:        2 min:  0.04 max: 23.03 avg:  2.64 sum/s:    80us overhead: 0.01%
> > > pert/s:       34 >15.12us:        3 min:  0.04 max: 25.03 avg:  2.51 sum/s:    86us overhead: 0.01%
> > > pert/s:       31 >14.93us:        2 min:  0.04 max: 23.86 avg:  2.60 sum/s:    83us overhead: 0.01%
> > > Terminated
> > >
> > 
> > I can confirm this works for me as well, but I have noticed some strange behavior under certain 
> > conditions.
> 
> Hm, so can I.  Same everything, different day, nohz_full is NOT working.

DL980 with same rt7 patchset/config, but with nohz_full=55-63 can take a
while to make up its mind, but does kick in (this boot anyway).

vogelweide:/abuild/mike/:[0]# cgexec -g cpuset:rtcpus taskset -c 60 pert 5
2260.90 MHZ CPU
perturbation threshold 0.024 usecs.
pert/s:     1000 >10.20us:        7 min:  7.21 max: 11.28 avg:  8.00 sum/s:  8000us overhead: 0.80%
pert/s:      600 >10.92us:        5 min:  1.64 max: 26.90 avg:  7.81 sum/s:  4690us overhead: 0.47%
pert/s:     1000 >10.79us:        4 min:  7.08 max: 11.49 avg:  7.86 sum/s:  7863us overhead: 0.79%
pert/s:     1000 >10.70us:        5 min:  7.15 max: 11.90 avg:  7.88 sum/s:  7878us overhead: 0.79%
pert/s:      937 >10.57us:        5 min:  4.30 max: 11.06 avg:  7.81 sum/s:  7324us overhead: 0.73%
pert/s:        1 >9.99us:        0 min:  4.10 max:  5.03 avg:  4.45 sum/s:     4us overhead: 0.00%
pert/s:        1 >9.77us:        1 min:  4.40 max: 10.13 avg:  5.49 sum/s:     7us overhead: 0.00%
pert/s:        2 >14.79us:        3 min:  2.65 max:104.68 avg: 15.21 sum/s:    30us overhead: 0.00%
pert/s:        1 >13.84us:        0 min:  4.31 max:  5.86 avg:  4.82 sum/s:     5us overhead: 0.00%
pert/s:        1 >13.18us:        0 min:  4.03 max:  9.17 avg:  5.19 sum/s:     6us overhead: 0.00%
pert/s:        1 >12.69us:        0 min:  2.83 max: 10.65 avg:  5.85 sum/s:     8us overhead: 0.00%

vogelweide:/abuild/mike/:[0]# cgexec -g cpuset:rtcpus taskset -c 60 pert 5
2260.90 MHZ CPU
perturbation threshold 0.024 usecs.
pert/s:        1 >9.11us:        2 min:  2.87 max: 11.95 avg:  6.12 sum/s:    10us overhead: 0.00%
pert/s:        1 >9.09us:        2 min:  3.09 max: 11.75 avg:  6.04 sum/s:     8us overhead: 0.00%
pert/s:        1 >22.94us:        2 min:  2.73 max:262.06 avg: 33.14 sum/s:    60us overhead: 0.01%
pert/s:        1 >21.53us:        0 min:  2.85 max: 12.02 avg:  5.69 sum/s:     7us overhead: 0.00%
pert/s:        1 >20.26us:        0 min:  3.38 max: 11.94 avg:  5.67 sum/s:     7us overhead: 0.00%
pert/s:        1 >19.12us:        0 min:  2.89 max: 12.11 avg:  5.72 sum/s:     7us overhead: 0.00%
pert/s:        1 >18.05us:        0 min:  3.12 max: 11.28 avg:  5.58 sum/s:     7us overhead: 0.00%
pert/s:        1 >17.24us:        0 min:  2.85 max: 13.20 avg:  6.72 sum/s:     9us overhead: 0.00%
pert/s:        2 >26.85us:        1 min:  2.70 max:201.53 avg: 24.99 sum/s:    50us overhead: 0.00%
pert/s:        1 >25.00us:        0 min:  2.81 max: 11.19 avg:  5.56 sum/s:     7us overhead: 0.00%
pert/s:        1 >23.33us:        0 min:  3.16 max: 11.11 avg:  5.59 sum/s:     7us overhead: 0.00%
pert/s:        1 >21.90us:        0 min:  2.87 max: 11.50 avg:  6.47 sum/s:    10us overhead: 0.00%
pert/s:        1 >20.57us:        0 min:  2.87 max: 11.21 avg:  5.99 sum/s:     8us overhead: 0.00%
pert/s:        1 >19.37us:        0 min:  3.22 max: 11.51 avg:  5.64 sum/s:     7us overhead: 0.00%
pert/s:        1 >18.26us:        0 min:  3.26 max: 10.72 avg:  5.97 sum/s:     8us overhead: 0.00%
pert/s:        1 >27.90us:        1 min:  2.67 max:202.74 avg: 26.52 sum/s:    48us overhead: 0.00%

Hm, size hefty perturbations every 30 seconds (sniff.. eau de vmstat).

