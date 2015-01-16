Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbbAPQIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:08:14 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:55451 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540AbbAPQIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:08:13 -0500
MIME-Version: 1.0
In-Reply-To: <20150116155923.GK12302@n2100.arm.linux.org.uk>
References: <1420986751-30364-1-git-send-email-r.peniaev@gmail.com>
	<1420986751-30364-2-git-send-email-r.peniaev@gmail.com>
	<20150112183955.GO13360@arm.com>
	<CACZ9PQXW9G4Vw-dcPwkdVE=uoYmDYEQnJWDnnpup1LxC3s5QPg@mail.gmail.com>
	<CAGXu5jLO-YSaF8P9o3jcXP4VZCPYVshz73krnchYuv9pPGY6Sw@mail.gmail.com>
	<CACZ9PQVo0SF4Z-rdNk4e=yY17Xt9n5hAqm4ZRNLEw3jGYYcvtA@mail.gmail.com>
	<CAGXu5j+O6znN=7-gc3PqwqFA5MFRPLGBUzabOmQjWn_9WTjvpg@mail.gmail.com>
	<CACZ9PQUEprgKrpHazDULA5mf-OaoX=MAjEeWdspZTXT_+iUKWw@mail.gmail.com>
	<20150116155923.GK12302@n2100.arm.linux.org.uk>
Date: Sat, 17 Jan 2015 01:08:11 +0900
Message-ID: <CACZ9PQUVFtCQg6XjDbokEPy_R2fZcHiq6+EEUZnx4FVfpfZxJg@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: entry-common: fix forgotten set of thread_info->syscall
From: Roman Peniaev <r.peniaev@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>, Will Deacon <will.deacon@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sekhar Nori <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2015 at 12:59 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sat, Jan 17, 2015 at 12:57:02AM +0900, Roman Peniaev wrote:
>> On Fri, Jan 16, 2015 at 7:54 AM, Kees Cook <keescook@chromium.org> wrote:
>> > One interesting thing I noticed (which is unchanged by this series),
>> > but pulling ARM_r7 during the seccomp ptrace event shows __NR_poll,
>> > not __NR_restart_syscall, even though it was a __NR_restart_syscall
>> > trap from seccomp. Is there a better place to see the actual syscall?
>>
>> As I understand we do not push new r7 to the stack, and ptrace uses the
>> old value.
>
> And why should we push r7 to the stack?  ptrace should be using the
> recorded system call number, rather than poking about on the stack
> itself.

Probably we should not, but the behaviour comparing arm to x86 is different.

Also there is no any way from userspace to figure out what syscall was
restarted,
if you do not trace each syscall enter and exit from the very beginning.

--
Roman
