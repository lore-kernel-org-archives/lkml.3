Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbbAJWD0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 17:03:26 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:46629 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbbAJWDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 17:03:25 -0500
MIME-Version: 1.0
In-Reply-To: <20150110220042.GG12218@pd.tnic>
References: <1420734315-30943-1-git-send-email-dvlasenk@redhat.com>
 <1420734315-30943-4-git-send-email-dvlasenk@redhat.com> <20150109121950.GD13637@pd.tnic>
 <CAK1hOcMsGJ7geRAzfazPLZitcO0o9XYRPJDYa8sJHR4i6DPL-g@mail.gmail.com>
 <20150110142336.GC12218@pd.tnic> <CAK1hOcO7K=4N8CF=LOPmosXRNnogaNi5vLDPMdb0XiKsL=JOfg@mail.gmail.com>
 <20150110220042.GG12218@pd.tnic>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Sat, 10 Jan 2015 23:03:04 +0100
Message-ID: <CAK1hOcMqqcp=-4Q49VqcO1kNFdvaNy0H6PiUfKyknE2hjQmkrw@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86: open-code register save/restore in
 trace_hardirqs thunks
To: Borislav Petkov <bp@alien8.de>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 11:00 PM, Borislav Petkov <bp@alien8.de> wrote:
>> --- a/arch/x86/lib/thunk_64.S
>> +++ b/arch/x86/lib/thunk_64.S
>> @@ -17,9 +17,27 @@
>>       CFI_STARTPROC
>>
>>       /* this one pushes 9 elems, the next one would be %rIP */
>> -     SAVE_ARGS
>> +     pushq_cfi %rdi
>> +     CFI_REL_OFFSET rdi, 0
>
> Btw, why the second CFI annotation?
>
> pushq_cfi does already CFI_ADJUST_CFA_OFFSET 8. Can't we use one and
> hide it in the macro?

We probably should.

Since thunk_32.S uses the very same construct, I think it should be fixed
in both files by one patch.
