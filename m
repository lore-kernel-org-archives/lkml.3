Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbaBSRHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 12:07:36 -0500
Received: from demumfd001.nsn-inter.net ([93.183.12.32]:14154 "EHLO
	demumfd001.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbaBSRHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 12:07:34 -0500
Message-ID: <5304E49A.3000801@nsn.com>
Date: Wed, 19 Feb 2014 18:06:34 +0100
From: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nsn.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: ext Fengguang Wu <fengguang.wu@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
Subject: Re: [sctp] ef2820a735: -50% netperf Throughput_Mbps
References: <20140219132034.GC8704@localhost>
In-Reply-To: <20140219132034.GC8704@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 5006
X-purgate-ID: 151667::1392829650-00005322-69FE4D5D/0-0/0-0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Fengguang,

On 02/19/2014 02:20 PM, ext Fengguang Wu wrote:
> Hi Matija,
> 
> We noticed the below changes on commit ef2820a735f74ea60335f8ba3801b844f0cb184d
> (" net: sctp: Fix a_rwnd/rwnd management to reflect real state of the receiver's buffer")
> in netperf SCTP_STREAM tests:

thanks for the info. Though, I've ran netperf in my environment, with and without patch, and I havent observed any difference.

Could you please give me information on your environment, how do you invoke netperf, and other details you think I might be interested in to observe problem by myself

Thanks!

> cd0f0b95fd2cd2b  ef2820a735f74ea60335f8ba3  
> ---------------  -------------------------  
>          8 ~ 0%     -50.0%          4 ~ 0%  TOTAL netperf.Throughput_Mbps
>      54287 ~44%    +338.1%     237842 ~48%  TOTAL cpuidle.C1E-NHM.time
>   12008353 ~12%     -56.0%    5281848 ~ 0%  TOTAL proc-vmstat.pgalloc_normal
>     114861 ~ 0%     -50.3%      57085 ~ 3%  TOTAL softirqs.NET_RX
>   12964639 ~11%     -55.1%    5818663 ~ 0%  TOTAL proc-vmstat.pgfree
>     866489 ~ 0%     -43.3%     491417 ~ 0%  TOTAL proc-vmstat.pgalloc_dma32
>     119373 ~17%     -39.1%      72661 ~ 1%  TOTAL softirqs.SCHED
>       1985 ~13%     -24.3%       1502 ~19%  TOTAL slabinfo.kmalloc-128.active_objs
>       2139 ~20%     -28.4%       1532 ~ 4%  TOTAL proc-vmstat.nr_alloc_batch
>     124360 ~33%     -31.0%      85748 ~ 2%  TOTAL softirqs.RCU
>       1977 ~ 9%     -18.5%       1610 ~ 9%  TOTAL slabinfo.UDP.active_objs
>       1977 ~ 9%     -18.5%       1610 ~ 9%  TOTAL slabinfo.UDP.num_objs
>       2066 ~ 6%     -12.9%       1800 ~ 7%  TOTAL slabinfo.kmalloc-128.num_objs
>       1738 ~10%     -18.4%       1418 ~ 9%  TOTAL slabinfo.UDPv6.active_objs
>       1738 ~10%     -18.4%       1418 ~ 9%  TOTAL slabinfo.UDPv6.num_objs
>        923 ~10%     -17.7%        760 ~ 8%  TOTAL slabinfo.TCPv6.active_objs
>        923 ~10%     -17.7%        760 ~ 8%  TOTAL slabinfo.TCPv6.num_objs
>        989 ~ 9%     -17.1%        820 ~ 7%  TOTAL slabinfo.TCP.active_objs
>        989 ~ 9%     -17.1%        820 ~ 7%  TOTAL slabinfo.TCP.num_objs
>     398761 ~44%     -32.6%     268792 ~ 3%  TOTAL numa-vmstat.node2.numa_hit
>     389672 ~49%     -32.9%     261443 ~ 3%  TOTAL numa-vmstat.node0.numa_hit
>        447 ~ 1%     -13.8%        385 ~ 0%  TOTAL vmstat.system.cs
> 
> Note: the "~ XX%" numbers are stddev percent.
> 
>                               netperf.Throughput_Mbps
> 
>      4 *+-*--*--*--*-*--*--*--*--*--*--*--*-*--*--*--*--*--*--*--*-*--*--*--*
>        |                                                                    |
>        |                                                                    |
>    3.5 ++                                                                   |
>        |                                                                    |
>        |                                                                    |
>        |                                                                    |
>      3 ++                                                                   |
>        |                                                                    |
>        |                                                                    |
>    2.5 ++                                                                   |
>        |                                                                    |
>        |                                                                    |
>        |                                                                    |
>      2 O+-O--O--O--O-O--O--O--O--O--O--O--O-O--O--O--O--O--O--O-------------+
> 
> 
>                                  vmstat.system.cs
> 
>    460 ++------------------------*--*----------------*----------------------+
>        |       .*..    .*..     :    +              +              *..     .*
>    450 ++    *.     .*.    *..  :     +    .*..*.. +    *..*..*.. +     .*. |
>    440 *+   :      *           :       *..*       *              *    *.    |
>        |:   :                 *                                             |
>    430 ++: :                                                                |
>    420 ++: :                                                                |
>        |  *                                                                 |
>    410 ++                                                                   |
>    400 ++                                                                   |
>        |                                                                    |
>    390 ++            O        O             O     O        O                |
>    380 O+ O  O  O       O  O     O  O  O  O    O     O  O     O             |
>        |           O                                                        |
>    370 ++-------------------------------------------------------------------+
> 
