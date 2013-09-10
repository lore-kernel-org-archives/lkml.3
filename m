Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab3IJWo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:44:59 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:34438 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab3IJWo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:44:58 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+-Hpe1hFH4z8dk1E8ASR4NxNYBH5j_PdgmwGAkWgcFEA@mail.gmail.com>
References: <20130718230312.GA22348@www.outflux.net>
	<CA+8MBb+i+kmnAMi4dTEX9nGwMLRz0EUz0tY0N7YA2btFEtgmQw@mail.gmail.com>
	<CAGXu5j+-Hpe1hFH4z8dk1E8ASR4NxNYBH5j_PdgmwGAkWgcFEA@mail.gmail.com>
Date: Tue, 10 Sep 2013 15:44:57 -0700
X-Google-Sender-Auth: cETYHzv9IZ2fDBzJpATqr_ZX_6w
Message-ID: <CAGXu5jJtWJ=hhMVg7u28gEGOq3ue1f_phxZ-GTF0sfV5EgVoBw@mail.gmail.com>
Subject: Re: [PATCH] panic: call panic handlers before kmsg_dump
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>, Tony Luck <tony.luck@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Vikram Mulukutla <markivx@codeaurora.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 3:41 PM, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Jul 18, 2013 at 4:17 PM, Tony Luck <tony.luck@gmail.com> wrote:
>> On Thu, Jul 18, 2013 at 4:03 PM, Kees Cook <keescook@chromium.org> wrote:
>>> Since the panic handlers may produce additional information (via printk)
>>> for the kernel log, it should be reported as part of the panic output
>>> saved by kmsg_dump(). Without this re-ordering, nothing that adds
>>> information to a panic will show up in pstore's view when kmsg_dump
>>> runs, and is therefore not visible to crash reporting tools that examine
>>> pstore output.
>>
>> Good point.
>>
>> Acked-by: Tony Luck <tony.luck@intel.com>
>
> Can someone pick this patch up? If akpm doesn't want it, it could live
> in the pstore tree maybe?

Ah, sorry, it seems like it is already in -mm. Never mind!

-Kees

-- 
Kees Cook
Chrome OS Security
