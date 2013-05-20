Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab3ETHgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 03:36:18 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33343 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283Ab3ETHgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 03:36:17 -0400
Date: Mon, 20 May 2013 16:36:12 +0900
From: Tejun Heo <tj@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Michael Wang <wangyun@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123
 native_smp_send_reschedule, round 2
Message-ID: <20130520073612.GB24222@mtj.dyndns.org>
References: <20130509125040.GF27333@pd.tnic>
 <20130509125859.GG27333@pd.tnic>
 <20130515184528.GO4442@linux.vnet.ibm.com>
 <20130515224358.GF11783@pd.tnic>
 <20130515235512.GT4442@linux.vnet.ibm.com>
 <20130517135641.GF23035@pd.tnic>
 <51999591.8030401@linux.vnet.ibm.com>
 <20130520045023.GA12690@pd.tnic>
 <5199C169.7060504@linux.vnet.ibm.com>
 <20130520064727.GD12690@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130520064727.GD12690@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, May 20, 2013 at 08:47:27AM +0200, Borislav Petkov wrote:
> > So there are two questions here:
> > 1. Is gov_queue_work() want to queue the work on offline cpu?
> > 2. Is mod_delayed_work_on() allow offline cpu?
> > 
> > I guess both should be false?
> 
> Well, if we don't allow queueing work on a cpu which goes offline, i.e.
> #2, the problem should be solved.
> 
> Tejun?

Workqueue proper would behave okish (no affinity of course but the
work items are still executed) but mod_delayed_work_on() adds a timer
on the target CPU and I think adding a timer on an offline cpu would
be a problem.

Thanks.

-- 
tejun
