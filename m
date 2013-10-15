Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466Ab3JOPmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 11:42:20 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:34356 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759372Ab3JOPmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 11:42:18 -0400
MIME-Version: 1.0
In-Reply-To: <20131015060425.GB3866@gmail.com>
References: <20131011013954.GA28902@www.outflux.net>
	<tip-d751c169e9a6f0f853346f1184881422bd10b3c2@git.kernel.org>
	<20131014083035.GA20976@gmail.com>
	<007cdb12-9fc7-4744-8686-695891b926a3@email.android.com>
	<525C1BC1.6090501@zytor.com>
	<CAGXu5j+tQfUpmem85WK5-ootoJM1mCH6BPDr3pfR2sHwoFy_8A@mail.gmail.com>
	<20131015060425.GB3866@gmail.com>
Date: Tue, 15 Oct 2013 08:42:17 -0700
X-Google-Sender-Auth: 82fC6Eg7E-GB-wdoA4uWX6Dln74
Message-ID: <CAGXu5jJx1xkwZD=tC+D69H_6-cGMHD8Sk_9_=8XQxjjDtHpBNA@mail.gmail.com>
Subject: Re: [tip:x86/kaslr] x86, relocs: Add more per-cpu gold special cases
From: Kees Cook <keescook@chromium.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 11:04 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Kees Cook <keescook@chromium.org> wrote:
>
>> On Mon, Oct 14, 2013 at 9:28 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> > On 10/14/2013 07:19 AM, H. Peter Anvin wrote:
>> >> My guess is that the 95 addresses are randomized and the 82 address is an address which failed to relocate.
>> >
>> >> ffffffff82a04a58 is:
>> >> ffffffff82a03000 t init_per_cpu__gdt_page
>> >
>> >
>> > Specifically, it looks like the percpu stuff isn't getting set up correctly.
>>
>> It wouldn't surprise me if there are even more percpu things to fix.
>> It's the main area we've continued to trip over while working on this
>> with various linkers. Which linker and version are you seeing this
>> with?
>
> The failure I saw triggered with fairly modern userspace:
>
>  GNU ld version 2.23.52.0.1-9.fc19 20130226
>
>  gcc version 4.8.1 20130603 (Red Hat 4.8.1-1) (GCC)

Can you try with the gold linker? When not using Gold, I can produce a
similar crash with GNU ld ver 2.23.2 but not 2.22.

-Kees

-- 
Kees Cook
Chrome OS Security
