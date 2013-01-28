Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab3A1HVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 02:21:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:52545 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab3A1HVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 02:21:11 -0500
Message-ID: <1359357629.5783.68.camel@marge.simpson.net>
Subject: Re: [patch v4 0/18] sched: simplified fork, release load avg and
 power awareness scheduling
From: Mike Galbraith <bitbucket@online.de>
To: Alex Shi <alex.shi@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, torvalds@linux-foundation.org,
        mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        namhyung@kernel.org, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org
Date: Mon, 28 Jan 2013 08:20:29 +0100
In-Reply-To: <1359355337.5783.56.camel@marge.simpson.net>
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
	 <20130124094439.GB13463@pd.tnic> <51014E34.60309@intel.com>
	 <510493E4.8060602@intel.com> <1359261385.5803.46.camel@marge.simpson.net>
	 <20130127103508.GB8894@pd.tnic> <51052ACB.3070703@intel.com>
	 <1359301903.5805.11.camel@marge.simpson.net>
	 <1359350266.5783.39.camel@marge.simpson.net> <510611D2.1020007@intel.com>
	 <1359353720.5783.51.camel@marge.simpson.net>
	 <1359355337.5783.56.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:A4X1G5Md3WaraV2PBh8D47GzKMPgmrYVF/B5WlbiOKG
 6QcImohC5UYv5g7N51rY/WYzl2LUgCQcl35b9qOU0mjcGKUZbR
 LDPvoXCnWOPUmc1GAkDrU6kOx+Ware60cu89EHT1oGPxiQjvRo
 rVzzuiKYaX1GZ1PruI9UiKXbXUBHliC/DEUthhusZHUodGQHQS
 M+aloNOcI/Atr22FvM5Yt5UyY7rJuesdfoCuLPR4kTtx/Y+nZV
 2rlGEGHPkO6sk0BKhdwyJRFJab+9RCUUTFFFog/oa8UldBUYgg
 F255nUpfS5cZDQd/i0O/NCAmPeY91pratT778lZS9iU3wdGGVe
 H3BJK8R5YsoUYFfyFju2k85/d07PMheU9Yv0CrNqCbq9i+Pimk
 0lQrOPVuPmNhA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-28 at 07:42 +0100, Mike Galbraith wrote:

> Back to original 1ms sleep, 8ms work, turning NUMA box into a single
> node 10 core box with numactl.

(aim7 in one 10 core node.. so spread, no delta.)

Benchmark       Version Machine Run Date
AIM Multiuser Benchmark - Suite VII     "1.1"   powersaving     Jan 28 08:04:14 2013

Tasks   Jobs/Min        JTI     Real    CPU     Jobs/sec/task
1       441.0           100     13.7    3.7     7.3508
5       2516.6          98      12.0    8.1     8.3887
10      5215.1          98      11.6    11.9    8.6919
20      10475.4         99      11.6    21.7    8.7295
40      20216.8         99      12.0    38.2    8.4237
80      35568.6         99      13.6    71.4    7.4101
160     57102.5         98      17.0    138.2   5.9482
320     82099.9         97      23.6    271.1   4.2760
Benchmark       Version Machine Run Date
AIM Multiuser Benchmark - Suite VII     "1.1"   balance Jan 28 08:06:49 2013

Tasks   Jobs/Min        JTI     Real    CPU     Jobs/sec/task
1       439.4           100     13.8    3.8     7.3241
5       2583.1          98      11.7    7.2     8.6104
10      5325.1          99      11.4    11.0    8.8752
20      10687.8         99      11.3    23.6    8.9065
40      20200.0         99      12.0    38.7    8.4167
80      35464.5         98      13.7    71.4    7.3884
160     57203.5         98      16.9    137.9   5.9587
320     82065.2         98      23.6    271.1   4.2742
Benchmark       Version Machine Run Date
AIM Multiuser Benchmark - Suite VII     "1.1"   performance     Jan 28 08:09:20 2013

Tasks   Jobs/Min        JTI     Real    CPU     Jobs/sec/task
1       438.8           100     13.8    3.8     7.3135
5       2634.8          99      11.5    7.2     8.7826
10      5396.3          99      11.2    11.4    8.9938
20      10725.7         99      11.3    24.0    8.9381
40      20183.2         99      12.0    38.5    8.4097
80      35620.9         99      13.6    71.4    7.4210
160     57203.5         98      16.9    137.8   5.9587
320     81995.8         98      23.7    271.3   4.2706

