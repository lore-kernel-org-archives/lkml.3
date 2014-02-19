Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbaBSNBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 08:01:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:45451 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505AbaBSNBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 08:01:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,505,1389772800"; 
   d="png'150?scan'150,208,150";a="477635142"
Date: Wed, 19 Feb 2014 21:00:28 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Alex Shi <alex.shi@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [sched/balance] 7511dd0a7: +2.1e+05% context switches
Message-ID: <20140219130028.GB8169@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Alex,

We noticed the below changes for commit

commit 7511dd0a73aaf2ca4bcd829f991dcd2c839c5417
Author:     Alex Shi <alex.shi@linaro.org>
AuthorDate: Fri Jan 24 15:17:02 2014 +0800
Commit:     Alex Shi <alex.shi@linaro.org>
CommitDate: Fri Feb 14 15:09:01 2014 +0800

    sched: only do load balance on tick_do_timer_cpu
    
    that is a central balance.
    
    Signed-off-by: Alex Shi <alex.shi@linaro.org>

bc575710efe937e  7511dd0a73aaf2ca4bcd829f9
---------------  -------------------------
     83892 ~ 5%     -96.1%       3245 ~ 7%  lkp-snb01/micro/will-it-scale/pthread_mutex2
     86509 ~ 5%     -96.2%       3271 ~ 6%  lkp-snb01/micro/will-it-scale/sched_yield
    170401 ~ 5%     -96.2%       6517 ~ 7%  TOTAL softirqs.SCHED

bc575710efe937e  7511dd0a73aaf2ca4bcd829f9
---------------  -------------------------
     60321 ~ 0%     -78.5%      12962 ~ 3%  lkp-snb01/micro/will-it-scale/pthread_mutex2
     60358 ~ 0%     -80.5%      11797 ~ 4%  lkp-snb01/micro/will-it-scale/sched_yield
    120679 ~ 0%     -79.5%      24759 ~ 4%  TOTAL interrupts.RES

bc575710efe937e  7511dd0a73aaf2ca4bcd829f9
---------------  -------------------------
    105019 ~ 0%     -41.8%      61097 ~ 3%  lkp-snb01/micro/will-it-scale/pthread_mutex2
    103938 ~ 1%     -35.4%      67183 ~ 1%  lkp-snb01/micro/will-it-scale/sched_yield
    208958 ~ 0%     -38.6%     128281 ~ 2%  TOTAL cpuidle.C7-SNB.usage

bc575710efe937e  7511dd0a73aaf2ca4bcd829f9
---------------  -------------------------
      2492 ~23%     +39.8%       3483 ~14%  lkp-snb01/micro/will-it-scale/sched_yield
      2492 ~23%     +39.8%       3483 ~14%  TOTAL cpuidle.C1E-SNB.usage

bc575710efe937e  7511dd0a73aaf2ca4bcd829f9
---------------  -------------------------
       543 ~10%     +30.8%        710 ~11%  lkp-snb01/micro/will-it-scale/sched_yield
       543 ~10%     +30.8%        710 ~11%  TOTAL cpuidle.C3-SNB.usage

bc575710efe937e  7511dd0a73aaf2ca4bcd829f9
---------------  -------------------------
     20.65 ~ 0%     +24.1%      25.63 ~ 2%  lkp-snb01/micro/will-it-scale/sched_yield
     20.65 ~ 0%     +24.1%      25.63 ~ 2%  TOTAL turbostat.%c1

bc575710efe937e  7511dd0a73aaf2ca4bcd829f9
---------------  -------------------------
      1268 ~13%     +17.0%       1483 ~ 5%  lkp-snb01/micro/will-it-scale/sched_yield
      1268 ~13%     +17.0%       1483 ~ 5%  TOTAL numa-vmstat.node0.nr_alloc_batch

bc575710efe937e  7511dd0a73aaf2ca4bcd829f9
---------------  -------------------------
      7255 ~ 2%     +14.6%       8317 ~ 2%  lkp-snb01/micro/will-it-scale/pthread_mutex2
      7255 ~ 2%     +14.6%       8317 ~ 2%  TOTAL slabinfo.kmalloc-192.num_objs

bc575710efe937e  7511dd0a73aaf2ca4bcd829f9
---------------  -------------------------
      7255 ~ 2%     +14.6%       8317 ~ 2%  lkp-snb01/micro/will-it-scale/pthread_mutex2
      7255 ~ 2%     +14.6%       8317 ~ 2%  TOTAL slabinfo.kmalloc-192.active_objs

bc575710efe937e  7511dd0a73aaf2ca4bcd829f9
---------------  -------------------------
    683581 ~ 0%      -9.3%     620114 ~ 1%  lkp-snb01/micro/will-it-scale/sched_yield
    683581 ~ 0%      -9.3%     620114 ~ 1%  TOTAL softirqs.TIMER

bc575710efe937e  7511dd0a73aaf2ca4bcd829f9
---------------  -------------------------
    204033 ~ 1%      -8.6%     186557 ~ 2%  lkp-snb01/micro/will-it-scale/sched_yield
    204033 ~ 1%      -8.6%     186557 ~ 2%  TOTAL softirqs.RCU

bc575710efe937e  7511dd0a73aaf2ca4bcd829f9
---------------  -------------------------
 4.902e+09 ~ 0%      +9.8%  5.385e+09 ~ 1%  lkp-snb01/micro/will-it-scale/sched_yield
 4.902e+09 ~ 0%      +9.8%  5.385e+09 ~ 1%  TOTAL cpuidle.C7-SNB.time

bc575710efe937e  7511dd0a73aaf2ca4bcd829f9
---------------  -------------------------
      8204 ~ 2%     +11.3%       9134 ~ 4%  lkp-snb01/micro/will-it-scale/sched_yield
      8204 ~ 2%     +11.3%       9134 ~ 4%  TOTAL slabinfo.kmalloc-256.num_objs

bc575710efe937e  7511dd0a73aaf2ca4bcd829f9
---------------  -------------------------
      2405 ~25%  +2.1e+05%    5058323 ~13%  lkp-snb01/micro/will-it-scale/sched_yield
      2405 ~25%  +2.1e+05%    5058323 ~13%  TOTAL vmstat.system.cs

bc575710efe937e  7511dd0a73aaf2ca4bcd829f9
---------------  -------------------------
      2029 ~ 0%    +222.9%       6551 ~17%  lkp-snb01/micro/will-it-scale/pthread_mutex2
    143678 ~42%  +4.8e+05%  6.927e+08 ~ 0%  lkp-snb01/micro/will-it-scale/sched_yield
    145708 ~42%  +4.8e+05%  6.927e+08 ~ 0%  TOTAL time.involuntary_context_switches

bc575710efe937e  7511dd0a73aaf2ca4bcd829f9
---------------  -------------------------
      1267 ~ 0%     -22.3%        985 ~ 1%  lkp-snb01/micro/will-it-scale/sched_yield
      1267 ~ 0%     -22.3%        985 ~ 1%  TOTAL time.system_time

