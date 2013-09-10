Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab3IJWl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:41:27 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:37804 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab3IJWlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:41:25 -0400
MIME-Version: 1.0
In-Reply-To: <CA+8MBb+i+kmnAMi4dTEX9nGwMLRz0EUz0tY0N7YA2btFEtgmQw@mail.gmail.com>
References: <20130718230312.GA22348@www.outflux.net>
	<CA+8MBb+i+kmnAMi4dTEX9nGwMLRz0EUz0tY0N7YA2btFEtgmQw@mail.gmail.com>
Date: Tue, 10 Sep 2013 15:41:24 -0700
X-Google-Sender-Auth: wf3HV2g-CoHGoprdx93_xhgkirw
Message-ID: <CAGXu5j+-Hpe1hFH4z8dk1E8ASR4NxNYBH5j_PdgmwGAkWgcFEA@mail.gmail.com>
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

On Thu, Jul 18, 2013 at 4:17 PM, Tony Luck <tony.luck@gmail.com> wrote:
> On Thu, Jul 18, 2013 at 4:03 PM, Kees Cook <keescook@chromium.org> wrote:
>> Since the panic handlers may produce additional information (via printk)
>> for the kernel log, it should be reported as part of the panic output
>> saved by kmsg_dump(). Without this re-ordering, nothing that adds
>> information to a panic will show up in pstore's view when kmsg_dump
>> runs, and is therefore not visible to crash reporting tools that examine
>> pstore output.
>
> Good point.
>
> Acked-by: Tony Luck <tony.luck@intel.com>

Can someone pick this patch up? If akpm doesn't want it, it could live
in the pstore tree maybe?

-Kees

-- 
Kees Cook
Chrome OS Security
