Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab3KTSb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 13:31:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39277 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373Ab3KTSb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 13:31:28 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <87mwkzvvck.fsf@tassilo.jf.intel.com>
References: <1384820855-27790-1-git-send-email-andi@firstfloor.org> <528AF5D7.7000308@zytor.com> <20131119184959.GE29695@two.firstfloor.org> <528CE65B.6020300@zytor.com> <87mwkzvvck.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Add a text_poke syscall
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 20 Nov 2013 10:30:56 -0800
To: Andi Kleen <andi@firstfloor.org>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Message-ID: <ad0732bf-9042-4659-a107-348340016351@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why? Live patching works fine and keys the other threads run along just fine.  We do this for ftrace already...

Andi Kleen <andi@firstfloor.org> wrote:
>"H. Peter Anvin" <hpa@zytor.com> writes:
>>
>> We're talking user space here, which has different requirement (COW,
>> memory protection, ...) which means it is not really the same code. 
>You
>> can't take a page fault while patching the kernel.
>
>The syscall pins the page, then it calls the kernel code.
>There are no page faults during patching.
>
>> I'm referring to if some thread actually stumbles over INT 3, which
>is
>> indeed not very long for one patch site (as long as you don't end up
>> with page faults.)  However, for tracing, you may want to do tens of
>> thousands of patches, and you really want to batch them.
>
>For tens of thousand of patches you very likely don't want 
>live patching, but a stop everything approach.
>
>-Andi

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