bc575710efe937e  7511dd0a73aaf2ca4bcd829f9
---------------  -------------------------
      1518 ~ 0%      -4.9%       1444 ~ 1%  lkp-snb01/micro/will-it-scale/pthread_mutex2
       250 ~ 4%     +26.3%        316 ~ 5%  lkp-snb01/micro/will-it-scale/sched_yield
      1769 ~ 0%      -0.5%       1761 ~ 2%  TOTAL time.user_time

bc575710efe937e  7511dd0a73aaf2ca4bcd829f9
---------------  -------------------------
       489 ~ 0%      -4.9%        464 ~ 1%  lkp-snb01/micro/will-it-scale/pthread_mutex2
       489 ~ 0%     -14.3%        419 ~ 0%  lkp-snb01/micro/will-it-scale/sched_yield
       978 ~ 0%      -9.6%        883 ~ 0%  TOTAL time.percent_of_cpu_this_job_got

bc575710efe937e  7511dd0a73aaf2ca4bcd829f9
---------------  -------------------------
     50.58 ~ 0%      -2.0%      49.56 ~ 0%  lkp-snb01/micro/will-it-scale/pthread_mutex2
     50.62 ~ 0%      -9.9%      45.62 ~ 1%  lkp-snb01/micro/will-it-scale/sched_yield
    101.20 ~ 0%      -5.9%      95.19 ~ 0%  TOTAL turbostat.%c0

bc575710efe937e  7511dd0a73aaf2ca4bcd829f9
---------------  -------------------------
      4386 ~ 0%      -5.2%       4158 ~ 0%  lkp-snb01/micro/will-it-scale/pthread_mutex2
      4386 ~ 0%      -5.2%       4158 ~ 0%  TOTAL vmstat.system.in

bc575710efe937e  7511dd0a73aaf2ca4bcd829f9
---------------  -------------------------
       148 ~ 0%      -1.9%        145 ~ 0%  lkp-snb01/micro/will-it-scale/sched_yield
       148 ~ 0%      -1.9%        145 ~ 0%  TOTAL turbostat.Pkg_W

bc575710efe937e  7511dd0a73aaf2ca4bcd829f9
---------------  -------------------------
       109 ~ 0%      -0.1%        109 ~ 0%  lkp-snb01/micro/will-it-scale/pthread_mutex2
       121 ~ 0%      -2.3%        119 ~ 0%  lkp-snb01/micro/will-it-scale/sched_yield
       231 ~ 0%      -1.3%        228 ~ 0%  TOTAL turbostat.Cor_W

                         time.percent_of_cpu_this_job_got

   490 *+-----*---*---*--*---*--*---*---*--*---*---*--*---*--*---*---*--*---*
       | ..  +                                                              |
   480 ++   +                                                               |
   470 ++  *                                                                |
       |                                                                    |
   460 ++                                                                   |
       |                                                                    |
   450 ++                                                                   |
       |                                                                    |
   440 ++                                                                   |
   430 ++                                                                   |
       |                                O                                   |
   420 O+  O  O   O   O  O   O  O   O      O   O   O  O   O  O   O   O  O   O
       |                                                                    |
   410 ++-------------------------------------------------------------------+


                          time.involuntary_context_switches

   8e+08 ++-----------------------------------------------------------------+
         |                                                                  |
   7e+08 O+  O  O   O  O   O  O   O  O      O   O  O   O  O   O  O   O  O   O
   6e+08 ++                              O                                  |
         |                                                                  |
   5e+08 ++                                                                 |
         |                                                                  |
   4e+08 ++                                                                 |
         |                                                                  |
   3e+08 ++                                                                 |
   2e+08 ++                                                                 |
         |                                                                  |
   1e+08 ++                                                                 |
         |                                                                  |
       0 *+--*--*---*--*---*--*---*--*---*--*---*--*---*--*---*--*---*--*---*


                                   turbostat.%c0

   51 *+--------------------------------------------------------------------+
      |  .  .*...*...*..*...*...*..*...*...*...*..*...*...*..*...*...*..*...*
   50 ++  *.                                                                |
      |                                                                     |
   49 ++                                                                    |
      |                                                                     |
   48 ++                                                                    |
      |                                                                     |
   47 ++                                                                    |
      |                                                                     O
   46 ++     O                                    O       O          O      |
      O   O      O   O  O   O   O  O   O   O   O      O      O          O   |
   45 ++                                                                    |
      |                                                          O          |
   44 ++--------------------------------------------------------------------+


                                  vmstat.system.cs

   6e+06 ++------------------------------------------------------O----------+
         |                    O                               O         O   |
   5e+06 O+  O      O  O   O      O  O   O  O   O      O                    |
         |      O                                  O      O                 |
         |                                                           O      O
   4e+06 ++                                                                 |
         |                                                                  |
   3e+06 ++                                                                 |
         |                                                                  |
   2e+06 ++                                                                 |
         |                                                                  |
         |                                                                  |
   1e+06 ++                                                                 |
         |                                                                  |
       0 *+--*--*---*--*---*--*---*--*---*--*---*--*---*--*---*--*---*--*---*

Thanks,
Fengguang

--VbJkn9YxBvnuCH5J
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-sched-only-do-load-balance-on-tick_do_timer_cpu.patch"

>From 7511dd0a73aaf2ca4bcd829f991dcd2c839c5417 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@linaro.org>
Date: Fri, 24 Jan 2014 15:17:02 +0800
Subject: [PATCH] sched: only do load balance on tick_do_timer_cpu

that is a central balance.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 kernel/sched/core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7368964..1be85a7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2425,6 +2425,7 @@ unsigned long long task_sched_runtime(struct task_struct *p)
 	return ns;
 }
 
+extern int tick_do_timer_cpu __read_mostly;
 /*
  * This function gets called by the timer code, with HZ frequency.
  * We call it with interrupts disabled.
@@ -2446,8 +2447,11 @@ void scheduler_tick(void)
 	perf_event_task_tick();
 
 #ifdef CONFIG_SMP
-	rq->idle_balance = idle_cpu(cpu);
-	trigger_load_balance(rq);
+	/* only do load balance on tick_do_timer_cpu */
+	if (cpu == tick_do_timer_cpu) {
+		rq->idle_balance = idle_cpu(cpu);
+		trigger_load_balance(rq);
+	}
 #endif
 	rq_last_tick_reset(rq);
 }
-- 
1.8.5.2


