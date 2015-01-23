Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371AbbAWTQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 14:16:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41761 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbbAWTQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 14:16:52 -0500
Date: Fri, 23 Jan 2015 20:16:49 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: David Vrabel <david.vrabel@citrix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org,
        Borislav Petkov <bp@suse.de>, kvm@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>,
        Jan Beulich <JBeulich@suse.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, paulmck@linux.vnet.ibm.com
Subject: Re: [Xen-devel] [RFC v4 2/2] x86/xen: allow privcmd hypercalls to
	be preempted
Message-ID: <20150123191649.GZ17887@wotan.suse.de>
References: <1421972951-3940-1-git-send-email-mcgrof@do-not-panic.com> <1421972951-3940-3-git-send-email-mcgrof@do-not-panic.com> <54C23442.9000008@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C23442.9000008@citrix.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 11:45:06AM +0000, David Vrabel wrote:
> > + */
> > +void xen_end_upcall(struct pt_regs *regs)
> > +{
> > +	if (xen_is_preemptible_hypercall(regs)) {
> > +		int cpuid = smp_processor_id();
> > +		if (_cond_resched())
> > +			trace_xen_hypercall_preemption(cpuid);
> 
> I don't think a tracepoint here is useful.

OK.. I'll remove.

> > +	}
> > +}
> > +NOKPROBE_SYMBOL(xen_end_upcall);
> 
> Do we need this is this function is no longer notrace?

Stephen and Andy were going down some corner case rabbit hole
and it seemed to me that the conclusion was not settled so
to be safe I kept it. I'll let them decide. I did remove
the notrace junk.

  Luis
