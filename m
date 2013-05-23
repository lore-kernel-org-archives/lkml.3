Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab3EWCMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 22:12:46 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:48849 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756474Ab3EWCMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 22:12:45 -0400
Message-ID: <519D7B0F.9060805@linux.vnet.ibm.com>
Date: Thu, 23 May 2013 10:12:31 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH v2] sched: wake-affine throttle
References: <5164DCE7.8080906@linux.vnet.ibm.com> <519AE7F2.706@linux.vnet.ibm.com> <20130522084947.GQ26912@twins.programming.kicks-ass.net> <519C8F24.5060207@linux.vnet.ibm.com> <1369234551.5916.40.camel@marge.simpson.net>
In-Reply-To: <1369234551.5916.40.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052302-6102-0000-0000-00000392126F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 10:55 PM, Mike Galbraith wrote:
> On Wed, 2013-05-22 at 17:25 +0800, Michael Wang wrote:
> 
>> I've not test the hackbench with wakeup-buddy before, will do it this
>> time, I suppose the 15% illegal income will suffered, anyway, it's
>> illegal :)
> 

Thanks, Mike, these are very helpful data ;-)

> On a 4 socket 40 core (+SMT) box, hackbench wasn't too happy.

I'm not sure whether this is caused by the SOFT IRQ case, I have some
idea in mind which may could help to solve that issue, but if this huge
regression is caused by other reasons...

Anyway, I will rework on the idea and let's see whether we could make
things better :)

Regards,
Michael Wang

> 
> defaultx = wakeup buddy
> 
> tbench 30 localhost
>                          1       5       10       20       40       80      160      320
> 3.10.0-default      188.13  953.03  1860.03  3180.93  5378.34 10826.06 11342.90 11651.30
> 3.10.0-defaultx     187.26  934.55  1859.30  3160.29  5016.35 12477.15 12567.05 12068.47
> 
> hackbench -l 400 -g 400
> 3.10.0-default     Time: 3.919    4.250     4.116
> 3.10.0-defaultx    Time: 9.074   10.985     9.849
> 
> aim7 compute
> AIM Multiuser Benchmark - Suite VII     "1.1"   3.10.0-default     AIM Multiuser Benchmark - Suite VII     "1.1"   3.10.0-defaultx
> 
> Tasks   Jobs/Min        JTI     Real    CPU     Jobs/sec/task      Tasks   Jobs/Min        JTI     Real    CPU     Jobs/sec/task
> 1       428.0           100     14.2    4.1     7.1328             1       428.9           100     14.1    4.1     7.1479
> 1       417.9           100     14.5    4.1     6.9655             1       430.4           100     14.1    4.0     7.1733
> 1       427.7           100     14.2    4.2     7.1277             1       424.7           100     14.3    4.2     7.0778
> 5       2350.7          99      12.9    13.8    7.8355             5       2156.6          99      14.1    19.8    7.1886
> 5       2422.1          99      12.5    12.1    8.0735             5       2155.0          99      14.1    19.7    7.1835
> 5       2189.3          98      13.8    18.3    7.2977             5       2108.6          99      14.4    21.4    7.0285
> 10      4515.6          93      13.4    27.6    7.5261             10      4529.1          96      13.4    29.5    7.5486
> 10      4708.6          96      12.9    24.3    7.8477             10      4597.9          96      13.2    26.9    7.6631
> 10      4636.6          96      13.1    25.7    7.7276             10      5197.3          98      11.7    14.8    8.6621
> 20      8053.2          95      15.1    78.1    6.7110             20      9431.9          98      12.8    49.1    7.8599
> 20      8250.5          92      14.7    67.5    6.8754             20      7973.7          97      15.2    93.4    6.6447
> 20      8178.1          97      14.8    78.5    6.8151             20      8145.2          95      14.9    78.4    6.7876
> 40      17413.8         94      13.9    88.6    7.2557             40      16312.2         92      14.9    115.6   6.7968
> 40      16775.1         93      14.5    111.6   6.9896             40      17070.4         94      14.2    110.6   7.1127
> 40      16031.7         93      15.1    147.1   6.6799             40      17578.0         94      13.8    96.9    7.3241
> 80      33666.7         95      14.4    138.4   7.0139             80      33854.7         96      14.3    177.9   7.0531
> 80      33949.6         97      14.3    128.0   7.0728             80      34164.9         96      14.2    146.4   7.1177
> 80      35752.2         96      13.6    159.1   7.4484             80      33807.5         96      14.3    127.6   7.0432
> 160     74814.8         98      13.0    149.8   7.7932             160     75162.8         98      12.9    148.6   7.8295
> 160     74015.3         97      13.1    149.5   7.7099             160     74642.0         98      13.0    168.2   7.7752
> 160     73621.9         98      13.2    146.3   7.6689             160     75572.9         98      12.8    163.6   7.8722
> 320     139210.3        96      13.9    280.1   7.2505             320     139010.8        97      14.0    282.4   7.2401
> 320     135135.9        96      14.3    277.8   7.0383             320     139611.2        96      13.9    282.2   7.2714
> 320     139110.5        96      13.9    280.4   7.2453             320     138514.3        97      14.0    281.0   7.2143
> 640     223538.9        98      17.4    577.2   5.8213             640     224704.5        95      17.3    567.3   5.8517
> 640     224055.5        97      17.3    575.7   5.8348             640     222385.3        95      17.4    580.1   5.7913
> 640     225488.4        96      17.2    566.3   5.8721             640     225882.4        93      17.2    563.0   5.8824
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