--VbJkn9YxBvnuCH5J
Content-Type: image/png
Content-Disposition: attachment; filename="2014-02-16_10:06:49.png"
Content-Transfer-Encoding: base64

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
VGxs7IIFCy5evFhRUXHgwIEuXbqIPykldtSuXbuioiLxjgoLC9u3b29YgDmpp02btnHjxrKy
sosXLw4cOHDFihXTpk1LTk4uLS3VLRH+90sYTa1Wd+jQIT4+/sqVK/fv3//ll18mTJggbPPK
K69s2bLlzp07wh4PHz7s5eX173//++bNm8XFxampqW3atBH/P6tQUv/+/Q8cOCAsX716datW
rXbs2CEs2b9/v+7EakCDJb2NQOJVkwiu1WqVSmVycvLdu3evXr3697///b333tPb6blz59q2
bas7OL/++mvnzp33799veBAaXIP0SSWx90uXLvn6+grnW0JCwqRJk6SP1ZYtW8QXVp3p06cv
XbrUzMjCNvXuXXxkbt261bFjxxMnTuh+PH78uPjtsHjx4gEDBuTk5JSXl5eXlx88eDAsLExX
ku4F2r59+9ChQ93c3Fq1ahUZGZmXlyeR0cxn3bt379FHHz18+LBeLqO4XGfEB0S3va+vb4sW
Ldq3bz958uQ//vhDr35Tp6X0XvSCGP5oaqfSr4KeiIgIvY9hvR1JH/96U5iKL12k9DkpcVbX
e3E2VU+97wLD88rME8/oclNlSD/RaIMlpJO+PEpX27DDIr223neuOQfhr7/+Onjw4MCBA//n
f/7HnCdKxDS/fzC6UzG9d430yFZewcRXG+H0NuvTd8yYMdu3bze15aZNm/r373/t2jVxjCVL
lohHiI+P191VM6pVq1biPkOMMbZw4ULxku+++27AgAHm7MjZ2Vnvpk51dbWLi4vRvRgu1Est
vn196NChli1bipfk5eX17dtXb7Rp06YtWLDAVK6EhAS9hRMmTNC7jZyUlPTss88alrR27Vrx
DfbQ0NDNmzeLvzCePHmy7h617RosiVdNIriesrKyLl266O30pZde+uSTT4RtMjIynn76aeFH
8evSsBqkTyqJvU+dOlXvfPvggw+kj1V1dbW/v7/4/5Nu3brVunXr4uJiMyML29S7d/GR0Wq1
u3fvfuyxx2pqampqavr375+amiqsqqurmzBhgvh/9ydMmCB8seLq6urt7S2eQeLt7Z2bmysR
05xnzZw5U1y/pQ1WA64zegdk/PjxOTk5VVVV169fT0xMbNeundCA6tE7LaX3It1gSexU+lUQ
y8/P79Spk3CP3OiOpI+/RddkcXzpIqXPSYmz2vyLs1499b4LDM8rM0+8ei964jKknzhkyJDN
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
BelN4zC6F4nU5iwRHgj/WuTq1av3798/fPiw+B+yGZZx6NChNm3a6P4V4c2bN//97397eXnp
vk4yLEmr1S5dutTJyUk8m3LTpk1OTk7JyckSVRndtd4qvdPAKIlXTSL45MmTp0yZUlhYWFxc
vGLFiueee86wsDNnzvj5+W3atOnWrVsVFRV79+7VzY01PAgNq0H6pDK1d61We/HiRV9fX+F8
+/TTTydPnixxPMUiIyP/+c9/+vr6PnjwwKKdCttI7N3wyJSVlQUFBV26dEn349mzZzt37lxW
Vqb7MSkpSalU7t69+/bt27qJNR07dvzss890a6uqqgYNGqQ3gyQ7O1s6oKXPkj5uVl5nDA/I
iBEjtm3bVlhYWF1dfeXKFZVK1bZt22PHjunWSp+W0lczvSDiH6V3Kv0q6GzZsmXUqFHmHEDp
4y+dQiK+dJHS7wiJs1r64ixRT73vwXrfj6Y2MFwuUUa9A44dO/b48ePV1dWXL1+OjY2dOXOm
sEri0iQ9eIMPi/Ra6TNHYqejR4/OyMgoLi6urq4uKChITk729/fPysqy6OgZxpQ+V6V3qmPq
XSM9coOvYIZXG+H01r+Kff/99926dWvevLluyTvvvLNo0SKjg+odrLNnzwYEBCQmJupWVVRU
TJ8+vU2bNu7u7k8++aTwjZVR+/fvj4qK0k0D7Nq167vvvvvXX38Z3YthDdI7unr16oQJEzw8
PDw8PCZMmGD4Haoh6dTmLBGvunr16pQpU3x8fJydnfv27Zueni6RS6vV7ty5MywszM3Nzc3N
LSwsbNeuXbrlhiVptdrr1697eHiIb+DfvXvXz89P/AuRG9Zg6Z0GRkm8ahLBS0tLp0yZ4uXl
1bp161deeeXu3btGCztx4sSYMWM8PDzc3NwiIiL27t1r9CA0rIZ6r5JG965z6tSp0aNHu7u7
e3l5xcTE1Pt7sAS7d+9mjOn9c2JzdirextTeDY/Miy++qPfbjd9///0XX3xR+HHr1q0DBw5s
3bp169atBwwYIBwcnRs3bkyZMqVNmzaurq6PP/64+AhIsOhZDWiwtGZfZwwPyL59+yZOnOjt
7d2iRQt/f/+XXnrp3Llzwlrp01L6IiPRYEnvVFvfq6A18XvUjO5XK3n8pVNIxK+3SOl3hMRb
SeLiLF2P9B4tbbBMfQrUW4bEE7Va7TfffNOrVy8XF5eePXuuWrVKb9KnqUuTdLXWHBbptRJn
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
cuRIv5xMS3flIrC7QuBdd53pCswR2F25SOuulFIDB5quQJ5weX3RYPmSlZVVUlLiuVJSUjJ9
+nRT9QAAgJDADJYvbW1tdrt9zpw5L7zwglJq+fLlRUVFNTU1/fv3N10aAAAIXlzB8sVms+3c
uXPfvn1JSUlJSUk///xzVVUV3RUAAPCNK1gAAACacQULAABAMxosAAAAzWiwAAAANKPBAgAA
0IwGCwAAQDMaLAAAAM1osPzC6XTm5ORER0dHR0fn5OQcOnTIdEWBsHfv3scffzw+Pn7gwIHj
xo3buHGj6YoCrampacSIEXL+q+9Lly4VFhampqZardZRo0aVl5ebrsjvLl68uGzZsjFjxsTE
xAwcODAtLW3ZsmUXL140XZdf/Prrr3Pnzo2Jien2KR3Gu5yP4GG8y/n+53YLv13Od/De7HI0
WPq1t7dnZGSkpaU1NDQ0NDSkpaVlZmaePn3adF1+N2nSpJaWlo0bNx49erSwsHDRokWrVq0y
XVTgdHZ2zp49Oz8/33QhgTN37tza2tpNmza1trYWFxcXFxebrsjv5s2bV1paunTp0kOHDh06
dGjp0qVr1qyZN2+e6br8YtasWQkJCd999533TeG9y/kIHsa7nI/UbmG5y/kO3qtdrhO6FRQU
zJw503Nl5syZn376qal6AubNN9+8dOmS+9OampqUlBSD9QTYJ598MmvWrM7OTiEvq507d2Zl
ZZmuItBsNlt9fb3nSn19vc1mM1ROgHg/pYXsct7BJexyPnaw8N7lvEP1cpcLw6+Rcenp6du3
b/dc2b59e0ZGhql6TOno6IiMjDRdRYD89ttvd9xxR2tra2eYbj3ennjiiW3btpmuItDi4+O9
G6yEhARD5QSI91NayC532ddyWO5yPaUO+13OO1QvdzneItSvrq7Obrd7rowePXr//v2m6jFl
69ato0aNMl1FIJw5cyY3N7eoqMhms5muJXB++OGH9vb2SZMmRUVF2Wy2yZMn+35zITy8+OKL
TzzxRHV1dVtbW1tb2969ex977LGXX37ZdF2Bxi7nwi4X3nqF4elIAAAHS0lEQVS7y/Wu4UM3
IiIizp0757ly7ty58Pspx7fjx4/ffvvte/fuNV1IIDz//PP5+fnuT4W8rPr27RsXF/fFF180
Nzc3NzevXr06Li6uurradF3+denSpezsbM8tNDs72/M9o7Dk/ZQWssv5fi2H6y7XbWoJu5x3
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

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=current

