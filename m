Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaAWQ5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 11:57:32 -0500
Received: from merlin.infradead.org ([205.233.59.134]:39570 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbaAWQ5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 11:57:31 -0500
Date: Thu, 23 Jan 2014 17:56:55 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Young <dyoung@redhat.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sasha Levin <sasha.levin@oracle.com>,
        Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] sched: Use a static_key for sched_clock_stable
Message-ID: <20140123165655.GY31570@twins.programming.kicks-ass.net>
References: <20140122131456.GA389@x4>
 <52DFD50E.800@oracle.com>
 <20140122183538.GA389@x4>
 <20140122184253.GN30183@twins.programming.kicks-ass.net>
 <20140122190905.GA391@x4>
 <20140122191254.GA390@x4>
 <20140122201605.GU11314@laptop.programming.kicks-ass.net>
 <20140122210814.GC9481@laptop.programming.kicks-ass.net>
 <20140123015354.GB3768@dhcp-16-126.nay.redhat.com>
 <20140123021028.GE3768@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123021028.GE3768@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 10:10:28AM +0800, Dave Young wrote:
> Hmm, seems the my physical machine is booting fine with this patch. kvm
> guest problem still exist, but that kvm thing might be other problem.

Dave, could you try with tip/master, Ingo pushed out all the fixes
gathered.

Lacking that, could you perhaps provide the .config you use for your
guest and a kvm invocation?

I used a defconfig with KVM_GUEST=y, which was enough to enable kvmclock
support and then started with:

kvm -kernel defconfig-build/arch/x86/boot/bzImage -nographic -append "console=ttyS0" -smp 2
