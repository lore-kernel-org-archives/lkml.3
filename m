Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbaJGAaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 20:30:05 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:56300 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaJGAaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 20:30:03 -0400
MIME-Version: 1.0
In-Reply-To: <CA+=Sn1n_S-JT1pZwMtDGM+Vkbp7rsg4bPAeESwJpSkbx8vqn5g@mail.gmail.com>
References: <1412627010-4311-1-git-send-email-ddaney.cavm@gmail.com>
 <20141006205459.GZ23797@brightrain.aerifal.cx> <5433071B.4050606@caviumnetworks.com>
 <20141006213101.GA23797@brightrain.aerifal.cx> <54330D79.80102@caviumnetworks.com>
 <20141006215813.GB23797@brightrain.aerifal.cx> <543327E7.4020608@amacapital.net>
 <54332A64.5020605@caviumnetworks.com> <20141007000514.GD23797@brightrain.aerifal.cx>
 <CA+=Sn1nR2ugXUf=V9F9O6VLAP1d6WhBDioZzu0G05-8z6KMMuA@mail.gmail.com>
 <20141007002147.GE23797@brightrain.aerifal.cx> <CA+=Sn1n_S-JT1pZwMtDGM+Vkbp7rsg4bPAeESwJpSkbx8vqn5g@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 6 Oct 2014 17:29:41 -0700
Message-ID: <CALCETrXz+rYB0JxuXLPZroWCsqHqajfemiG1ohS7o33QebwQkA@mail.gmail.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
To: Andrew Pinski <pinskia@gmail.com>
Cc: Rich Felker <dalias@libc.org>, David Daney <ddaney@caviumnetworks.com>,
        David Daney <ddaney.cavm@gmail.com>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        David Daney <david.daney@cavium.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 6, 2014 at 5:28 PM, Andrew Pinski <pinskia@gmail.com> wrote:
> On Mon, Oct 6, 2014 at 5:21 PM, Rich Felker <dalias@libc.org> wrote:
>> On Mon, Oct 06, 2014 at 05:11:38PM -0700, Andrew Pinski wrote:
>>> On Mon, Oct 6, 2014 at 5:05 PM, Rich Felker <dalias@libc.org> wrote:
>>> > On Mon, Oct 06, 2014 at 04:48:52PM -0700, David Daney wrote:
>>> >> On 10/06/2014 04:38 PM, Andy Lutomirski wrote:
>>> >> >On 10/06/2014 02:58 PM, Rich Felker wrote:
>>> >> >>On Mon, Oct 06, 2014 at 02:45:29PM -0700, David Daney wrote:
>>> >> [...]
>>> >> >>This is a huge ill-designed mess.
>>> >> >
>>> >> >Amen.
>>> >> >
>>> >> >Can the kernel not just emulate the instructions directly?
>>> >>
>>> >> In theory it could, but since there can be implementation defined
>>> >> instructions, there is no way to achieve full instruction set
>>> >> coverage for all possible machines.
>>> >
>>> > Is the issue really implementation-defined instructions with delay
>>> > slots? If so it sounds like a made-up issue. They're not going to
>>> > occur in real binaries. Certainly a compiler is not going to generate
>>> > implementation-defined instructions, and if you're writing the asm by
>>> > hand, you just don't put floating point instructions in the delay
>>> > slot.
>>>
>>> It is not the instruction with delay slot but rather the instruction
>>> in the delay slot itself.
>>
>> An instruction in the delay slot for the instruction being emulated?
>> How would that arise? Are there floating point instructions with delay
>> slots?
>
> Yes branches.

I admit I have no idea what's going here, but I find it hard to
believe that having the kernel fix this up for new code is desirable.
Unless MIPS can round-trip a trap *very* quickly, performance will be
awful for any code that has this problem.

--Andy