2014-02-16 04:18:41  /lkp/lkp/src/sbin/perf-bisect /lkp/.bisect-descs/bisect-desc.vmstat.system.cs.2014-02-16.03:54:18
---
stat: vmstat.system.cs
interval: ! '[ 5.1883e+06 - 5.1883e+06 ] -- [ 2474       - 4961       ]'
a:
- 5188285
b:
- 2474
- 2919
- 3479
- 3594
- 3669
- 3802
- 4124
- 4194
- 4961
ttl: 2014-02-15 17:33:53.961378385 +08:00
ratio: 5
delta: 5184616
mean_a: 5188285
mean_b: 3669
x: 0
y: 5183324
z: 2487
min_a: 5188285
max_a: 5188285
min_b: 2474
max_b: 4961
max: 5188285
nr_run: 1469
good_commit: b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed
tbox_group: lkp-snb01
run_time: 311
result_root: /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/5abff587f6ba8de0adf41a19c4add6a3a4b37b64/0
_result_root: /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/5abff587f6ba8de0adf41a19c4add6a3a4b37b64
head_commit: 5abff587f6ba8de0adf41a19c4add6a3a4b37b64
base_commit: b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed
commit: 5abff587f6ba8de0adf41a19c4add6a3a4b37b64
branch: linux-devel/devel-hourly-2014021515
kconfig: x86_64-lkp
testbox: lkp-snb01
score_perf_change: 0
change_percent: 0.999292829904294
variation: 0.00047957783266686733
avg_run_time: 312
score_change: 99.96463524188411
score_var: 9.985619563763917
score_time: 90
score_metric: 4
prio: 203.9503
2014-02-16 04:18:42 [perf-bisect 98512] /lkp/lkp/src/sbin/queue -k linux-devel/devel-hourly-2014021515:b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed -q reconfirm -w 36000 -R0 /lkp/lkp/linux5/.git/job.yaml
run: /lkp/lkp/src/filters/iostat
run: /lkp/lkp/src/filters/kconfig
Enqueue job 3 times: /lkp/jobs/reconfirm/lkp-snb01/will-it-scale-sched_yield-x86_64-lkp-b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed-2.yaml
2014-02-16 04:24:23 [perf-bisect 98512] /lkp/lkp/src/sbin/queue -k linux-devel/devel-hourly-2014021515:5abff587f6ba8de0adf41a19c4add6a3a4b37b64 -q reconfirm -w 36000 -R0 /lkp/lkp/linux5/.git/job.yaml
run: /lkp/lkp/src/filters/iostat
run: /lkp/lkp/src/filters/kconfig
Enqueue job 3 times: /lkp/jobs/reconfirm/lkp-snb01/will-it-scale-sched_yield-x86_64-lkp-5abff587f6ba8de0adf41a19c4add6a3a4b37b64-2.yaml
2014-02-16 04:44:24 [perf-bisect 98512] /lkp/lkp/src/sbin/queue -k linux-devel/devel-hourly-2014021515:b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed -q reconfirm -w 36000 -R0 /lkp/lkp/linux5/.git/job.yaml
run: /lkp/lkp/src/filters/iostat
run: /lkp/lkp/src/filters/kconfig
Enqueue job 5 times: /lkp/jobs/reconfirm/lkp-snb01/will-it-scale-sched_yield-x86_64-lkp-b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed-4.yaml
2014-02-16 04:56:44 [perf-bisect 98512] /lkp/lkp/src/sbin/queue -k linux-devel/devel-hourly-2014021515:5abff587f6ba8de0adf41a19c4add6a3a4b37b64 -q reconfirm -w 36000 -R0 /lkp/lkp/linux5/.git/job.yaml
run: /lkp/lkp/src/filters/iostat
run: /lkp/lkp/src/filters/kconfig
Enqueue job 5 times: /lkp/jobs/reconfirm/lkp-snb01/will-it-scale-sched_yield-x86_64-lkp-5abff587f6ba8de0adf41a19c4add6a3a4b37b64-4.yaml
git checkout b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed
2014-02-16 05:15:06 [perf-bisect-test 73445] /lkp/lkp/src/sbin/queue -k linux-devel/devel-hourly-2014021515:b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed -q bisect -w 36000 -R0 /lkp/lkp/linux5/.git/job.yaml
run: /lkp/lkp/src/filters/iostat
run: /lkp/lkp/src/filters/kconfig
Enqueue job 2 times: /lkp/jobs/bisect/lkp-snb01/will-it-scale-sched_yield-x86_64-lkp-b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed-1.yaml
2014-02-16 05:22:06 [perf-bisect-test 73445] /lkp/lkp/src/sbin/stats-good-or-bad vmstat.system.cs /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/5abff587f6ba8de0adf41a19c4add6a3a4b37b64/matrix.json /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed/matrix.json /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed/matrix.json
bisect GOOD: [2734, 3802, 7773]  [2734, 3802, 7773] 1098637.2831603948 [4535025, 5179772, 5188285]

