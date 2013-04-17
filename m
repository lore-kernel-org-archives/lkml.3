Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966223Ab3DQMou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 08:44:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758076Ab3DQMot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 08:44:49 -0400
Date: Wed, 17 Apr 2013 14:40:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, Ingo Molnar <mingo@elte.hu>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Maneesh Soni <maneesh@linux.vnet.ibm.com>,
        Prasad <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ptrace/x86: dont delay perf_event_disable() till
	second pass in ptrace_write_dr7()
Message-ID: <20130417124056.GA7359@redhat.com>
References: <20130414191205.GA28791@redhat.com> <20130414191232.GA28816@redhat.com> <20130416004452.GG17561@somewhere.redhat.com> <20130416133017.GB9189@redhat.com> <CAFTL4hzzrqnm4TixUsCf57Xu+AHfSe26OToOo4y=RJzqF8FREg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hzzrqnm4TixUsCf57Xu+AHfSe26OToOo4y=RJzqF8FREg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17, Frederic Weisbecker wrote:
>
> 2013/4/16 Oleg Nesterov <oleg@redhat.com>:
> >
> > Well, I disagree.
> >
> > To clarify, I agree with WARN_ON_ONCE(), but afaics it has nothing to
> > do with "second_pass",
> >
> >> And these are indeed supposed
> >> to.
> >
> > Indeed, but this is because ptrace_modify_breakpoint() should not fail.
> >
> > So, what do you think if I change the main loop above
> >
> >                 rc = ptrace_modify_breakpoint(...)
> >         -       if (rc)
> >         +       if (WARN_ON_ONCE(rc))
> >                         break;
>
> It can fail in the first pass if dr7 is incorrect. For example passing
> a length
    ^^^^^^

Oops. Indeed, I forgot that ptrace_modify_breakpoint() has other arguments,
not only "disabled" ;)

Thanks for correcting me.

Oleg.

