Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428AbaJFXy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 19:54:29 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:51814 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaJFXy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 19:54:28 -0400
MIME-Version: 1.0
In-Reply-To: <54332A64.5020605@caviumnetworks.com>
References: <1412627010-4311-1-git-send-email-ddaney.cavm@gmail.com>
 <20141006205459.GZ23797@brightrain.aerifal.cx> <5433071B.4050606@caviumnetworks.com>
 <20141006213101.GA23797@brightrain.aerifal.cx> <54330D79.80102@caviumnetworks.com>
 <20141006215813.GB23797@brightrain.aerifal.cx> <543327E7.4020608@amacapital.net>
 <54332A64.5020605@caviumnetworks.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 6 Oct 2014 16:54:06 -0700
Message-ID: <CALCETrXt4xNCW9+UbEzhST5Eo6s9ymNOc16C+EGi2Pr=GrEZuA@mail.gmail.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
To: David Daney <ddaney@caviumnetworks.com>
Cc: Rich Felker <dalias@libc.org>, David Daney <ddaney.cavm@gmail.com>,
        libc-alpha <libc-alpha@sourceware.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        David Daney <david.daney@cavium.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 6, 2014 at 4:48 PM, David Daney <ddaney@caviumnetworks.com> wrote:
> On 10/06/2014 04:38 PM, Andy Lutomirski wrote:
>>
>> On 10/06/2014 02:58 PM, Rich Felker wrote:
>>>
>>> On Mon, Oct 06, 2014 at 02:45:29PM -0700, David Daney wrote:
>
> [...]
>>>
>>> This is a huge ill-designed mess.
>>
>>
>> Amen.
>>
>> Can the kernel not just emulate the instructions directly?
>
>
> In theory it could, but since there can be implementation defined
> instructions, there is no way to achieve full instruction set coverage for
> all possible machines.

Can modern user code just avoid constructs that require this kind of
trampoline hack?  If so, can this be solved the same way that x86
added no-exec stacks?  (I.e. mark all the binaries as supporting
non-executable stacks and letting them crash if they screw it up.)

Knowing very little about MIPS, it sounds like this is the kernel
compensating for a dumb assembler.

--Andy
