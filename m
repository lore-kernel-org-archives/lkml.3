Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab3HRDSo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 23:18:44 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:47569 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab3HRDSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 23:18:44 -0400
X-Originating-IP: 50.43.39.152
Date: Sat, 17 Aug 2013 20:18:32 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 02/11] rcu: Expedite during suspend and
 resume only on smallish systems
Message-ID: <20130818031831.GM28923@leaf>
References: <20130818013735.GA27234@linux.vnet.ibm.com>
 <1376789876-27594-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1376789876-27594-2-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376789876-27594-2-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 17, 2013 at 06:37:47PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> Expedited grace periods are of dubious benefit on very large systems,
> so this commit restricts their automated use during suspend and resume
> to systems of 256 or fewer CPUs.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

This seems odd.  If expedited grace periods don't help on large systems,
shouldn't you just compile them out entirely and ignore rcu_expedited,
rather than just in this one special case?

In any case, if this patch still makes sense, please squash it into the
previous one.

- Josh Triplett
