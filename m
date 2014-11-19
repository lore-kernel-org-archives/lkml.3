Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbaKSIq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 03:46:29 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:42828 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbaKSIq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 03:46:27 -0500
Message-ID: <546C58DB.5080204@linaro.org>
Date: Wed, 19 Nov 2014 17:46:19 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "keescook@chromium.org" <keescook@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 2/6] arm64: ptrace: allow tracer to skip a system call
References: <1416273038-15590-1-git-send-email-takahiro.akashi@linaro.org> <1416273038-15590-3-git-send-email-takahiro.akashi@linaro.org> <20141118140425.GM18842@arm.com>
In-Reply-To: <20141118140425.GM18842@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2014 11:04 PM, Will Deacon wrote:
> On Tue, Nov 18, 2014 at 01:10:34AM +0000, AKASHI Takahiro wrote:
>>
>> +	if (((int)regs->syscallno == -1) && (orig_syscallno == -1)) {
>> +		/*
>> +		 * user-issued syscall(-1):
>> +		 * RESTRICTION: We always return ENOSYS whatever value is
>> +		 *   stored in x0 (a return value) at this point.
>> +		 * Normally, with ptrace off, syscall(-1) returns -ENOSYS.
>> +		 * With ptrace on, however, if a tracer didn't pay any
>> +		 * attention to user-issued syscall(-1) and just let it go
>> +		 * without a hack here, it would return a value in x0 as in
>> +		 * other system call cases. This means that this system call
>> +		 * might succeed and see any bogus return value.
>> +		 * This should be definitely avoided.
>> +		 */
>> +		regs->regs[0] = -ENOSYS;
>> +	}
>
> I'm still really uncomfortable with this, and it doesn't seem to match what
> arch/arm/ does either.

Yeah, I know but
as I mentioned before, syscall(-1) will be signaled on arm, and so we don't
have to care about a return value :)

> Doesn't it also prevent a tracer from skipping syscall(-1)?

Syscall(-1) will return -ENOSYS whether or not a syscallno is explicitly replaced with -1
by a tracer, and, in this sense, it is *skipped*.

-Takahiro AKASHI

> Will
>
