Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329AbaHAWLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 18:11:30 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:43768 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaHAWL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 18:11:29 -0400
MIME-Version: 1.0
In-Reply-To: <53DBDDE1.5070805@zytor.com>
References: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com>
 <1406904498-21647-4-git-send-email-dvlasenk@redhat.com> <53DBDDE1.5070805@zytor.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Sat, 2 Aug 2014 00:11:08 +0200
Message-ID: <CAK1hOcML4guky7VutK1xc3YxNjy4K4bX_78p8+7rEhMW0ZuLdg@mail.gmail.com>
Subject: Re: [PATCH 4/5] x86: entry_64.S: always allocate complete "struct pt_regs"
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 1, 2014 at 8:35 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 08/01/2014 07:48 AM, Denys Vlasenko wrote:
>>
>> Patch was run-tested: 64-bit executables, 32-bit executables,
>> strace works.
>>
>
> Could you please try to see if there is a measurable change in the
> latency of a trivial syscall?

Will do.
Something along the lines of "how long does it take to execute two
gazillions of getppid()?"

I'll send v2 shortly - I just figured out what was this mysterious
dance with allocating "not-quite-full struct pt_regs" on interrupt path:
It is intended to make nested interrupts to have better
backtraces. I broke that by this patch, v2 will have this feature retained.
