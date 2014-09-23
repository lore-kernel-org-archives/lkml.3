Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401AbaIWQMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:12:36 -0400
Received: from mail-oi0-f52.google.com ([209.85.218.52]:41347 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117AbaIWQMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:12:34 -0400
Message-ID: <54219BEE.7090309@mvista.com>
Date: Tue, 23 Sep 2014 11:12:30 -0500
From: Corey Minyard <cminyard@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>, minyard@acm.org
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mips: Save all registers when saving the frame
References: <1410903925-10744-1-git-send-email-minyard@acm.org> <20140918095813.GA9804@linux-mips.org> <541AD6E9.2010609@mvista.com>
In-Reply-To: <541AD6E9.2010609@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?  I haven't heard anything on this.

Thanks,

-corey

On 09/18/2014 07:58 AM, Corey Minyard wrote:
> On 09/18/2014 04:58 AM, Ralf Baechle wrote:
>> On Tue, Sep 16, 2014 at 04:45:25PM -0500, minyard@acm.org wrote:
>>
>>> From: Corey Minyard <cminyard@mvista.com>
>>>
>>> The MIPS frame save code was just saving a few registers, enough to
>>> do a backtrace if every function set up a frame.  However, this is
>>> not working if you are using DWARF unwinding, because most of the
>>> registers are wrong.  This was causing kdump backtraces to be short
>>> or bogus.
>>>
>>> So save all the registers.
>> The stratey of partial and full stack frames was developed in '97 to bring
>> down the syscall overhead.  It certaily was very effective - it brought
>> down the syscall latency to the level of Alphas running at much higher
>> clock.
>>
>> That certainly worked well back then for kernel 2.0 / 2.2.  But the syscall
>> code has become much more complex.  Since then support for 64 bit kernels,
>> two 32 bit ABIs running on a 64 bit kernels and numerous features that
>> changed the once simple syscall path have been implemented.  My gut feeling
>> is it might be worth to yank out the whole optimization to see how much
>> code complexity we get rid of in exchange for how much extra syscall
>> latency.
> I"m not sure I understand.  From what I can tell, this code is only
> called by
> things that print stack traces, kdb, and kexec/kdump.  So it shouldn't be in
> any normal syscall path.
>
> This patch will currently only help kdump, but it will be necessary if
> anyone
> adds MIPS support for DWARF unwinding for stack traces.  And you'd have
> to fix some things in context switching, too, I think.
>
> From what I can tell the partial save for syscalls is a good idea.  You
> don't have
> to save half the registers and it doesn't affect tracebacks, kdump, or
> anything else
> like that.
>
> -corey

