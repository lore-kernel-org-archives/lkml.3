Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbaFSGE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 02:04:26 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:36277 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaFSGEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 02:04:25 -0400
X-AuditID: 85900ec0-d452db9000001514-89-53a27d65b383
Message-ID: <53A27D66.6070409@hitachi.com>
Date: Thu, 19 Jun 2014 15:04:22 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Jet Chen <jet.chen@intel.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [tracing] 939c7a4f04f: -46.4% cpuidle.C3-IVT.time
References: <53A10460.1040705@intel.com>
In-Reply-To: <53A10460.1040705@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jet,

Thank you for your report.
I have some questions for your test.

1. Did you enable ftrace?
This patch added a feature for ftrace. If you disabled ftrace in
this test, my patch will not affect the system. Moreover, in my patch,
arrays for saved_cmdlines were just changed from using static global
variables to using kmalloc() on default setting. So, even if you enabled
ftrace, this patch will not induce a big problem, I think.

2. How did you test it and what does the result mean?
Please tell me the workload, how to calculate the score,
system settings, etc...

Thanks,
Yoshihiro YUNOMAE

(2014/06/18 12:15), Jet Chen wrote:
> Hi Yoshihiro,
>
> FYI, we noticed the below changes on
>
> commit 939c7a4f04fcd2162109744e8bf88194948a6e65 ("tracing: Introduce
> saved_cmdlines_size file")
>
> test case: brickland3/aim7/3000-brk_test
>
> beba4bb096201ce  939c7a4f04fcd2162109744e8
> ---------------  -------------------------
>      352643 ~40%     -46.4%     189136 ~15%  TOTAL cpuidle.C3-IVT.time
>         750 ~ 2%     -13.3%        650 ~ 2%  TOTAL vmstat.procs.b
>      362016 ~ 3%      -6.0%     340296 ~ 3%  TOTAL
> proc-vmstat.pgmigrate_success
>      362016 ~ 3%      -6.0%     340296 ~ 3%  TOTAL
> proc-vmstat.numa_pages_migrated
>     1642328 ~ 3%     +13.3%    1860721 ~ 2%  TOTAL softirqs.RCU
>     2278829 ~ 2%     -14.0%    1959647 ~ 2%  TOTAL
> time.voluntary_context_switches
>         207 ~ 0%     -10.4%        185 ~ 0%  TOTAL time.user_time
>              ~ 0%      +8.5%            ~ 0%  TOTAL turbostat.RAM_W
>     4418246 ~ 3%      -6.4%    4136447 ~ 1%  TOTAL time.minor_page_faults
>             ~ 0%      +3.4%            ~ 0%  TOTAL turbostat.Cor_W
>             ~ 0%      +3.0%            ~ 0%  TOTAL turbostat.Pkg_W
>    11354889 ~ 0%      +2.0%   11579897 ~ 0%  TOTAL
> time.involuntary_context_switches
>
> Legend:
>      ~XX%    - stddev percent
>      [+-]XX% - change percent
>
>
>                              time.voluntary_context_switches
>
>    2.4e+06
> ++---------------------------------------------------*------------+
>            *..                         *..                    ..
> ..         |
>    2.3e+06 ++      .*..          *.. ..
> *               |
>            |  *..*.    .  .*.. ..   *     *..               +
> *..   *..*
>            |            *.    *              .     .*..*.. +
> ..   |
>    2.2e+06 ++                                 *..*.       *
> *     |
>
> |                                                                 |
>    2.1e+06
> ++                                                                |
>
> |                                                                 |
>      2e+06 O+                                 O           O
> O     |
>            |                     O     O                     O
> O        |
>            |        O   O  O  O
> O                           |
>    1.9e+06 ++ O  O                                  O
> O            |
>            |                        O     O
> O                     |
>    1.8e+06
> ++----------------------------------------------------------------+
>
>
>                                    turbostat.Pkg_W
>
>     ++--------------------------------------------------------------------+
>     O+ O   O     O      O                O                                |
>     |         O      O     O   O  O  O      O      O     O   O  O  O      |
>     ++                                         O      O                   |
>     ++                                                                    |
>     ++                                                                    |
>     ++                                                                    |
>     |                                                                     |
>     ++                                                                    |
>     ++                                                                    |
>     ++        *..      .*..                                               |
>     *+.*... ..   *...*.    *...*..*..*...*..*..  ..*..   *...*..*..*...*..*
>     |      *                                   *.      ..                 |
>     ++                                                *                   |
>     ++--------------------------------------------------------------------+
>
>
>                                    turbostat.Cor_W
>
>     ++--------------------------------------------------------------------+
>     O+ O   O  O  O   O  O                O  O                      O      |
>     |                      O   O  O  O         O   O  O  O   O  O         |
>     ++                                                                    |
>     ++                                                                    |
>     |                                                                     |
>     ++                                                                    |
>     ++                                                                    |
>     ++                                                                    |
>     |                                                                     |
>     ++        *..                                                         |
>     *+.*... ..   *...*..*..*...*..*..*...*..*..  ..*..   *...  .*..*...*..*
>     |      *                                   *.      ..    *.           |
>     ++                                                *                   |
>     ++--------------------------------------------------------------------+
>
>
>                                   turbostat.RAM_W
>
>    ++---------------------------------------------------------------------+
>    |  O      O         O                O   O         O         O  O      |
>    O+     O         O      O  O  O   O         O  O      O  O             |
>    |             O                                                        |
>    ++                                                                     |
>    |                                                                      |
>    ++                                                                     |
>    |                                                                      |
>    ++                                                                     |
>    |                   *                                                  |
>    ++                .. +                      *..                        |
>    |            .*..*    +    *..       *..   +     ..*..*..      .*...   |
>    ++         ..          + ..        ..   . +    *.        *...*.     *..*
>    *..*...*..*             *     *...*      *                             |
>    ++---------------------------------------------------------------------+
>
>
>      [*] bisect-good sample
>      [O] bisect-bad  sample
>
>
> Disclaimer:
> Results have been estimated based on internal Intel analysis and are
> provided
> for informational purposes only. Any difference in system hardware or
> software
> design or configuration may affect actual performance.
>
> Thanks,
> Jet
>
>

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


