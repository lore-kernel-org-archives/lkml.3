Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933323AbaJ1EIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 00:08:13 -0400
Received: from out4133-66.mail.aliyun.com ([42.120.133.66]:28834 "EHLO
	out4133-66.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933209AbaJ1EIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 00:08:10 -0400
X-Greylist: delayed 1931 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Oct 2014 00:08:10 EDT
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;FP=0|-1|-1|-1|0|-1|-1|-1;HT=r41g06002;MF=hillf.zj@alibaba-inc.com;PH=DS;RN=10;RT=10;SR=0;
Reply-To: "Hillf Danton" <hillf.zj@alibaba-inc.com>
From: "Hillf Danton" <hillf.zj@alibaba-inc.com>
To: "'Andy Lutomirski'" <luto@amacapital.net>
Cc: "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Ingo Molnar'" <mingo@redhat.com>,
        "'Vince Weaver'" <vince@deater.net>,
        "'Paul Mackerras'" <paulus@samba.org>,
        "'Kees Cook'" <keescook@chromium.org>,
        "'Arnaldo Carvalho de Melo'" <acme@kernel.org>,
        "'Andrea Arcangeli'" <aarcange@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        "'Valdis Kletnieks'" <Valdis.Kletnieks@vt.edu>
References: <00cd01cff1b5$fda5a660$f8f0f320$@alibaba-inc.com> <CALCETrX7-OzQrOr3+TXy8NB8LS8aYwLN_A-vAeicwoQHsUH_yw@mail.gmail.com> <007d01cff260$3c69e9b0$b53dbd10$@alibaba-inc.com> <CALCETrW5iJWd65Ems6F3RZL+CxYrQ75nDyFFmgA52ky--pzwTQ@mail.gmail.com>
In-Reply-To: <CALCETrW5iJWd65Ems6F3RZL+CxYrQ75nDyFFmgA52ky--pzwTQ@mail.gmail.com>
Subject: RE: [PATCH v2 7/8] x86, perf: Only allow rdpmc if a perf_event is mapped
Date: Tue, 28 Oct 2014 12:07:43 +0800
Message-ID: <007e01cff264$bce6afc0$36b40f40$@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQGv8belJq57AVXnUT9ecJ/XX3ZkYAILijxMAfGBfZwCIFdox5xT+ZOg
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Subject: Re: [PATCH v2 7/8] x86, perf: Only allow rdpmc if a perf_event is mapped
> >>
> > CPU D                   CPU A
> > switch_mm
> > load_mm_cr4
> >                         x86_pmu_event_unmapped
> >
> > I wonder if the X86_CR4_PCE set on CPU D is
> > cleared by CPU A by broadcasting IPI.
> >
> 
> It should be okay.  The IPI does:
> 
> +       if (current->mm)
> +               load_mm_cr4(current->mm);
> 
> which refers to the current task running on the targetted CPU, not to
> the IPI sender's task.  So, if it happens after a context switch, it
> will harmlessly reload the new task's cr4.
>
Right, but prev != next is checked in switch_mm.
 
Hillf


