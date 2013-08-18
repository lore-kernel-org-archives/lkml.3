Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab3HRDR2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 23:17:28 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:39499 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab3HRDR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 23:17:27 -0400
X-Originating-IP: 50.43.39.152
Date: Sat, 17 Aug 2013 20:17:17 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, Borislav Petkov <bp@alien8.de>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH tip/core/rcu 01/11] rcu: Expedite grace periods during
 suspend/resume
Message-ID: <20130818031717.GL28923@leaf>
References: <20130818013735.GA27234@linux.vnet.ibm.com>
 <1376789876-27594-1-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376789876-27594-1-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 17, 2013 at 06:37:46PM -0700, Paul E. McKenney wrote:
> From: Borislav Petkov <bp@alien8.de>
> 
> CONFIG_RCU_FAST_NO_HZ can increase grace-period durations by up to
> a factor of four, which can result in long suspend and resume times.
> Thus, this commit temporarily switches to expedited grace periods when
> suspending the box and return to normal settings when resuming.
> 
> [ paulmck: This also papers over an audio/irq bug, but hopefully that will
>   be fixed soon. ]
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

This patch still seems like a hack, and there *ought* to be a better
general solution to avoid excessive grace-period latency.  Nonetheless,
in the absence of such a solution,
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
