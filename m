Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150AbaJVQej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:34:39 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:45585 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361AbaJVQeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 12:34:36 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1410220945360.31528@ayla.of.borg>
References: <1413912653-3269-1-git-send-email-geert@linux-m68k.org>
	<CAADnVQ+5J+BM3onCUxzX+eL-gDqiJ04vDG4iD+3zbqngcmoqzQ@mail.gmail.com>
	<alpine.DEB.2.02.1410220945360.31528@ayla.of.borg>
Date: Wed, 22 Oct 2014 09:34:32 -0700
Message-ID: <CAADnVQLRMscjzgG3Y4ZTrehPS7xL1rOaGkfQRornKivD-6mfng@mail.gmail.com>
Subject: Re: [PATCH] m68k: Wire up bpf
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 12:48 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
>         Hi Alexei,
>
> On Tue, 21 Oct 2014, Alexei Starovoitov wrote:
>> On Tue, Oct 21, 2014 at 10:30 AM, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> > ---
>> >  arch/m68k/include/asm/unistd.h      | 2 +-
>> >  arch/m68k/include/uapi/asm/unistd.h | 1 +
>> >  arch/m68k/kernel/syscalltable.S     | 1 +
>> >  3 files changed, 3 insertions(+), 1 deletion(-)
>>
>> did the tests pass in samples/bpf/test_verifier ?
>
> Thanks for reminding me about the existence of the tests ;-)
>
> Yes, they passed.

Great, then:
Acked-by: Alexei Starovoitov <ast@plumgrid.com>

> Note that gcc 4.1.2 doesn't like C99-initialization of anonymous
> struct and union members, so I had to use the patch below:
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index d18316f9e9c488b0..6ec5060a6ece8f23 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -123,7 +123,7 @@ union bpf_attr {
>                 __u32   key_size;       /* size of key in bytes */
>                 __u32   value_size;     /* size of value in bytes */
>                 __u32   max_entries;    /* max number of entries in a map */
> -       };
> +       } create;

I've tested this stuff with 4.2 and up, since that's the oldest we
have in kernel.org cross-compilers repo.
4.1 was a first release with brand new C front-end which had
all sorts of gotchas and just like 4.0 was a massive release too.
Nowadays I wouldn't touch anything below 4.4
