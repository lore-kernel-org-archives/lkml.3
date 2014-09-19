Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbaISQNb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 12:13:31 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:58702 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756915AbaISQNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 12:13:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140919150042.GC5318@nazgul.tnic>
References: <20140918135202.GA26038@khazad-dum.debian.net> <541B2F33.8000002@amacapital.net>
 <20140918145328.0253f009@as> <9c84cde6-3d70-4337-8738-0283d06d8cf0@email.android.com>
 <20140918200659.GA5331@khazad-dum.debian.net> <20140919001311.GB5331@khazad-dum.debian.net>
 <CALCETrVoeqQUXH7g+reu=hUvCJoiy+edHKBqYKPWXPCS3_UtUw@mail.gmail.com>
 <20140919110014.GC29639@khazad-dum.debian.net> <20140919112953.GA3256@nazgul.tnic>
 <20140919075415.5149d5f2@as> <20140919150042.GC5318@nazgul.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 19 Sep 2014 09:13:08 -0700
Message-ID: <CALCETrUaYzBq68gGK7ixdb348jc_c=aKj6rA1=9t=3V3mm=fFw@mail.gmail.com>
Subject: Re: x86, microcode: BUG: microcode update that changes x86_capability
To: Borislav Petkov <bp@alien8.de>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 8:00 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Fri, Sep 19, 2014 at 07:54:14AM -0500, Chuck Ebbert wrote:
>> Assuming we can identify all the affected models and steppings, maybe
>> something like this would work:
>>
>> 1) Refuse to finish booting if a microcode update that disables TSX
>> isn't applied before userspace starts running on those CPUs.
>
> Well, I think when we're booting, we would have already applied the
> early microcode, no? Because then it is a non-issue.
>
>> 2) Don't allow a late update if TSX is still enabled on those
>> processors.
>
> Yeah, so the use case I have in mind is when a long-running machine
> wants to apply microcode and this microcode disables CPUID bits and
> instructions. And the machine cannot be rebooted.
>
> I guess in that case we would have to issue a warning only on the
> affected processors that a rebooted is mandatory and fail the update...
> Maybe something like that.
>
>> (1) could be overridden by a command line option for people who want
>> to develop TSX code.
>
> The way I understand it, those people shouldn't apply the microcode
> patch at all.
>

One way or another, anyone who has a kernel without some kind of
workaround, an old BIOS, and a new ucode file in /lib/firmware is
going to have problems unless they're set up for early ucode updates.

Can we change the ucode blob format for these firmwares so that old
kernels won't apply them?  I have no other good ideas.  The trouble is
that distros *should* push out the new ucode, but only if there's some
guarantee that they'll only be applied early, never late.

--Andy
