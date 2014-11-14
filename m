Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422858AbaKNWHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 17:07:42 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:38282 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335AbaKNWHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 17:07:39 -0500
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3293BEAE@ORSMSX114.amr.corp.intel.com>
References: <CALCETrW0+5FkYn-5=WH1vGc-KnRaSj5w83Ds7R9ZTqFX3hQ+5g@mail.gmail.com>
 <20141111230926.GR31490@pd.tnic> <CALCETrU+Sq=rW-p2OnjLiaSLqu8rTgbC9uTcqZBJ+J8JhNxa7Q@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292A03B@ORSMSX114.amr.corp.intel.com>
 <CALCETrUU3vSLBVMpsma=8OqOZLRKUYBM19_94tkeZ7aWCEyhog@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292A157@ORSMSX114.amr.corp.intel.com>
 <CA+8MBbJy3QziFGDzOxMrweWEe_yneETuo4O8bTPZg=2y15qdkQ@mail.gmail.com>
 <20141112103011.GA16807@pd.tnic> <CALCETrWsWGf+WRf7gUWs5x=6Ts5KwqWpecrp-Q61jL7usTOvAQ@mail.gmail.com>
 <20141112162225.GF16807@pd.tnic> <20141113180436.GG14070@pd.tnic> <3908561D78D1C84285E8C5FCA982C28F3293BEAE@ORSMSX114.amr.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 14 Nov 2014 14:07:16 -0800
Message-ID: <CALCETrW+3TQvZAQfo5HsiHDku8C125sn5dNffOGKOeCHjZZrbw@mail.gmail.com>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from userspace
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 1:56 PM, Luck, Tony <tony.luck@intel.com> wrote:
>>> Right, I can do it in the meantime and we can always experiment more
>>> later. Getting rid of _TIF_MCE_NOTIFY is a good thing already.
>>
>> Yep, it looks pretty simple - not tested yet, it builds though.
>
> It seems pretty solid under test so far.
>
> Can we make it pass the address/flag to mce_notify_process() too? So
> we can get rid of mce_save_info() and mce_find_info().
>
> We'd need to wrap mce_task_work inside a bigger structure with fields
> to have the address and flags - then use "container_of" inside mce_notify_process().
>
> But I think that means we need more than one of these structures ... we may not
> be done with one before a new machine check occurs. So we'd have to make an
> NMI-safe allocator to grab one for use inside do_machine_check()

I think that this is a considerable benefit of my code, aside from the
non-working-ness part.  :-/

--Andy

>
> -Tony
>
> General testing note - one thing I did see was that if inject 1000 errors at 0.3s interval from
> my ssh'd login ... the serial console keeps streaming messages for about 40 seconds
> after my test says it is all done. This might be a factor in the other tests I've been
> running against the stack-switching code (especially with extra debug) ... at some
> point __log_buf must get full - what happens then?



-- 
Andy Lutomirski
AMA Capital Management, LLC
