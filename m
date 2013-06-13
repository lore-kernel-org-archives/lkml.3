Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab3FMNLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:11:06 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:60981 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab3FMNLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:11:04 -0400
Date: Thu, 13 Jun 2013 15:10:59 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Anish Singh <anish198519851985@gmail.com>
Subject: Re: [PATCH 4/6] watchdog: Boot-disable by default on full dynticks
Message-ID: <20130613131057.GA15997@somewhere>
References: <1371045758-5296-1-git-send-email-fweisbec@gmail.com>
 <1371045758-5296-5-git-send-email-fweisbec@gmail.com>
 <20130612170316.GO133453@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130612170316.GO133453@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 01:03:16PM -0400, Don Zickus wrote:
> On Wed, Jun 12, 2013 at 04:02:36PM +0200, Frederic Weisbecker wrote:
> > When the watchdog runs, it prevents the full dynticks
> > CPUs from stopping their tick because the hard lockup
> > detector uses perf events internally, which in turn
> > rely on the periodic tick.
> > 
> > Since this is a rather confusing behaviour that is not
> > easy to track down and identify for those who want to
> > test CONFIG_NO_HZ_FULL, let's default disable the
> > watchdog on boot time when full dynticks is enabled.
> > 
> > The user can still enable it later on runtime using
> > proc or sysctl.
> 
> I thought we had a conversation awhile ago, where we agreed this was going
> to be fixed for 3.11?  Didn't Peter find the patch and apply it to his
> tree?  I am confused why this is still needed?

We agreed on the patch but it hasn't been applied yet. I'm trying to get
a sane series of nohz patches before sending to Ingo.

Thanks.