bisect: good commit b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed
git bisect start 5abff587f6ba8de0adf41a19c4add6a3a4b37b64 b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed --
/c/kernel-tests/linear-bisect: ["-b", "5abff587f6ba8de0adf41a19c4add6a3a4b37b64", "-g", "b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed", "/lkp/lkp/src/sbin/perf-bisect-test", "/cc/perf-bisect-obj/lkp/x86_64-lkp"]
Bisecting: 1944 revisions left to test after this (roughly 11 steps)
[7aaf3caaab7f5ddc8da4359a93a8a6be86946169] Merge 'at91/at91-3.15-cleanup' into devel-hourly-2014021515
running /lkp/lkp/src/sbin/perf-bisect-test /cc/perf-bisect-obj/lkp/x86_64-lkp
2014-02-16 05:22:07 [perf-bisect-test 10038] /lkp/lkp/src/sbin/queue -k linux-devel/devel-hourly-2014021515:7aaf3caaab7f5ddc8da4359a93a8a6be86946169 -q bisect -w 36000 -R0 /lkp/lkp/linux5/.git/job.yaml
run: /lkp/lkp/src/filters/iostat
run: /lkp/lkp/src/filters/kconfig
Enqueue job 2 times: /lkp/jobs/bisect/lkp-snb01/will-it-scale-sched_yield-x86_64-lkp-7aaf3caaab7f5ddc8da4359a93a8a6be86946169-1.yaml
2014-02-16 05:40:58 [perf-bisect-test 10038] /lkp/lkp/src/sbin/stats-good-or-bad vmstat.system.cs /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/5abff587f6ba8de0adf41a19c4add6a3a4b37b64/matrix.json /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed/matrix.json /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/7aaf3caaab7f5ddc8da4359a93a8a6be86946169/matrix.json
bisect BAD: [5152320, 5470320, 5470320]  [2734, 3802, 7773] 1098637.2831603948 [4535025, 5179772, 5188285]

Bisecting: 1076 revisions left to test after this (roughly 11 steps)
[f6afc6d8b9d433388365d1567babe4b1738400bb] Merge 'pci/pci/host-mvebu' into devel-hourly-2014021515
running /lkp/lkp/src/sbin/perf-bisect-test /cc/perf-bisect-obj/lkp/x86_64-lkp
2014-02-16 05:40:58 [perf-bisect-test 40970] /lkp/lkp/src/sbin/queue -k linux-devel/devel-hourly-2014021515:f6afc6d8b9d433388365d1567babe4b1738400bb -q bisect -w 36000 -R0 /lkp/lkp/linux5/.git/job.yaml
run: /lkp/lkp/src/filters/iostat
run: /lkp/lkp/src/filters/kconfig
/lkp/lkp/src/sbin/kbuild-queue -c x86_64-lkp -b linux-devel/devel-hourly-2014021515 -k f6afc6d8b9d433388365d1567babe4b1738400bb -w
Queued build task to /kernel-tests/build-queue/x86_64-lkp-f6afc6d8b9d433388365d1567babe4b1738400bb
Check for kernel in /kernel/x86_64-lkp/f6afc6d8b9d433388365d1567babe4b1738400bb
waiting for completion of /kernel-tests/build-queue/x86_64-lkp-f6afc6d8b9d433388365d1567babe4b1738400bb
waiting for completion of /kernel-tests/build-queue/.x86_64-lkp-f6afc6d8b9d433388365d1567babe4b1738400bb
kernel: /kernel/x86_64-lkp/f6afc6d8b9d433388365d1567babe4b1738400bb/vmlinuz-3.14.0-rc2-wl-ath-00835-gf6afc6d
Enqueue job 2 times: /lkp/jobs/bisect/lkp-snb01/will-it-scale-sched_yield-x86_64-lkp-f6afc6d8b9d433388365d1567babe4b1738400bb-1.yaml
2014-02-16 06:00:19 [perf-bisect-test 40970] /lkp/lkp/src/sbin/stats-good-or-bad vmstat.system.cs /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/5abff587f6ba8de0adf41a19c4add6a3a4b37b64/matrix.json /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed/matrix.json /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/f6afc6d8b9d433388365d1567babe4b1738400bb/matrix.json
bisect GOOD: [2868, 3166, 3166]  [2734, 3802, 7773] 1098637.2831603948 [4535025, 5179772, 5188285]

Bisecting: 241 revisions left to test after this (roughly 8 steps)
[d67497e37737967e5edb30ff331e7479e19a13f3] Merge 'char-misc/char-misc-linus' into devel-hourly-2014021515
running /lkp/lkp/src/sbin/perf-bisect-test /cc/perf-bisect-obj/lkp/x86_64-lkp
2014-02-16 06:00:19 [perf-bisect-test 797] /lkp/lkp/src/sbin/queue -k linux-devel/devel-hourly-2014021515:d67497e37737967e5edb30ff331e7479e19a13f3 -q bisect -w 36000 -R0 /lkp/lkp/linux5/.git/job.yaml
run: /lkp/lkp/src/filters/iostat
run: /lkp/lkp/src/filters/kconfig
/lkp/lkp/src/sbin/kbuild-queue -c x86_64-lkp -b linux-devel/devel-hourly-2014021515 -k d67497e37737967e5edb30ff331e7479e19a13f3 -w
Queued build task to /kernel-tests/build-queue/x86_64-lkp-d67497e37737967e5edb30ff331e7479e19a13f3
Check for kernel in /kernel/x86_64-lkp/d67497e37737967e5edb30ff331e7479e19a13f3
waiting for completion of /kernel-tests/build-queue/x86_64-lkp-d67497e37737967e5edb30ff331e7479e19a13f3
waiting for completion of /kernel-tests/build-queue/.x86_64-lkp-d67497e37737967e5edb30ff331e7479e19a13f3
kernel: /kernel/x86_64-lkp/d67497e37737967e5edb30ff331e7479e19a13f3/vmlinuz-3.14.0-rc2-wl-ath-00912-gd67497e
Enqueue job 2 times: /lkp/jobs/bisect/lkp-snb01/will-it-scale-sched_yield-x86_64-lkp-d67497e37737967e5edb30ff331e7479e19a13f3-1.yaml
2014-02-16 06:18:30 [perf-bisect-test 797] /lkp/lkp/src/sbin/stats-good-or-bad vmstat.system.cs /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/5abff587f6ba8de0adf41a19c4add6a3a4b37b64/matrix.json /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed/matrix.json /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/d67497e37737967e5edb30ff331e7479e19a13f3/matrix.json
bisect BAD: [5209415, 5211906, 5211906]  [2734, 3802, 7773] 1098637.2831603948 [4535025, 5179772, 5188285]

