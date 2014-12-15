Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbaLODOA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 22:14:00 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:52443 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750810AbaLODNy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 22:13:54 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="45148821"
Message-ID: <548E4E31.6050405@cn.fujitsu.com>
Date: Mon, 15 Dec 2014 10:57:53 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Huang Ying <ying.huang@linux.intel.com>
CC: Benjamin LaHaise <bcrl@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        LKP ML <lkp@01.org>
Subject: Re: [LKP] [aio] 6098b45b32e: 2200.00% xfstests.generic.239.seconds
References: <1418605329.5745.141.camel@linux.intel.com>
In-Reply-To: <1418605329.5745.141.camel@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huang,
On 12/15/2014 09:02 AM, Huang Ying wrote:

> FYI, we noticed the below changes on
> 
> commit 6098b45b32e6baeacc04790773ced9340601d511 ("aio: block exit_aio() until all context requests are completed")

This patch added a wait step (which is lacked before) for all submitted aio
missions (iocbs) to complete in exit_aio(), so the cost-time increasing is
expected.

Thanks,
Gu

> 
> 
> testbox/testcase/testparams: vm-vp-2G/xfstests/4HDD-btrfs-generic-quick
> 
> 2ff396be602f10b5  6098b45b32e6baeacc04790773  
> ----------------  --------------------------  
>          %stddev     %change         %stddev
>              \          |                \  
>      26352 ±  9%     -13.6%      22774 ±  1%  vmstat.system.cs
>      10342 ±  6%     -12.3%       9066 ±  0%  vmstat.system.in
>         37 ±  4%     -12.1%         32 ±  3%  time.percent_of_cpu_this_job_got
>       1197 ±  2%     -14.2%       1028 ±  0%  vmstat.io.bi
>      18470 ±  2%     -10.1%      16609 ±  1%  vmstat.io.bo
>        157 ±  3%     +13.7%        179 ±  0%  time.elapsed_time
> 
> vm-vp-2G: qemu-system-x86_64 -enable-kvm -cpu Penryn
> Memory: 2G
> 
>                           xfstests.generic.239.seconds
> 
>   30 ++-----------O---------------------------------------------------------+
>      |              O         O            O         O                      |
>   25 ++                O                                                    |
>      |  O O  O O            O    O O  O  O    O O  O                        |
>      |                   O                                                  |
>   20 O+                                                                     |
>      |                                                                      |
>   15 ++                                                                     |
>      |                                                                      |
>   10 ++                                                                     |
>      |                                                                      |
>      |                                                                      |
>    5 ++                                                                     |
>      |                                                                      |
>    0 *+-*-*--*-*--*-*--*-*--*-*--*-*--*--*-*--*-*--*-*--*-*--*-*--*-*--*-*--*
> 
> 
> 	[*] bisect-good sample
> 	[O] bisect-bad  sample
> 
> To reproduce:
> 
> 	apt-get install ruby ruby-oj
> 	git clone git://git.kernel.org/pub/scm/linux/kernel/git/wfg/lkp-tests.git
> 	cd lkp-tests
> 	bin/setup-local job.yaml # the job file attached in this email
> 	bin/run-local   job.yaml
> 
> 
> Disclaimer:
> Results have been estimated based on internal Intel analysis and are provided
> for informational purposes only. Any difference in system hardware or software
> design or configuration may affect actual performance.
> 
> 
> Thanks,
> Fengguang
> 
> 
> 
> 
> _______________________________________________
> LKP mailing list
> LKP@linux.intel.com
> 


