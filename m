Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbaKXR6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:58:46 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:55837 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbaKXR6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:58:45 -0500
MIME-Version: 1.0
In-Reply-To: <20141122165501.GB4395@pd.tnic>
References: <cover.1416604491.git.luto@amacapital.net> <4eb18b212f8f62d0ea3dc0679930ede82d7d37fc.1416604491.git.luto@amacapital.net>
 <20141122165501.GB4395@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 24 Nov 2014 09:58:23 -0800
Message-ID: <CALCETrXyRo0c6eRhj762fuB+GhpjcBBVqMcdZC1kw69976Jd2Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/5] uprobes, x86: Fix _TIF_UPROBE vs _TIF_NOTIFY_RESUME
To: Borislav Petkov <bp@alien8.de>
Cc: X86 ML <x86@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2014 at 8:55 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Fri, Nov 21, 2014 at 01:26:07PM -0800, Andy Lutomirski wrote:
>> x86 call do_notify_resume on paranoid returns if TIF_UPROBE is set
>> but not on non-paranoid returns.  I suspect that this is a mistake
>> and that the code only works because int3 is paranoid.
>>
>> Setting _TIF_NOTIFY_RESUME in the uprobe code was probably a
>> workaround for the x86 bug.  With that bug fixed, we can remove
>> _TIF_NOTIFY_RESUME from the uprobes code.
>>
>> Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>> Reported-by: Oleg Nesterov <oleg@redhat.com>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>
> Acked-by: Borislav Petkov <bp@suse.de>
>

This one is now upstream, so I'm dropping it.

--Andy

> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --



-- 
Andy Lutomirski
AMA Capital Management, LLC
