Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbaEZVrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 17:47:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37464 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbaEZVrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 17:47:41 -0400
Message-ID: <5383B65F.6030602@zytor.com>
Date: Mon, 26 May 2014 14:47:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        "Yu, Fenghua" <fenghua.yu@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH 0/15] x86/xsaves: Optimize xstate context switch by xsaves/xrstors
References: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com> <538397F5.6010002@amacapital.net> <3E5A0FA7E9CA944F9D5414FEC6C712205A605703@ORSMSX106.amr.corp.intel.com> <CALCETrUyVBfWkhckAo0STtY_Sq4OGXw5-c8f_w_ZKQxSWxTCvA@mail.gmail.com>
In-Reply-To: <CALCETrUyVBfWkhckAo0STtY_Sq4OGXw5-c8f_w_ZKQxSWxTCvA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2014 02:40 PM, Andy Lutomirski wrote:
>>>
>>> Are we going to want to encourage userspace to do something like
>>> sticking vzeroupper right before each syscall to make any
>>> xsaves/xrestores faster?
>>
>> This patch set allow compacted format in kernel and standard format
>> in user space. This works fine for both kernel and user application.
> 
> My question is purely about optimization: if userspace does a blocking
> system call, will it be significantly faster if userspace zeros out as
> much of the extended state as possible before doing the system call?
> 
> I think I tried this once with xsaveopt and decided that it didn't
> make much of a difference.
> 

XSAVEOPT and XSAVES would be the same in this case.  Keep in mind, too,
that relatively few system calls result in context switches, which is
the only time this ends up mattering.

	-hpa


