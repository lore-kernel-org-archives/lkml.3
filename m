Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399AbaJGT2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:28:42 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:44694 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932348AbaJGT2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:28:40 -0400
MIME-Version: 1.0
In-Reply-To: <20141007192107.GN23797@brightrain.aerifal.cx>
References: <54332A64.5020605@caviumnetworks.com> <20141007000514.GD23797@brightrain.aerifal.cx>
 <543334CE.8060305@caviumnetworks.com> <20141007004915.GF23797@brightrain.aerifal.cx>
 <54337127.40806@gmail.com> <6D39441BF12EF246A7ABCE6654B0235320F1E173@LEMAIL01.le.imgtec.org>
 <543431DA.4090809@imgtec.com> <CALCETrUQEbb=DotSzsneN7Hano_eC-EoTMko6uKcyZXvEcktkw@mail.gmail.com>
 <20141007190943.GM23797@brightrain.aerifal.cx> <54343C2B.2080801@imgtec.com> <20141007192107.GN23797@brightrain.aerifal.cx>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 7 Oct 2014 12:28:18 -0700
Message-ID: <CALCETrU8qPL1qKGk7FqM=LCnoeSfuwDV_bG_a=5zcOKtWfkdGw@mail.gmail.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
To: Rich Felker <dalias@libc.org>
Cc: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>,
        Matthew Fortune <Matthew.Fortune@imgtec.com>,
        David Daney <david.s.daney@gmail.com>,
        David Daney <ddaney@caviumnetworks.com>,
        David Daney <ddaney.cavm@gmail.com>,
        "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        David Daney <david.daney@cavium.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 7, 2014 at 12:21 PM, Rich Felker <dalias@libc.org> wrote:
> On Tue, Oct 07, 2014 at 12:16:59PM -0700, Leonid Yegoshin wrote:
>> On 10/07/2014 12:09 PM, Rich Felker wrote:
>> >I agree completely here. We should not break things (or, as it
>> >seems, leave them broken) for common usage cases that affect
>> >everyone just to coddle proprietary vendor-specific instructions.
>> >The latter just should not be used in delay slots unless the chip
>> >vendor also promises to provide fpu branch in hardware. Rich
>> And what do you propose - remove a current in-stack emulation and
>> you still think it doesn't break a status-quo?
>
> The in-stack trampoline support could be left but used only for
> emulating instructions the kernel doesn't know. This would make all
> normal binaries immediately usable with non-executable stack, and
> would avoid the only potential source of regressions. Ultimately I
> think the "xol" stuff should be removed, but that could be a long term
> goal.

Does anything break if the xol stuff is disabled for PT_GNU_STACK tasks?

>
> Rich



-- 
Andy Lutomirski
AMA Capital Management, LLC
