Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbaEHGqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 02:46:17 -0400
Received: from mout.gmx.net ([212.227.17.22]:63225 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbaEHGqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 02:46:16 -0400
From: Sven Joachim <svenjoac@gmx.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexandre Julliard <julliard@winehq.org>,
        Brian Gerst <brgerst@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
	<CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>
	<CA+55aFwzvSiAGYfFb2R3JeVvh8_PQuOKJDrYP5C_3VQz2zhnBw@mail.gmail.com>
	<CAMzpN2jj3dwQG7qC__8zLPhkg_ER6n4CcNxa5eg7okRN+k_VUA@mail.gmail.com>
	<CA+55aFxr_dz3vhko1FPXhZd0ZNeGveX0oSLqUo_wyiVbxatLQw@mail.gmail.com>
	<87k3aspd1h.fsf@wine.dyndns.org> <87zjiuymiu.fsf@turtle.gmx.de>
	<CA+55aFw9BPoD10U1LfHbOMpHWZkvJTkMcfCs9s3urPr1YyWBxw@mail.gmail.com>
	<536A68B1.6070500@zytor.com>
Date: Thu, 08 May 2014 08:43:59 +0200
In-Reply-To: <536A68B1.6070500@zytor.com> (H. Peter Anvin's message of "Wed,
	07 May 2014 10:09:05 -0700")
Message-ID: <87vbtgahxs.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K0:F67J40n2PpeDE8HxzXsS3/JlJGd1da5BxK+edi4lgvGq4q9T2EX
 ch9OHnzmOwINOvsajJwfKWirNTLRGke+B7sEJXFpHHlq7zyw1OenWV/Qigr/OEKyxM+eD6g
 CzOk35fIJYVH8hyTlJ/He2Tw0xFgCN3N/jpLpNI2T7qFcbSygRdZ1zhPPhIU2egTrEToOA6
 930Cxt0wL33jN2asDh4/w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-07 19:09 +0200, H. Peter Anvin wrote:

> On 05/07/2014 09:57 AM, Linus Torvalds wrote:
>> 
>> Afaik, 16-bit programs under wine already need
>> 
>>   echo 0 > /proc/sys/vm/mmap_min_addr
>> 
>> because they want to map things at address 0, so this isn't a new concept.
>> 
>
> I think that applies to DOSEMU, but not to Wine.

DOSEMU does no longer need it either.  If vm.mmap_min_addr is > 0, it
turns on CPU emulation, which it has to use anyway due to lack of vm86
mode.

> Sven: if you have the ability to build your own kernel, could you also
> try the "x86/espfix" branch of the git tree:
>
> https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/
>
> (clone URLs:)
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
> https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
>
> ... to make sure the proper solution works for you?

Works fine here, thanks.

> I'm somewhat curious if this program you have is actually a 32-bit
> program or if it is really a 16-bit program wrapped in a 32-bit
> installer of some kind.  Hard to know without seeing the program in
> question.

The main application (a chess database program) is 32-bit, but it comes
with several 16-bit analysis engines that are loaded on startup (I see
them in lsof output), so that's the situation described by Alexandre.

Cheers,
       Sven
