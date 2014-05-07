Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335AbaEGJTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 05:19:15 -0400
Received: from mout.gmx.net ([212.227.17.21]:56521 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbaEGJTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 05:19:12 -0400
From: Sven Joachim <svenjoac@gmx.de>
To: Alexandre Julliard <julliard@winehq.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Brian Gerst <brgerst@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
	<CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>
	<CA+55aFwzvSiAGYfFb2R3JeVvh8_PQuOKJDrYP5C_3VQz2zhnBw@mail.gmail.com>
	<CAMzpN2jj3dwQG7qC__8zLPhkg_ER6n4CcNxa5eg7okRN+k_VUA@mail.gmail.com>
	<CA+55aFxr_dz3vhko1FPXhZd0ZNeGveX0oSLqUo_wyiVbxatLQw@mail.gmail.com>
	<87k3aspd1h.fsf@wine.dyndns.org>
Date: Wed, 07 May 2014 11:18:49 +0200
In-Reply-To: <87k3aspd1h.fsf@wine.dyndns.org> (Alexandre Julliard's message of
	"Mon, 14 Apr 2014 09:48:10 +0200")
Message-ID: <87zjiuymiu.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K0:QsFGenef/ULkhGxiYzWAx47lNYhcg5RCwgw/eq/c+1hyD4nqv5b
 /gjwLV4UutxhgOyxD9/lfIUnK9nxsiJGF1kuBpH8Mm1qAkmn+xWG9W8I1qDdQw46OwwnIWe
 r/51V4zZIjrqFLqJYTslOBx0szBmLjnZmL5FXQmCdfCJ2uWSGYHEsOjMi4LBNJl515p8LFF
 DJrYZFqgN3qEfQgOfiY/w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-14 09:48 +0200, Alexandre Julliard wrote:

> Linus Torvalds <torvalds@linux-foundation.org> writes:
>
>> On Fri, Apr 11, 2014 at 11:45 AM, Brian Gerst <brgerst@gmail.com> wrote:
>>>
>>> I haven't tested it recently but I do know it has worked on 64-bit
>>> kernels.  There is no reason for it not to, the only thing not
>>> supported in long mode is vm86.  16-bit protected mode is unchanged.
>>
>> Afaik 64-bit windows doesn't support 16-bit binaries, so I just
>> assumed Wine wouldn't do it either on x86-64. Not for any real
>> technical reasons, though.
>>
>> HOWEVER. I'd like to hear something more definitive than "I haven't
>> tested recently". The "we don't break user space" is about having
>> actual real *users*, not about test programs.
>>
>> Are there people actually using 16-bit old windows programs under
>> wine? That's what matters.

It seems that at least some 32-bit programs are also broken, since after
upgrading the kernel to 3.14.3 I can no longer start my old chess
database program:

,----
| % file CB70.exe 
| CB70.exe: PE32 executable (GUI) Intel 80386, for MS Windows
| % LANG=C wine CB70.exe
| modify_ldt: Invalid argument
| modify_ldt: Invalid argument
| modify_ldt: Invalid argument
| modify_ldt: Invalid argument
| modify_ldt: Invalid argument
`----

And here it just hangs, with wineboot.exe taking 100% CPU.  I had to
kill first wineboot.exe and then CB70.exe. :-(

> Yes, there is still a significant number of users, and we still
> regularly get bug reports about specific 16-bit apps. It would be really
> nice if we could continue to support them on x86-64, particularly since
> Microsoft doesn't ;-)

I would rather not set up a virtual machine just for wine (I don't have
Windows anymore).

Cheers,
       Sven