Bisecting: 77 revisions left to test after this (roughly 7 steps)
[933530ed7e473b3c0efa0a0b39c09c65c04beb37] Merge 'arm-perf/for-next/perf' into devel-hourly-2014021515
running /lkp/lkp/src/sbin/perf-bisect-test /cc/perf-bisect-obj/lkp/x86_64-lkp
2014-02-16 06:18:31 [perf-bisect-test 41141] /lkp/lkp/src/sbin/queue -k linux-devel/devel-hourly-2014021515:933530ed7e473b3c0efa0a0b39c09c65c04beb37 -q bisect -w 36000 -R0 /lkp/lkp/linux5/.git/job.yaml
run: /lkp/lkp/src/filters/iostat
run: /lkp/lkp/src/filters/kconfig
/lkp/lkp/src/sbin/kbuild-queue -c x86_64-lkp -b linux-devel/devel-hourly-2014021515 -k 933530ed7e473b3c0efa0a0b39c09c65c04beb37 -w
Queued build task to /kernel-tests/build-queue/x86_64-lkp-933530ed7e473b3c0efa0a0b39c09c65c04beb37
Check for kernel in /kernel/x86_64-lkp/933530ed7e473b3c0efa0a0b39c09c65c04beb37
waiting for completion of /kernel-tests/build-queue/x86_64-lkp-933530ed7e473b3c0efa0a0b39c09c65c04beb37
waiting for completion of /kernel-tests/build-queue/.x86_64-lkp-933530ed7e473b3c0efa0a0b39c09c65c04beb37
kernel: /kernel/x86_64-lkp/933530ed7e473b3c0efa0a0b39c09c65c04beb37/vmlinuz-3.14.0-rc2-wl-ath-00868-g933530e
Enqueue job 2 times: /lkp/jobs/bisect/lkp-snb01/will-it-scale-sched_yield-x86_64-lkp-933530ed7e473b3c0efa0a0b39c09c65c04beb37-1.yaml
2014-02-16 06:36:23 [perf-bisect-test 41141] /lkp/lkp/src/sbin/stats-good-or-bad vmstat.system.cs /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/5abff587f6ba8de0adf41a19c4add6a3a4b37b64/matrix.json /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed/matrix.json /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/933530ed7e473b3c0efa0a0b39c09c65c04beb37/matrix.json
bisect GOOD: [2499, 2714, 2714]  [2734, 3802, 7773] 1098637.2831603948 [4535025, 5179772, 5188285]

Bisecting: 44 revisions left to test after this (roughly 6 steps)
[9fd1bb34f21472d352fbf49bbdf1f07a320393ca] Merge 'kvm/master' into devel-hourly-2014021515
running /lkp/lkp/src/sbin/perf-bisect-test /cc/perf-bisect-obj/lkp/x86_64-lkp
2014-02-16 06:36:23 [perf-bisect-test 69581] /lkp/lkp/src/sbin/queue -k linux-devel/devel-hourly-2014021515:9fd1bb34f21472d352fbf49bbdf1f07a320393ca -q bisect -w 36000 -R0 /lkp/lkp/linux5/.git/job.yaml
run: /lkp/lkp/src/filters/iostat
run: /lkp/lkp/src/filters/kconfig
/lkp/lkp/src/sbin/kbuild-queue -c x86_64-lkp -b linux-devel/devel-hourly-2014021515 -k 9fd1bb34f21472d352fbf49bbdf1f07a320393ca -w
Queued build task to /kernel-tests/build-queue/x86_64-lkp-9fd1bb34f21472d352fbf49bbdf1f07a320393ca
Check for kernel in /kernel/x86_64-lkp/9fd1bb34f21472d352fbf49bbdf1f07a320393ca
waiting for completion of /kernel-tests/build-queue/x86_64-lkp-9fd1bb34f21472d352fbf49bbdf1f07a320393ca
waiting for completion of /kernel-tests/build-queue/.x86_64-lkp-9fd1bb34f21472d352fbf49bbdf1f07a320393ca
kernel: /kernel/x86_64-lkp/9fd1bb34f21472d352fbf49bbdf1f07a320393ca/vmlinuz-3.14.0-rc2-wl-ath-00876-g9fd1bb3
Enqueue job 2 times: /lkp/jobs/bisect/lkp-snb01/will-it-scale-sched_yield-x86_64-lkp-9fd1bb34f21472d352fbf49bbdf1f07a320393ca-1.yaml
2014-02-16 06:55:04 [perf-bisect-test 69581] /lkp/lkp/src/sbin/stats-good-or-bad vmstat.system.cs /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/5abff587f6ba8de0adf41a19c4add6a3a4b37b64/matrix.json /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed/matrix.json /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/9fd1bb34f21472d352fbf49bbdf1f07a320393ca/matrix.json
bisect GOOD: [3523, 7441, 7441]  [2734, 3802, 7773] 1098637.2831603948 [4535025, 5179772, 5188285]

Bisecting: 36 revisions left to test after this (roughly 6 steps)
[1a9a97cd15230efd44ff9957326dd245f89bdbd6] Merge 'alexshi/topdown' into devel-hourly-2014021515
running /lkp/lkp/src/sbin/perf-bisect-test /cc/perf-bisect-obj/lkp/x86_64-lkp
2014-02-16 06:55:05 [perf-bisect-test 101819] /lkp/lkp/src/sbin/queue -k linux-devel/devel-hourly-2014021515:1a9a97cd15230efd44ff9957326dd245f89bdbd6 -q bisect -w 36000 -R0 /lkp/lkp/linux5/.git/job.yaml
run: /lkp/lkp/src/filters/iostat
run: /lkp/lkp/src/filters/kconfig
/lkp/lkp/src/sbin/kbuild-queue -c x86_64-lkp -b linux-devel/devel-hourly-2014021515 -k 1a9a97cd15230efd44ff9957326dd245f89bdbd6 -w
Queued build task to /kernel-tests/build-queue/x86_64-lkp-1a9a97cd15230efd44ff9957326dd245f89bdbd6
Check for kernel in /kernel/x86_64-lkp/1a9a97cd15230efd44ff9957326dd245f89bdbd6
waiting for completion of /kernel-tests/build-queue/x86_64-lkp-1a9a97cd15230efd44ff9957326dd245f89bdbd6
waiting for completion of /kernel-tests/build-queue/.x86_64-lkp-1a9a97cd15230efd44ff9957326dd245f89bdbd6
kernel: /kernel/x86_64-lkp/1a9a97cd15230efd44ff9957326dd245f89bdbd6/vmlinuz-3.14.0-rc2-wl-ath-00895-g1a9a97c
Enqueue job 2 times: /lkp/jobs/bisect/lkp-snb01/will-it-scale-sched_yield-x86_64-lkp-1a9a97cd15230efd44ff9957326dd245f89bdbd6-1.yaml
2014-02-16 07:21:36 [perf-bisect-test 101819] /lkp/lkp/src/sbin/stats-good-or-bad vmstat.system.cs /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/5abff587f6ba8de0adf41a19c4add6a3a4b37b64/matrix.json /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed/matrix.json /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/1a9a97cd15230efd44ff9957326dd245f89bdbd6/matrix.json
bisect BAD: [5211562, 5215236, 5215236]  [2734, 3802, 7773] 1098637.2831603948 [4535025, 5179772, 5188285]

