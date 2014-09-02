Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbaIBJQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 05:16:38 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:39673 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752524AbaIBJQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 05:16:36 -0400
Date: Tue, 2 Sep 2014 10:16:22 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "arndb@arndb.de" <arndb@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v6 2/6] arm64: ptrace: allow tracer to skip a system
	call
Message-ID: <20140902091622.GK30401@n2100.arm.linux.org.uk>
References: <1408611405-8943-1-git-send-email-takahiro.akashi@linaro.org> <1408611405-8943-3-git-send-email-takahiro.akashi@linaro.org> <CAGXu5jJCyqpXkdvNDCu+eMr0qnqwbqUUo4u+2p_7DvFMzfKoEw@mail.gmail.com> <53F69045.7010301@linaro.org> <20140826175128.GD23445@arm.com> <53FD72E2.4020103@linaro.org> <20140901114751.GG30401@n2100.arm.linux.org.uk> <54058421.5070506@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54058421.5070506@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 05:47:29PM +0900, AKASHI Takahiro wrote:
> On 09/01/2014 08:47 PM, Russell King - ARM Linux wrote:
>> On Wed, Aug 27, 2014 at 02:55:46PM +0900, AKASHI Takahiro wrote:
>>> 1)
>>> setting x0 to -ENOSYS is necessary because, otherwise, user-issued syscall(-1) will
>>> return a bogus value when audit tracing is on.
>>>
>>> Please note that, on arm,
>>>                   not traced      traced
>>>                   ------          ------
>>> syscall(-1)      aborted         OOPs(BUG_ON)
>>> syscall(-3000)   aborted         aborted
>>> syscall(1000)    ENOSYS          ENOSYS
>>
>> Two points here:
>>
>> 1. You've found a case which causes a BUG_ON().  Where is the bug report
>>     for this, so the problem can be investigated and resolved?
>
> I think that I mentioned it could also happen on arm somewhere in a talk
> with Will, but don't remember exactly when.

Sorry, not good enough.  Please report this bug so it can be investigated
and fixed.

>> 2. What do you mean by "aborted" ?
>
> I mean that the process will receive SIGILL and get aborted.
> A system call number, like -1 and -3000, won't be trapped by *switch*
> statement in asm_syscall() and end up with being signaled.

That is correct behaviour - because numbers greater than 0xf0000 (or
0x9f0000 for OABI - the 0x900000 offset on the syscalls on OABI is to
distinguish them from syscalls used by RISC OS) are not intended to
be Linux syscalls per-se.

>> Please, if you find a problem with 32-bit ARM, report it.  Don't hide it,
>> because hiding it can be a security issue or in the case of BUG_ON(), it
>> could be a denial of service issue.
>>
>> As you're part of Linaro, I would have thought you'd be more responsible
>> in this regard - after all, Linaro is supposed to be about improving the
>> ARM kernel...  Maybe I got that wrong, and Linaro is actually about
>> ensuring that the ARM kernel is stuffed full of broken features?
>
> I thought my first priority was on arm64 (and then arm), but now that
> you and Will seem to want to see the fix first on arm, okey, I will
> start with arm issue.

So what you're saying there is that if you find a bug in ARM code, which
everyone is currently using, you can ignore it until you've sorted out
ARM64 which almost no one is using.

This is absurd, and whoever has set your priorities is clearly on drugs.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
