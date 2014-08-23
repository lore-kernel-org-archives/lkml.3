Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaHWXmz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 19:42:55 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:50630 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaHWXmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 19:42:54 -0400
Date: Sat, 23 Aug 2014 09:35:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Pranith Kumar <bobby.prani@gmail.com>, Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [rcu] 0eb885afb20: -25.8% softirqs.RCU
Message-ID: <20140823163504.GA5333@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140821135035.GA19246@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140821135035.GA19246@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082323-1344-0000-0000-000003AD9C58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 09:50:35PM +0800, Fengguang Wu wrote:
> Hi Pranith,
> 
> FYI, these changes look nice:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/dev
> commit 0eb885afb20317016670c1c5dd3a436c91e1e910 ("rcu: Use rcu_gp_kthread_wake() to wake up grace period kthreads")
> 
> test case: lkp-a04/aim7/400-disk_rr

Good show, Pranith!!!

							Thanx, Paul

> It's an in-memory aim7/disk_rr test.
> lkp-a04 is an Atom micro server with 8G Memory.
> 
> 5db6a289a3a0a69  0eb885afb20317016670c1c5d 
> ---------------  ------------------------- 
>     150860 ± 1%     -25.8%     111937 ± 1%  TOTAL softirqs.RCU
>       2809 ± 1%     -12.5%       2457 ± 1%  TOTAL vmstat.system.cs
>       4202 ± 1%      -6.9%       3911 ± 1%  TOTAL vmstat.system.in
>     212421 ± 2%      -7.7%     196035 ± 3%  TOTAL time.involuntary_context_switches
> 
>                                  vmstat.system.in
> 
>   4300 ++-------------------------------------------------------------------+
>        | .*..                  *..        .*..                     *        |
>   4250 *+            .*..     +        .*.    *              *.. .. :       |
>   4200 ++    *..*..*.    *.. +    *..*.        :           ..   *    :      |
>        |                    *                   :        .*          :  .*  |
>   4150 ++                                       :  .*..*.             *.    |
>   4100 ++                                        *.                         |
>        |                                                                    |
>   4050 ++                                                                   |
>   4000 ++                                                                   |
>        |  O  O              O              O                             O  |
>   3950 O+       O  O     O     O     O  O        O     O  O     O           |
>   3900 ++             O                       O     O              O        |
>        |                                                     O              |
>   3850 ++-------------------------O-----------------------------------O-----O
> 
> 
>                                  vmstat.system.cs
> 
>   3000 ++-------------------------------------------------------------------+
>        |                                                                    |
>   2900 ++                      *..                                          |
>        *..*..*..*..*..*..*.. ..   *..*..*..*..*..           .*..  .*..      |
>   2800 ++                   *                            .*.    *.      .*  |
>        |                                         *..*..*.             *.    |
>   2700 ++                                                                   |
>        |                                                                    |
>   2600 ++                                                                   |
>        |              O                 O                                   |
>   2500 O+ O  O     O        O  O     O     O              O     O  O     O  |
>        |        O        O        O              O     O                    |
>   2400 ++                                     O     O                 O     O
>        |                                                     O              |
>   2300 ++-------------------------------------------------------------------+
> 
> 
> 	[*] bisect-good sample
> 	[O] bisect-bad  sample
> 
> 
> Disclaimer:
> Results have been estimated based on internal Intel analysis and are provided
> for informational purposes only. Any difference in system hardware or software
> design or configuration may affect actual performance.
> 
> Thanks,
> Fengguang
> 

