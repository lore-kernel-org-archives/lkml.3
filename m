Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab3KDRMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:12:08 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:39786 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab3KDRMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:12:05 -0500
Date: Mon, 4 Nov 2013 09:02:32 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Petr Mladek <pmladek@suse.cz>
Cc: Tibor Billes <tbilles@gmx.com>, Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: rcu: Throttle rcu_try_advance_all_cbs() execution causes visible
 slowdown in ftrace switching
Message-ID: <20131104170232.GS3947@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1383326384.6788.49.camel@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383326384.6788.49.camel@pathway.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110417-9332-0000-0000-000002091202
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 06:19:44PM +0100, Petr Mladek wrote:
> Hi,
> 
> I am doing some clean up in x86 ftrace code. I check the performance by
> switching between different tracers and by enabling and disabling them.
> 
> The operation has started to be much slower after rebasing on the
> kernel tip tree. Bisecting has shown that the difference was caused by
> the commit c229828ca6bc62d6c654 (rcu: Throttle
> rcu_try_advance_all_cbs() execution)
> 
> The following times are from Intel 2xCore i7-3770 CPU @ 3.40GHz when
> calling the attached test script (time ./test-ftrace). It 100x switches
> between "function" and "nop" tracer. It also enables and disables the
> tracer each time.
> 
> Results with the commit c229828ca6bc62d6c654:
> 
> real    0m49.393s     0m49.632s     0m49.359s
> user    0m0.004s      0m0.000s      0m0.004s
> sys     0m0.996s      0m0.880s      0m0.892s
> 
> 
> Results after reverting the commit c229828ca6bc62d6c654:
> 
> real    0m35.320s     0m35.687s     0m35.920s
> user    0m0.004s      0m0.004s      0m0.000s
> sys     0m1.140s      0m1.208s      0m1.152s
> 
> 
> I might do some more debugging on Monday. I wonder if you have any
> hints or ideas.

Hello, Petr,

This is a slowpath, and that commit did fix a real bug, so I am OK with
this modest slowdown.

That said, if you have a workload where this is a problem, please try
building with CONFIG_RCU_FAST_NO_HZ=n.  The fact that this commit had any
effect at all leads me to believe that you used CONFIG_RCU_FAST_NO_HZ=y.

							Thanx, Paul

