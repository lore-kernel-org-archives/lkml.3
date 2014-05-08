Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaEHNvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 09:51:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35209 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbaEHNvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 09:51:06 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <87vbtgahxs.fsf@turtle.gmx.de>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com> <CA+55aFwzvSiAGYfFb2R3JeVvh8_PQuOKJDrYP5C_3VQz2zhnBw@mail.gmail.com> <CAMzpN2jj3dwQG7qC__8zLPhkg_ER6n4CcNxa5eg7okRN+k_VUA@mail.gmail.com> <CA+55aFxr_dz3vhko1FPXhZd0ZNeGveX0oSLqUo_wyiVbxatLQw@mail.gmail.com> <87k3aspd1h.fsf@wine.dyndns.org> <87zjiuymiu.fsf@turtle.gmx.de> <CA+55aFw9BPoD10U1LfHbOMpHWZkvJTkMcfCs9s3urPr1YyWBxw@mail.gmail.com> <536A68B1.6070500@zytor.com> <87vbtgahxs.fsf@turtle.gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 08 May 2014 06:50:18 -0700
To: Sven Joachim <svenjoac@gmx.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexandre Julliard <julliard@winehq.org>,
        Brian Gerst <brgerst@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <4b728523-2e82-42f1-997c-792ce8e3219f@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually it could use KVM instead of CPU emulation on nearly all modern processors...

On May 7, 2014 11:43:59 PM PDT, Sven Joachim <svenjoac@gmx.de> wrote:
>On 2014-05-07 19:09 +0200, H. Peter Anvin wrote:
>
>> On 05/07/2014 09:57 AM, Linus Torvalds wrote:
>>> 
>>> Afaik, 16-bit programs under wine already need
>>> 
>>>   echo 0 > /proc/sys/vm/mmap_min_addr
>>> 
>>> because they want to map things at address 0, so this isn't a new
>concept.
>>> 
>>
>> I think that applies to DOSEMU, but not to Wine.
>
>DOSEMU does no longer need it either.  If vm.mmap_min_addr is > 0, it
>turns on CPU emulation, which it has to use anyway due to lack of vm86
>mode.
>
>> Sven: if you have the ability to build your own kernel, could you
>also
>> try the "x86/espfix" branch of the git tree:
>>
>> https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/
>>
>> (clone URLs:)
>> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
>> https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
>>
>> ... to make sure the proper solution works for you?
>
>Works fine here, thanks.
>
>> I'm somewhat curious if this program you have is actually a 32-bit
>> program or if it is really a 16-bit program wrapped in a 32-bit
>> installer of some kind.  Hard to know without seeing the program in
>> question.
>
>The main application (a chess database program) is 32-bit, but it comes
>with several 16-bit analysis engines that are loaded on startup (I see
>them in lsof output), so that's the situation described by Alexandre.
>
>Cheers,
>       Sven

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
