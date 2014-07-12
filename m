Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbaGLCJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 22:09:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42346 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbaGLCJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 22:09:25 -0400
Message-ID: <53C098BF.6010203@zytor.com>
Date: Fri, 11 Jul 2014 19:09:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] x86_64,signal: Remove 'fs' and 'gs' from sigcontext
References: <cover.1405095200.git.luto@amacapital.net> <a13ebdd57378120348f40cbe12d9b1705d189434.1405095200.git.luto@amacapital.net> <20140711181212.GT18735@two.firstfloor.org> <CALCETrWMgTET6MZwaH4D4tOg2v1kV6ozBnjGTGrecnMWJbkUEg@mail.gmail.com>
In-Reply-To: <CALCETrWMgTET6MZwaH4D4tOg2v1kV6ozBnjGTGrecnMWJbkUEg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 11:39 AM, Andy Lutomirski wrote:
> On Fri, Jul 11, 2014 at 11:12 AM, Andi Kleen <andi@firstfloor.org> wrote:
>>> diff --git a/arch/x86/include/uapi/asm/sigcontext.h b/arch/x86/include/uapi/asm/sigcontext.h
>>> index 076b11f..df9908b 100644
>>> --- a/arch/x86/include/uapi/asm/sigcontext.h
>>> +++ b/arch/x86/include/uapi/asm/sigcontext.h
>>
>> I don't think renaming fields in uapi/asm is acceptable. These
>> are likely used by user programs and you'll break compiles.
> 
> Hmm.  That's a fair point.  On the other hand, any user code that uses
> these fields explicitly may already be broken, since the current names
> of these fields rather strongly imply that they do something.
> 
> Is there any clear policy on minor API breaks in the UAPI headers that
> don't affect ABI?
> 

There really isn't, and this *definitely* a boundary case: as you state,
it is very likely that anyone currently using them are doing so
incorrectly, but it does induce potential source-level breakage.

Linus, do you have any guidance here?

	-hpa

