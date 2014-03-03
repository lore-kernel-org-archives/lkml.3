Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbaCCGXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 01:23:42 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:48104 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaCCGXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 01:23:40 -0500
Date: Mon, 3 Mar 2014 11:53:24 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: David Long <dave.long@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, linux-arm-kernel@lists.infradead.org,
        Rabin Vincent <rabin@rab.in>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 00/14] uprobes: Add uprobes support for ARM
Message-ID: <20140303062324.GB20583@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1392017945-4507-1-git-send-email-dave.long@linaro.org>
 <20140301123026.GD21483@n2100.arm.linux.org.uk>
 <53131DBE.7020500@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <53131DBE.7020500@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030306-0260-0000-0000-000004761E3A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Oleg,
>

> I've been looking at arch/Kconfig and kernel/trace/Kconfig where
> they deal with uprobes.  The relevant items are CONFIG_UPROBES and
> CONFIG_UPROBE_EVENT.  It just doesn't look right to me.  It looks

It should be me who should take the blame for this and not Oleg.  This
was discussed more than couple of times.  I can recollect couple of
discussions here.
http://article.gmane.org/gmane.linux.kernel/1017186
http://article.gmane.org/gmane.linux.kernel/1001605

I know there were more discussions on this, but I cant dig them out at
this time.  Finally it was decided that
1. Users shouldnt have to select more than one config to select Uprobes.
2. There was no point in selecting Uprobes and not having Uprobe_event
and vice versa.

>From the above, If a user chose UPROBE_EVENT, (which is the interface
for uprobes), we would automatically assume that he wants to use Uprobes
framework.

> like "select" is used in part maybe just to avoid the recursive
> dependency error that would be generated if "depends on" were used
> in both places.

We did "Select Uprobes" not because of avoiding recursive dependency but
as told above, to select the framework, given that user has chosen the
framework. We dont want to give a choice to user to choose uprobe_event
but not choose Uprobes or vice versa.

> However I don't think UPROBES should be dependent on
> UPROBE_EVENT, only the other way around.  As RK noted in previous

Whats the point of having the framework(Uprobes) without an interface?

> email (copied in part below) the select does not pull in the lower
> level dependencies.  This all works on x86 only because
> arch/x86/Kconfig defines CONFIG_PERF_EVENT (which feels like a big
> hammer).  We don't need to do this on ARM, and we don't do it.  The
> result is that, unless PERF_EVENT is set separately, uprobes tends
> not to build.  I was lucking-out in my testing due to other default
> config items turning on PERF_EVENT.
>

--
Thanks and Regards
Srikar Dronamraju