linear-bisect: bad branch may be alexshi/topdown
[v3.14-rc2] Linux 3.14-rc2
running /lkp/lkp/src/sbin/perf-bisect-test /cc/perf-bisect-obj/lkp/x86_64-lkp
2014-02-16 07:21:39 [perf-bisect-test 43744] /lkp/lkp/src/sbin/queue -k linux-devel/devel-hourly-2014021515:b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed -q bisect -w 36000 -R0 /lkp/lkp/linux5/.git/job.yaml
run: /lkp/lkp/src/filters/iostat
run: /lkp/lkp/src/filters/kconfig
Enqueue job 2 times: /lkp/jobs/bisect/lkp-snb01/will-it-scale-sched_yield-x86_64-lkp-b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed-1.yaml
2014-02-16 07:25:30 [perf-bisect-test 43744] /lkp/lkp/src/sbin/stats-good-or-bad vmstat.system.cs /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/5abff587f6ba8de0adf41a19c4add6a3a4b37b64/matrix.json /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed/matrix.json /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed/matrix.json
bisect GOOD: [2734, 3802, 7773]  [2734, 3802, 7773] 1098637.2831603948 [4535025, 5179772, 5188285]

[d2f8e017fdd913fc150160508d2e1161cab5fef6] sched: remove un-used functions
running /lkp/lkp/src/sbin/perf-bisect-test /cc/perf-bisect-obj/lkp/x86_64-lkp
2014-02-16 07:25:30 [perf-bisect-test 115104] /lkp/lkp/src/sbin/queue -k linux-devel/devel-hourly-2014021515:d2f8e017fdd913fc150160508d2e1161cab5fef6 -q bisect -w 36000 -R0 /lkp/lkp/linux5/.git/job.yaml
run: /lkp/lkp/src/filters/iostat
run: /lkp/lkp/src/filters/kconfig
Enqueue job 2 times: /lkp/jobs/bisect/lkp-snb01/will-it-scale-sched_yield-x86_64-lkp-d2f8e017fdd913fc150160508d2e1161cab5fef6-1.yaml
2014-02-16 07:45:41 [perf-bisect-test 115104] /lkp/lkp/src/sbin/stats-good-or-bad vmstat.system.cs /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/5abff587f6ba8de0adf41a19c4add6a3a4b37b64/matrix.json /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed/matrix.json /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/d2f8e017fdd913fc150160508d2e1161cab5fef6/matrix.json
bisect BAD: [4736446, 5001400, 5001400]  [2734, 3802, 7773] 1098637.2831603948 [4535025, 5179772, 5188285]

linear-bisect: recursive descent into merged branch
/c/kernel-tests/linear-bisect: ["-g", "v3.14-rc2", "-b", "d2f8e017fdd913fc150160508d2e1161cab5fef6", "/lkp/lkp/src/sbin/perf-bisect-test", "/cc/perf-bisect-obj/lkp/x86_64-lkp"]
Bisecting: 18 revisions left to test after this (roughly 5 steps)
[f6ab232915356bd6649052c1672c10424feab995] sched: remove rq->cpu_load and rq->nr_load_updates
running /lkp/lkp/src/sbin/perf-bisect-test /cc/perf-bisect-obj/lkp/x86_64-lkp
2014-02-16 07:45:42 [perf-bisect-test 74444] /lkp/lkp/src/sbin/queue -k linux-devel/devel-hourly-2014021515:f6ab232915356bd6649052c1672c10424feab995 -q bisect -w 36000 -R0 /lkp/lkp/linux5/.git/job.yaml
run: /lkp/lkp/src/filters/iostat
run: /lkp/lkp/src/filters/kconfig
Enqueue job 2 times: /lkp/jobs/bisect/lkp-snb01/will-it-scale-sched_yield-x86_64-lkp-f6ab232915356bd6649052c1672c10424feab995-1.yaml
2014-02-16 08:04:02 [perf-bisect-test 74444] /lkp/lkp/src/sbin/stats-good-or-bad vmstat.system.cs /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/5abff587f6ba8de0adf41a19c4add6a3a4b37b64/matrix.json /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed/matrix.json /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/f6ab232915356bd6649052c1672c10424feab995/matrix.json
bisect GOOD: [2329, 4551, 4551]  [2734, 3802, 7773] 1098637.2831603948 [4535025, 5179772, 5188285]

Bisecting: 9 revisions left to test after this (roughly 4 steps)
[7511dd0a73aaf2ca4bcd829f991dcd2c839c5417] sched: only do load balance on tick_do_timer_cpu
running /lkp/lkp/src/sbin/perf-bisect-test /cc/perf-bisect-obj/lkp/x86_64-lkp
2014-02-16 08:04:03 [perf-bisect-test 53445] /lkp/lkp/src/sbin/queue -k linux-devel/devel-hourly-2014021515:7511dd0a73aaf2ca4bcd829f991dcd2c839c5417 -q bisect -w 36000 -R0 /lkp/lkp/linux5/.git/job.yaml
run: /lkp/lkp/src/filters/iostat
run: /lkp/lkp/src/filters/kconfig
Enqueue job 2 times: /lkp/jobs/bisect/lkp-snb01/will-it-scale-sched_yield-x86_64-lkp-7511dd0a73aaf2ca4bcd829f991dcd2c839c5417-1.yaml
2014-02-16 08:21:33 [perf-bisect-test 53445] /lkp/lkp/src/sbin/stats-good-or-bad vmstat.system.cs /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/5abff587f6ba8de0adf41a19c4add6a3a4b37b64/matrix.json /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed/matrix.json /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/7511dd0a73aaf2ca4bcd829f991dcd2c839c5417/matrix.json
bisect BAD: [5373928, 5996496, 5996496]  [2734, 3802, 7773] 1098637.2831603948 [4535025, 5179772, 5188285]

Bisecting: 4 revisions left to test after this (roughly 3 steps)
[6de9950778921604a8bd0fbab09911df5d98bbeb] sched: add statistic for newidle load balance cost
running /lkp/lkp/src/sbin/perf-bisect-test /cc/perf-bisect-obj/lkp/x86_64-lkp
2014-02-16 08:21:34 [perf-bisect-test 112510] /lkp/lkp/src/sbin/queue -k linux-devel/devel-hourly-2014021515:6de9950778921604a8bd0fbab09911df5d98bbeb -q bisect -w 36000 -R0 /lkp/lkp/linux5/.git/job.yaml
run: /lkp/lkp/src/filters/iostat
run: /lkp/lkp/src/filters/kconfig
/lkp/lkp/src/sbin/kbuild-queue -c x86_64-lkp -b linux-devel/devel-hourly-2014021515 -k 6de9950778921604a8bd0fbab09911df5d98bbeb -w
Queued build task to /kernel-tests/build-queue/x86_64-lkp-6de9950778921604a8bd0fbab09911df5d98bbeb
Check for kernel in /kernel/x86_64-lkp/6de9950778921604a8bd0fbab09911df5d98bbeb
waiting for completion of /kernel-tests/build-queue/x86_64-lkp-6de9950778921604a8bd0fbab09911df5d98bbeb
waiting for completion of /kernel-tests/build-queue/.x86_64-lkp-6de9950778921604a8bd0fbab09911df5d98bbeb
kernel: /kernel/x86_64-lkp/6de9950778921604a8bd0fbab09911df5d98bbeb/vmlinuz-3.14.0-rc2-00011-g6de9950
Enqueue job 2 times: /lkp/jobs/bisect/lkp-snb01/will-it-scale-sched_yield-x86_64-lkp-6de9950778921604a8bd0fbab09911df5d98bbeb-1.yaml
2014-02-16 08:46:04 [perf-bisect-test 112510] /lkp/lkp/src/sbin/stats-good-or-bad vmstat.system.cs /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/5abff587f6ba8de0adf41a19c4add6a3a4b37b64/matrix.json /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed/matrix.json /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/6de9950778921604a8bd0fbab09911df5d98bbeb/matrix.json
bisect GOOD: [2622, 2906, 2906]  [2734, 3802, 7773] 1098637.2831603948 [4535025, 5179772, 5188285]

