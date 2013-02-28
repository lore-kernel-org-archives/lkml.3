Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab3B1H1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 02:27:39 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:38524 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab3B1H1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 02:27:38 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUXGGQjKAwAET81pioAfZBw8mj3MO49Mm3xc35-UY=BgTg@mail.gmail.com>
References: <CA+icZUUsedHPqZc5jXQ_AqAbfmTMu5WW8CJ+vnHwL69ofw7uTw@mail.gmail.com>
	<20130227122302.GA5678@pd.tnic>
	<CA+icZUVXDfOhztQtrOxyYaHutpx=iVpPGmRT0PzP7045_mjh6w@mail.gmail.com>
	<CA+icZUXJb5O7ML-xnQq8Zoa46NmaGZp2Xaqj6fJL+vudPeQTLw@mail.gmail.com>
	<20130227150733.GB22383@htj.dyndns.org>
	<CA+icZUXGGQjKAwAET81pioAfZBw8mj3MO49Mm3xc35-UY=BgTg@mail.gmail.com>
Date: Thu, 28 Feb 2013 08:27:36 +0100
Message-ID: <CA+icZUUQPmo+dNRA2W_QMJ9zSwYPpqMMnr5brmE==TzG9bS8sw@mail.gmail.com>
Subject: Re: [next-20130227] kernel NULL pointer dereference [ watchdog | perf
 related ? ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Wim Van Sebroeck <wim@iguana.be>,
        Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-watchdog@vger.kernel.org, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 8:24 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Wed, Feb 27, 2013 at 4:07 PM, Tejun Heo <tj@kernel.org> wrote:
>> Replying here too just in case.
>>
>> On Wed, Feb 27, 2013 at 02:08:40PM +0100, Sedat Dilek wrote:
>>> >> static inline void *idr_find(struct idr *idr, int id)
>>> >> {
>>> >>         struct idr_layer *hint = rcu_dereference_raw(idr->hint);
>>> >>     86d7:       48 8b 05 00 00 00 00    mov    0x0(%rip),%rax        # 86de <perf_init_event+0x2e>
>>> >>                         86da: R_X86_64_PC32     .bss+0xfc
>>> >>
>>> >>         if ((id & ~IDR_MASK) == hint->prefix)
>>> >>     86de:       89 f2                   mov    %esi,%edx
>>> >>     86e0:       30 d2                   xor    %dl,%dl
>>> >>     86e2:       3b 10                   cmp    (%rax),%edx              <--- trapping insn
>>> >>     86e4:       74 4a                   je     8730 <perf_init_event+0x80>
>>> >>                 return rcu_dereference_raw(hint->ary[id & IDR_MASK]);
>>> >>
>>> >>
>>> >> So 'hint' is NULL as RAX above confirms and we're not supposed to deref
>>> >> NULL things.
>>> >>
>>> >> Looking at 29cf29e1fbb875019713eb55cf27ec35f1e5fa5e, Tejun should
>>> >> probably know. CCed.
>>
>> Fix was posted some days ago.
>>
>>   http://thread.gmane.org/gmane.linux.kernel.next/26213
>>
>> I got Andrew's patch added to -mm message a week ago.  Not sure why it
>> still hasn't showed up.  Andrew, any ideas?
>>
>> Thanks.
>>
>> --
>> tejun
>
> AFAICS the updated (correct) patch "idr: implement lookup hint" is now
> in mainline.
>

...but not in next-20130228 yet (tomorrow's Linux-Next will have it).

- Sedat -

> - Sedat -
>
> [1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=0ffc2a9c8072969253a20821c2c733a2cbb4c7c7
