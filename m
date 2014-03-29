Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbaC2Hik (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 03:38:40 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:56969 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaC2Hij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 03:38:39 -0400
MIME-Version: 1.0
In-Reply-To: <878urunojo.fsf@tassilo.jf.intel.com>
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
	<1396014469-5937-17-git-send-email-jovi.zhangwei@gmail.com>
	<878urunojo.fsf@tassilo.jf.intel.com>
Date: Sat, 29 Mar 2014 15:38:38 +0800
Message-ID: <CAGdX0WGK+U1gg5YYALeviJSsPGF_5S3CjTNzNqVxSGeqDHfeqg@mail.gmail.com>
Subject: Re: [PATCH 16/28] ktap: add runtime/amalg.c
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Mar 29, 2014 at 2:52 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Jovi Zhangwei <jovi.zhangwei@gmail.com> writes:
>
>> Use amalgamation build make ktapvm.ko much smaller.
>>
>> No amalgamation build in x86_64:
>> ktapvm.ko: 2.4M
>>
>> amalgamation build in x86_64:
>> ktapvm.ko: 1.1M
>>
>> User can set use amalgamation build or not in Makefile.
>
> This seems dubious. Is that due to debug information?
>
> [if yes new enough toolchain can fix that]
>
> If it's due to code something is seriously wrong,
> perhaps in your inlines.
>

Change: The kernel module size without amalgamation build is: 3.1M

I guess it's not because of debug info.

Amalgamation build is a kind of simple 'LTO', it compiles the ktapvm as
one huge C file and allows GCC to generate faster and shorter code.

But I also surprised by the size gap, will spend some time to investigate it.

Thanks.

Jovi