Bisecting: 2 revisions left to test after this (roughly 2 steps)
[bc575710efe937e26d2bd541d92362b240ef0559] sched: clean up task_hot function
running /lkp/lkp/src/sbin/perf-bisect-test /cc/perf-bisect-obj/lkp/x86_64-lkp
2014-02-16 08:46:05 [perf-bisect-test 5884] /lkp/lkp/src/sbin/queue -k linux-devel/devel-hourly-2014021515:bc575710efe937e26d2bd541d92362b240ef0559 -q bisect -w 36000 -R0 /lkp/lkp/linux5/.git/job.yaml
run: /lkp/lkp/src/filters/iostat
run: /lkp/lkp/src/filters/kconfig
/lkp/lkp/src/sbin/kbuild-queue -c x86_64-lkp -b linux-devel/devel-hourly-2014021515 -k bc575710efe937e26d2bd541d92362b240ef0559 -w
Queued build task to /kernel-tests/build-queue/x86_64-lkp-bc575710efe937e26d2bd541d92362b240ef0559
Check for kernel in /kernel/x86_64-lkp/bc575710efe937e26d2bd541d92362b240ef0559
waiting for completion of /kernel-tests/build-queue/x86_64-lkp-bc575710efe937e26d2bd541d92362b240ef0559
waiting for completion of /kernel-tests/build-queue/.x86_64-lkp-bc575710efe937e26d2bd541d92362b240ef0559
kernel: /kernel/x86_64-lkp/bc575710efe937e26d2bd541d92362b240ef0559/vmlinuz-3.14.0-rc2-00012-gbc57571
Enqueue job 2 times: /lkp/jobs/bisect/lkp-snb01/will-it-scale-sched_yield-x86_64-lkp-bc575710efe937e26d2bd541d92362b240ef0559-1.yaml
2014-02-16 09:17:05 [perf-bisect-test 5884] /lkp/lkp/src/sbin/stats-good-or-bad vmstat.system.cs /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/5abff587f6ba8de0adf41a19c4add6a3a4b37b64/matrix.json /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed/matrix.json /lkp/result/lkp-snb01/micro/will-it-scale/sched_yield/x86_64-lkp/bc575710efe937e26d2bd541d92362b240ef0559/matrix.json
bisect GOOD: [1794, 2328, 2328]  [2734, 3802, 7773] 1098637.2831603948 [4535025, 5179772, 5188285]

7511dd0a73aaf2ca4bcd829f991dcd2c839c5417 is the first bad commit
commit 7511dd0a73aaf2ca4bcd829f991dcd2c839c5417
Author:     Alex Shi <alex.shi@linaro.org>
AuthorDate: Fri Jan 24 15:17:02 2014 +0800
Commit:     Alex Shi <alex.shi@linaro.org>
CommitDate: Fri Feb 14 15:09:01 2014 +0800

    sched: only do load balance on tick_do_timer_cpu
    
    that is a central balance.
    
    Signed-off-by: Alex Shi <alex.shi@linaro.org>

 kernel/sched/core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)
exit
/c/kernel-tests/linear-bisect:274:in `exit'
/c/kernel-tests/linear-bisect:274:in `linear_bisect'
/c/kernel-tests/linear-bisect:294:in `<main>'
exit
/c/kernel-tests/linear-bisect:181:in `exit'
/c/kernel-tests/linear-bisect:181:in `recursive_bisect_into'
/c/kernel-tests/linear-bisect:210:in `perf_test_merged_branch'
/c/kernel-tests/linear-bisect:286:in `block in linear_bisect'
/c/kernel-tests/linear-bisect:286:in `each'
/c/kernel-tests/linear-bisect:286:in `linear_bisect'
/c/kernel-tests/linear-bisect:294:in `<main>'
2014-02-16 09:17:06 [perf-bisect 98512] validating first bad commit 7511dd0a73aaf2ca4bcd829f991dcd2c839c5417 ...
2014-02-16 09:17:06 [perf-bisect 98512] /lkp/lkp/src/sbin/queue -k linux-devel/devel-hourly-2014021515:7511dd0a73aaf2ca4bcd829f991dcd2c839c5417 -q validate -w 36000 -R0 /lkp/lkp/linux5/.git/job.yaml
run: /lkp/lkp/src/filters/iostat
run: /lkp/lkp/src/filters/kconfig
Enqueue job 5 times: /lkp/jobs/validate/lkp-snb01/will-it-scale-sched_yield-x86_64-lkp-7511dd0a73aaf2ca4bcd829f991dcd2c839c5417-4.yaml
bisect BAD: [4110714, 5373928, 5996496]  [2734, 3802, 7773] 1098637.2831603948 [4535025, 5179772, 5188285]

2014-02-16 09:41:56 [perf-bisect 98512] validating parent commit bc575710efe937e26d2bd541d92362b240ef0559 ...
2014-02-16 09:41:56 [perf-bisect 98512] /lkp/lkp/src/sbin/queue -k linux-devel/devel-hourly-2014021515:bc575710efe937e26d2bd541d92362b240ef0559 -q validate -w 36000 -R0 /lkp/lkp/linux5/.git/job.yaml
run: /lkp/lkp/src/filters/iostat
run: /lkp/lkp/src/filters/kconfig
Enqueue job 5 times: /lkp/jobs/validate/lkp-snb01/will-it-scale-sched_yield-x86_64-lkp-bc575710efe937e26d2bd541d92362b240ef0559-4.yaml
bisect GOOD: [1794, 2316, 3578]  [2734, 3802, 7773] 1098637.2831603948 [4535025, 5179772, 5188285]

2014-02-16 10:06:47 [perf-bisect 98512] first bad commit validated successfully
==================== PARENT FIRST_BAD KCONFIGS ====================
stats changes plotted at /lkp/bisect-plot/vmstat.system.cs/2014-02-16_10:06:49.png

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--VbJkn9YxBvnuCH5J--
