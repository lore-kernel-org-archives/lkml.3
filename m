Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaKKUtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 15:49:40 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:44931 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaKKUti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 15:49:38 -0500
MIME-Version: 1.0
In-Reply-To: <54626BF2.7070304@amacapital.net>
References: <1415663739-25525-1-git-send-email-andi@firstfloor.org>
 <1415663739-25525-4-git-send-email-andi@firstfloor.org> <54626BF2.7070304@amacapital.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 11 Nov 2014 12:49:16 -0800
Message-ID: <CALCETrXtF7LNDx+eN+fJZL9JU2_UK-y+g9g_huebN9q3sihcfg@mail.gmail.com>
Subject: Re: [PATCH 4/8] x86: Add support for rd/wr fs/gs base
To: Andi Kleen <andi@firstfloor.org>, X86 ML <x86@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 12:05 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On 11/10/2014 03:55 PM, Andi Kleen wrote:
>> To prevent recursive interrupts clobbering this
>> state in the task_struct this is only done for interrupts
>> coming directly from ring 3.
>
> Since this just came up in a different context today, I'd like to
> propose a different solution to this piece of the problem.
>
> Can we change the paranoid entry to check if the entry came from ring 3
> and to just switch stacks immediately to the standard kernel stack and
> run the non-paranoid entry code?  This eliminates paranoid_userspace
> entirely, and there are no special gsbase machinations any more for the
> entry-from-userspace path.
>
> In fact, I think that this will result in the MSR KERNEL_GS_BASE value
> *always* matching the userspace gs value from any C code in the kernel,
> since we'll always swapgs exactly once on entry from userspace.

I'll send patches in a couple hours.  I have it mostly working.

--Andy
