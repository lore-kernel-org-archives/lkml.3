Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934809AbaKNBgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:36:33 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:34253 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934017AbaKNBgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:36:32 -0500
MIME-Version: 1.0
In-Reply-To: <FA327E3E-10C2-4CAE-A750-812BE6CF74FB@intel.com>
References: <c2522bcacf5db9a25a819a8756502edb1d2ca10f.1415739239.git.luto@amacapital.net>
 <20141112220058.GA5295@redhat.com> <CALCETrWA5z7-1fiz_9N0Qi2OR5s1jCkHiynCtTD_+9taOBs-Mg@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292BAB4@ORSMSX114.amr.corp.intel.com>
 <CALCETrU8uyc4nu-5MBXQR0PY0rexUhPkuPRLK+gWt0gEWMDhTA@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292BD44@ORSMSX114.amr.corp.intel.com>
 <CALCETrUpqSpcKFRM6a1zJWebEVZxNd-5pyBW4fU19+HgcBv+2Q@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292CB9A@ORSMSX114.amr.corp.intel.com>
 <CALCETrVx7hGZodWfAoU1oee1SW7XXSn3Lr8Vs9JTOUMNtLXY4A@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292D57B@ORSMSX114.amr.corp.intel.com>
 <CALCETrVB9VQPqFb7GQyxmVEKYtPhppmZS8SewQmtre+3_su9FA@mail.gmail.com>
 <CALCETrVJE25Txr5vRKAxHpeKx9p0VJBbat44w+X4gT8qX7a4bg@mail.gmail.com>
 <CALCETrVYWAOzaHqet8gS5hafvQC9prrH05qgc+v5dxSL9AF8bg@mail.gmail.com> <FA327E3E-10C2-4CAE-A750-812BE6CF74FB@intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 13 Nov 2014 17:36:09 -0800
Message-ID: <CALCETrVG5JrEhRNMm8VBmCKECqmQ+bcpnUVNEig96pcB3OkXuQ@mail.gmail.com>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from userspace
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 5:20 PM, Luck, Tony <tony.luck@intel.com> wrote:
> "worst ==
> MCE_AR_SEVERITY but regs->cs == 0 (i.e. in kernel)"
>
> This can't happen. We can only declare AR severity for a user mode fault.

I believe you, and I see that in the code, but the code is mightily twisted.

Anyway, my v3 will also catch a failure in which my asm fails to
switch to the right stack for some other reason.

Without the scheduling in the idle thread warning, I'd believe that
the problem is that some cpu is going out to lunch or failing to
receive the #MC, which would make me want to consider IRET issues (w/
my patch, there might not be an IRET until after memory_failure, and
maybe it sometimes takes a really long time).  But I don't see why
that would cause a scheduling in the idle thread warning.

>
> Sent from my iPhone
>
>> On Nov 13, 2014, at 16:50, Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> worst ==
>> MCE_AR_SEVERITY but regs->cs == 0 (i.e. in kernel)



-- 
Andy Lutomirski
AMA Capital Management, LLC
