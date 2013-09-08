Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519Ab3IHRWu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 13:22:50 -0400
Received: from mout.gmx.net ([212.227.15.15]:49368 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815Ab3IHRWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 13:22:48 -0400
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Date: Sun, 08 Sep 2013 19:22:45 +0200
From: "Tibor Billes" <tbilles@gmx.com>
Message-ID: <20130908172246.288090@gmx.com>
MIME-Version: 1.0
Subject: Re: Unusually high system CPU usage with recent kernels
To: paulmck@linux.vnet.ibm.com
X-Flags: 0001
X-Mailer: GMX.com Web Mailer
x-registered: 0
X-GMX-UID: Mddecu0ReSEqJL5QQHchBp1+IGRvb8Cm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Paul E. McKenney Sent: 09/07/13 02:23 AM
> On Tue, Sep 03, 2013 at 03:16:07PM -0700, Paul E. McKenney wrote:
> > On Tue, Sep 03, 2013 at 11:11:01PM +0200, Tibor Billes wrote:
> > > > From: Paul E. McKenney Sent: 08/30/13 03:24 AM
> > > > On Tue, Aug 27, 2013 at 10:05:42PM +0200, Tibor Billes wrote:
> > > > > From: Paul E. McKenney Sent: 08/26/13 06:28 AM
> > > > > > Here is a patch that is more likely to help. I am testing it in parallel,
> > > > > > but figured I should send you a sneak preview.
> > > > > 
> > > > > I tried it, but I don't see any difference in overall performance. The dstat
> > > > > also shows the same as before.
> > > > > 
> > > > > But I did notice something. Occasionally there is an increase in userspace
> > > > > CPU usage, interrupts and context switches are dropping, and it really gets
> > > > > more work done (scons printed commands more frequently).  I checked that
> > > > > this behaviour is present without your patch, I just didn't notice this
> > > > > before. Maybe you can make some sense out of it.
> > > > > 
> > > > > ----system---- ----total-cpu-usage---- -dsk/total- -net/total- ---paging-- ---system-- ----swap--- ------memory-usage----- -----virtual-memory----
> > > > >     time     |usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw | used  free| used  buff  cach  free|majpf minpf alloc  free
> > > > > 27-08 20:51:53| 23  62   5   0  11   0|   0     0 |   0     0 |   0     0 |1274  3102k|   0  7934M| 549M 56.0M  491M 6698M|   0    28   156   159 
> > > > > 27-08 20:51:54| 24  64   1   0  11   0|   0     0 |   0     0 |   0     0 |1317  3165k|   0  7934M| 549M 56.0M  491M 6698M|   0    53   189   182 
> > > > > 27-08 20:51:55| 33  50   6   2   9   0| 192k 1832k|   0     0 |   0     0 |1371  2442k|   0  7934M| 544M 56.0M  492M 6702M|   0    30k   17k   17k
> > > > > 27-08 20:51:56| 24  64   0   0  12   0|   0     0 |   0     0 |   0     0 |1313  3220k|   0  7934M| 544M 56.0M  492M 6701M|   0    21   272   232 
> > > > > 27-08 20:51:57| 24  64   0   0  12   0|   0     0 |   0     0 |   0     0 |1319  3226k|   0  7934M| 544M 56.0M  492M 6701M|   0     8    96   112 
> > > > > 27-08 20:51:58| 25  63   0   0  12   0|   0     0 |   0     0 |   0     0 |1317  3224k|   0  7934M| 544M 56.0M  492M 6701M|   0    12   145   141 
> > > > > 27-08 20:51:59| 24  64   0   0  12   0|   0     0 |   0     0 |   0     0 |1317  3223k|   0  7934M| 544M 56.0M  492M 6701M|   0    54   193   191 
> > > > > 27-08 20:52:00| 25  63   0   0  12   0|   0    24k|   0     0 |   0     0 |1336  3216k|   0  7934M| 544M 56.0M  492M 6701M|   0    36   161   172 
> > > > > 27-08 20:52:01| 24  64   0   0  12   0|   0     0 |   0     0 |   0     0 |1313  3225k|   0  7934M| 544M 56.0M  492M 6701M|   0     9   107   107 
> > > > > 27-08 20:52:02| 24  64   0   0  12   0|   0     0 |   0     0 |   0     0 |1327  3224k|   0  7934M| 545M 56.0M  492M 6701M|   0    13   193   200 
> > > > > 27-08 20:52:03| 24  64   0   0  12   0|   0     0 |   0     0 |   0     0 |1311  3226k|   0  7934M| 545M 56.0M  492M 6701M|   0    13   114   114 
> > > > > 27-08 20:52:04| 25  63   0   0  12   0|   0     0 |   0     0 |   0     0 |1331  3223k|   0  7934M| 544M 56.0M  492M 6701M|   0    41   190   178 
> > > > > 27-08 20:52:05| 24  64   0   0  12   0|   0  8192B|   0     0 |   0     0 |1315  3222k|   0  7934M| 544M 56.0M  492M 6701M|   0    30   123   122 
> > > > > 27-08 20:52:06| 24  64   0   0  12   0|   0     0 |   0     0 |   0     0 |1314  3223k|   0  7934M| 544M 56.0M  492M 6701M|   0    16   187   195 
> > > > > 27-08 20:52:07| 25  63   1   0  12   0|2212k  192k|   0     0 |   0     0 |1637  3194k|   0  7934M| 544M 56.2M  494M 6699M|   0  1363  2590  1947 
> > > > > 27-08 20:52:08| 17  33  18  26   6   0|3208k    0 |   0     0 |   0     0 |1351  1766k|   0  7934M| 561M 56.3M  499M 6678M|   4    10k 7620  2055 
> > > > > 27-08 20:52:09| 47  21  16  13   4   0|4332k  628k|   0     0 |   0     0 |1400  1081k|   0  7934M| 647M 56.3M  504M 6587M|  10    24k   25k 1151 
> > > > > 27-08 20:52:10| 36  34  13  11   6   0|2636k 2820k|   0     0 |   0     0 |1451  1737k|   0  7934M| 598M 56.3M  507M 6632M|   5    19k   16k   28k
> > > > > 27-08 20:52:11| 46  17  10  25   3   0|4288k  536k|   0     0 |   0     0 |1386   868k|   0  7934M| 613M 56.3M  513M 6611M|  24    13k 8908  3616 
> > > > > 27-08 20:52:12| 53  33   5   4   5   0|4740k 3992k|   0     0 |   0     0 |1773  1464k|   0  7934M| 562M 56.6M  521M 6654M|   0    36k   29k   40k
> > > > > 27-08 20:52:13| 60  34   0   1   6   0|4228k 1416k|   0     0 |   0     0 |1642  1670k|   0  7934M| 593M 56.6M  526M 6618M|   0    36k   26k   17k
> > > > > 27-08 20:52:14| 53  37   1   3   7   0|3008k 1976k|   0     0 |   0     0 |1513  1972k|   0  7934M| 541M 56.6M  529M 6668M|   0    10k 9986    23k
> > > > > 27-08 20:52:15| 55  34   1   4   6   0|3636k 1284k|   0     0 |   0     0 |1645  1688k|   0  7934M| 581M 56.6M  535M 6622M|   0    43k   30k   18k
> > > > > 27-08 20:52:16| 57  30   5   2   5   0|4404k 2320k|   0     0 |   0     0 |1715  1489k|   0  7934M| 570M 56.6M  541M 6627M|   0    39k   24k   26k
> > > > > 27-08 20:52:17| 50  35   3   7   6   0|2520k 1972k|   0     0 |   0     0 |1699  1598k|   0  7934M| 587M 56.6M  554M 6596M|   0    65k   40k   32k
> > > > > 27-08 20:52:18| 52  40   2   1   7   0|1556k 1732k|   0     0 |   0     0 |1582  1865k|   0  7934M| 551M 56.6M  567M 6619M|   0    35k   26k   33k
> > > > > 27-08 20:52:19| 26  62   0   0  12   0|   0     0 |   0     0 |   0     0 |1351  3240k|   0  7934M| 551M 56.6M  568M 6619M|   0    86   440   214 
> > > > > 27-08 20:52:20| 26  63   0   0  11   0|   0   108k|   0     0 |   0     0 |1392  3162k|   0  7934M| 555M 56.6M  560M 6623M|   0  1801  1490  2672 
> > > > > 27-08 20:52:21| 25  63   0   0  12   0|   0     0 |   0     0 |   0     0 |1332  3198k|   0  7934M| 555M 56.6M  560M 6623M|   0    50   245   255 
> > > > > 27-08 20:52:22| 25  63   1   0  12   0|   0     0 |   0     0 |   0     0 |1350  3220k|   0  7934M| 556M 56.6M  560M 6622M|   0   755   544   286 
> > > > > 27-08 20:52:23| 27  62   1   0  11   0|   0   272k|   0     0 |   0     0 |1323  3092k|   0  7934M| 551M 56.6M  558M 6628M|   0   341  1464  3085 
> > > > > 27-08 20:52:24| 25  63   0   0  12   0|   0     0 |   0     0 |   0     0 |1334  3197k|   0  7934M| 551M 56.6M  559M 6627M|   0    63   514   273 
> > > > > 27-08 20:52:25| 25  63   0   0  12   0|   0    40k|   0     0 |   0     0 |1329  3243k|   0  7934M| 546M 56.6M  558M 6633M|   0   321   160  1679 
> > > > > 27-08 20:52:26| 39  50   1   1   9   0|  48k  644k|   0     0 |   0     0 |1500  2556k|   0  7934M| 552M 56.6M  560M 6625M|   0    30k   14k   12k
> > > > > 27-08 20:52:27| 26  62   1   0  11   0|   0   192k|   0     0 |   0     0 |1380  3152k|   0  7934M| 553M 56.6M  560M 6624M|   0  2370   808   718 
> > > > > 27-08 20:52:28| 23  55  12   0  10   0|   0     0 |   0     0 |   0     0 |1247  2993k|   0  7934M| 553M 56.6M  561M 6624M|   0  1060   428   241 
> > > > > 27-08 20:52:29| 25  63   1   0  11   0|   0     0 |   0     0 |   0     0 |1318  3142k|   0  7934M| 554M 56.6M  561M 6623M|   0   663   442   198 
> > > > > 27-08 20:52:30| 25  64   0   0  12   0|   0   100k|   0     0 |   0     0 |1316  3212k|   0  7934M| 554M 56.6M  561M 6623M|   0    42   187   186 
> > > > > 27-08 20:52:31| 24  64   0   0  12   0|   0  4096B|   0     0 |   0     0 |1309  3222k|   0  7934M| 554M 56.6M  561M 6623M|   0     9    85    85 
> > > > > 27-08 20:52:32| 24  64   0   0  12   0|   0     0 |   0     0 |   0     0 |1297  3219k|   0  7934M| 554M 56.6M  561M 6623M|   0    23    95    84 
> > > > > 27-08 20:52:33| 25  63   0   0  11   0|   0     0 |   0     0 |   0     0 |1339  3101k|   0  7934M| 555M 56.6M  557M 6625M|   0   923  1566  2176 
> > > > > 27-08 20:52:34| 25  63   0   0  11   0|   0     0 |   0     0 |   0     0 |1333  3095k|   0  7934M| 555M 56.6M  559M 6623M|   0   114   701   195 
> > > > > 27-08 20:52:35| 26  63   0   0  11   0|   0     0 |   0     0 |   0     0 |1342  3036k|   0  7934M| 557M 56.6M  568M 6613M|   0   957  3225   516 
> > > > > 27-08 20:52:36| 26  60   2   0  11   0|   0    28k|   0     0 |   0     0 |1340  3091k|   0  7934M| 555M 56.6M  568M 6614M|   0  5304  5422  5609 
> > > > > 27-08 20:52:37| 25  64   0   0  12   0|   0     0 |   0     0 |   0     0 |1348  3260k|   0  7934M| 556M 56.6M  565M 6617M|   0    30   156  1073 
> > > > > 27-08 20:52:38| 24  64   0   0  12   0|   0     0 |   0     0 |   0     0 |1314  3211k|   0  7934M| 556M 56.6M  549M 6633M|   0    11   105  4285 
> > > > > 27-08 20:52:39| 26  63   0   0  11   0|   0     0 |   0     0 |   0     0 |1353  3031k|   0  7934M| 558M 56.6M  559M 6620M|   0   847  3866   357 
> > > > > 27-08 20:52:40| 26  63   0   0  12   0|   0     0 |   0     0 |   0     0 |1309  3135k|   0  7934M| 569M 56.6M  566M 6602M|   0  3940  5727  1288 
> > > > 
> > > > Interesting. The number of context switches drops during the time
> > > > that throughput improves. It would be good to find out what task(s)
> > > > are doing all of the context switches. One way to find the pids of the
> > > > top 20 context-switching tasks should be something like this:
> > > > 
> > > > grep ctxt /proc/*/status | sort -k2nr | head -20
> > > > 
> > > > You could use any number of methods to map back to the command.
> > > > When generating my last patch, I was assuming that ksoftirqd would be
> > > > the big offender. Of course, if it is something else, I should be
> > > > taking a different approach.
> > > 
> > > I did some measuring of these context switches. I used the above command
> > > line to get the number of context switches before compiling and about 40
> > > seconds later.
> > > 
> > > The good case is:
> > > file                                        before  after   process name
> > > /proc/10/status:voluntary_ctxt_switches:    38108   54327   [rcu_sched]
> > > /proc/19/status:voluntary_ctxt_switches:    31022   38682   [ksoftirqd/2]
> > > /proc/14/status:voluntary_ctxt_switches:    12947   16914   [ksoftirqd/1]
> > > /proc/3/status:voluntary_ctxt_switches:     11061   14885   [ksoftirqd/0]
> > > /proc/194/status:voluntary_ctxt_switches:   10044   11660   [kworker/2:1H]
> > > /proc/1603/status:voluntary_ctxt_switches:  7626    9593    /usr/bin/X
> > > /proc/24/status:voluntary_ctxt_switches:    6415    9571    [ksoftirqd/3]
> > > /proc/20/status:voluntary_ctxt_switches:    5317    8879    [kworker/2:0]
> > > 
> > > The bad case is:
> > > file                                            before      after       process name
> > > /proc/3/status:voluntary_ctxt_switches:         82411972    98542227    [ksoftirqd/0]
> > > /proc/23/status:voluntary_ctxt_switches:        79592040    94206823    [ksoftirqd/3]
> > > /proc/13/status:voluntary_ctxt_switches:        79053870    93654161    [ksoftirqd/1]
> > > /proc/18/status:voluntary_ctxt_switches:        78136449    92288688    [ksoftirqd/2]
> > > /proc/2293/status:nonvoluntary_ctxt_switches:   29038881    29038881    mate-panel
> > > /proc/2308/status:nonvoluntary_ctxt_switches:   26607661    26607661    nm-applet
> > > /proc/2317/status:nonvoluntary_ctxt_switches:   15494474    15494474    /usr/lib/polkit-mate/polkit-mate-authentication-agent-1
> > > /proc/2148/status:nonvoluntary_ctxt_switches:   13763674    13763674    x-session-manager
> > > /proc/2985/status:nonvoluntary_ctxt_switches:               12062706    python /usr/bin/scons -j4
> > > /proc/2323/status:nonvoluntary_ctxt_switches:   11581510    11581510    mate-volume-control-applet
> > > /proc/2353/status:nonvoluntary_ctxt_switches:   9213436     9213436     mate-power-manager
> > > /proc/2305/status:nonvoluntary_ctxt_switches:   8328471     8328471     /usr/lib/matecomponent/matecomponent-activation-server
> > > /proc/3041/status:nonvoluntary_ctxt_switches:               7638312     sh -c "/opt/arm-2011.03/bin/arm-none-eabi-gcc" [...]
> > > /proc/3055/status:nonvoluntary_ctxt_switches:               4843977     sh -c "/opt/arm-2011.03/bin/arm-none-eabi-gcc" [...]
> > > /proc/2253/status:nonvoluntary_ctxt_switches:   4449918     4449918     mate-keyring-daemon
> > 
> > Thank you for the info!
> > 
> > > The processes for the tables were partly collected by hand so they may
> > > not contain every relevant process. But what I see is that there are a
> > > lot more context switches in the bad case, quite many of these are non
> > > voluntary. The context switch increase is pretty much everywhere, not
> > > just ksoftirqd. I suspect the Mate related processes did their context
> > > switches during bootup/login, which is consistent with the bootup/login
> > > procedure being significantly slower (just like the compilation).
> > 
> > Also, the non-ksoftirq context switches are nonvoluntary, which likely
> > means that some of their context switches were preemptions by ksoftirqd.
> > 
> > OK, time to look at whatever else might be causing this...
> 
> I am still unable to reproduce this, so am reduced to shooting in the
> dark. The attached patch could in theory help. If it doesn't, would
> you be willing to do a bit of RCU event tracing?
> 
> Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
>  rcu: Throttle invoke_rcu_core() invocations due to non-lazy callbacks
>  
>  If a non-lazy callback arrives on a CPU that has previously gone idle
>  with no non-lazy callbacks, invoke_rcu_core() forces the RCU core to
>  run. However, it does not update the conditions, which could result
>  in several closely spaced invocations of the RCU core, which in turn
>  could result in an excessively high context-switch rate and resulting
>  high overhead.
>  
>  This commit therefore updates the ->all_lazy and ->nonlazy_posted_snap
>  fields to prevent closely spaced invocations.
>  
>  Reported-by: Tibor Billes <tbilles@gmx.com>
>  Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index dc09fb0..9d445ab 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -1745,6 +1745,8 @@ static void rcu_prepare_for_idle(int cpu)
>   */
>   if (rdtp->all_lazy &&
>   rdtp->nonlazy_posted != rdtp->nonlazy_posted_snap) {
> + rdtp->all_lazy = false;
> + rdtp->nonlazy_posted_snap = rdtp->nonlazy_posted;
>   invoke_rcu_core();
>   return;
>   }

Good news Paul, the above patch did solve this issue :) I see no extra
context switches, no extra CPU usage and no extra compile time.

Any idea why couldn't you reproduce this? Why did it only hit my system?

Tibor
