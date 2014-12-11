Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934288AbaLKVGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:06:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41618 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933169AbaLKVGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:06:50 -0500
Date: Thu, 11 Dec 2014 22:06:49 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Juergen Gross <JGross@suse.com>, luto@amacapital.net,
        david.vrabel@citrix.com, rostedt@goodmis.org,
        masami.hiramatsu.pt@hitachi.com, peterz@infradead.org, x86@kernel.org,
        tglx@linutronix.de, xen-devel@lists.xenproject.org,
        konrad.wilk@oracle.com, mingo@redhat.com, Borislav Petkov <bp@suse.de>,
        bpoirier@suse.de, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH v2 1/2] sched: add cond_resched_irq()
Message-ID: <20141211210649.GR25677@wotan.suse.de>
References: <1418254487-9988-1-git-send-email-mcgrof@do-not-panic.com> <1418254487-9988-2-git-send-email-mcgrof@do-not-panic.com> <5489AADA020000780004EFB9@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5489AADA020000780004EFB9@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 06:31:54AM -0700, Jan Beulich wrote:
> >>> On 11.12.14 at 00:34, <mcgrof@do-not-panic.com> wrote:
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -4239,6 +4239,16 @@ int __sched _cond_resched(void)
> >  }
> >  EXPORT_SYMBOL(_cond_resched);
> >  
> > +int __sched cond_resched_irq(void)
> > +{
> > +	if (should_resched()) {
> > +		preempt_schedule_irq();
> > +		return 1;
> > +	}
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(cond_resched_irq);
> 
> Do you really want to export to modules a symbol like this?

You mean lets not, true and good point. Let's see if seems
if we go with Andy's suggestion we may not need this anyway.

  Luis
