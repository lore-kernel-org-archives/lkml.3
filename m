Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaEZVkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 17:40:31 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:47144 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbaEZVk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 17:40:27 -0400
MIME-Version: 1.0
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C712205A605703@ORSMSX106.amr.corp.intel.com>
References: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
 <538397F5.6010002@amacapital.net> <3E5A0FA7E9CA944F9D5414FEC6C712205A605703@ORSMSX106.amr.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 26 May 2014 14:40:06 -0700
Message-ID: <CALCETrUyVBfWkhckAo0STtY_Sq4OGXw5-c8f_w_ZKQxSWxTCvA@mail.gmail.com>
Subject: Re: [PATCH 0/15] x86/xsaves: Optimize xstate context switch by xsaves/xrstors
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 1:13 PM, Yu, Fenghua <fenghua.yu@intel.com> wrote:
>> From: Andy Lutomirski [mailto:luto@amacapital.net]
>> On 05/26/2014 10:01 AM, Fenghua Yu wrote:
>> > From: Fenghua Yu <fenghua.yu@intel.com>
>> >
>> > With ever growing extended state registers (xstate) on x86 processors,
>> kernel
>> > needs to cope with issue of growing memory space occupied by xstate.
>> The xsave
>> > area is holding more and more xstate registers, growing from legacy
>> FP and
>> > SSE to AVX, AVX2, AVX-512, MPX, and Intel PT.
>> >
>> > The recently introduced compacted format of xsave area saves xstates
>> only
>> > for enabled states. This patch set saves the xsave area space per
>> process
>> > in compacted format by xsaves/xrstors instructions.
>>
>> Are we going to want to encourage userspace to do something like
>> sticking vzeroupper right before each syscall to make any
>> xsaves/xrestores faster?
>
> This patch set allow compacted format in kernel and standard format
> in user space. This works fine for both kernel and user application.

My question is purely about optimization: if userspace does a blocking
system call, will it be significantly faster if userspace zeros out as
much of the extended state as possible before doing the system call?

I think I tried this once with xsaveopt and decided that it didn't
make much of a difference.

--Andy
