Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaFFVj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 17:39:57 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:53811 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbaFFVj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 17:39:56 -0400
MIME-Version: 1.0
In-Reply-To: <53923490.2060407@zytor.com>
References: <201406042235.s54MZgwP020553@terminus.zytor.com>
 <20140606140017.afb7f91142f66cb3dd13c186@linux-foundation.org>
 <CA+55aFyKTbBUM4DJukmW5fiH213D0FbVmrreR9wOtMRmmijQ9Q@mail.gmail.com>
 <CALCETrWA92Q4ro9eaRkUrebjgQT7B2uj+bK81m9byZnDY_eMxA@mail.gmail.com>
 <CA+55aFx8ezbe-mCYWp6kM8Nh3oUQd_+SNz6mLoGQtMVDk3EALA@mail.gmail.com>
 <53922F74.20406@linux.intel.com> <CALCETrXpCMdyPjM6MSbxoi0matoYLfduuSiwmTjGCUU62KOsTw@mail.gmail.com>
 <539231B8.8000400@zytor.com> <CALCETrXUDiN2RspG3hK4ovDU9WSfo8hnvQjx7cx=Au7A7N1v_w@mail.gmail.com>
 <53923490.2060407@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 6 Jun 2014 14:39:35 -0700
Message-ID: <CALCETrV4LPNwQFYghygqUjPQd2vSYew=wghgveX7turZzYBMFQ@mail.gmail.com>
Subject: Re: [GIT PULL] x86/vdso changes for v3.16
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sasha.levin@oracle.com>,
        Stefani Seibold <stefani@seibold.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pavel Emelyanov <xemul@parallels.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2014 at 2:37 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/06/2014 02:33 PM, Andy Lutomirski wrote:
>> On Fri, Jun 6, 2014 at 2:25 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> On 06/06/2014 02:22 PM, Andy Lutomirski wrote:
>>>>
>>>> Sounds good.
>>>>
>>>> In the mean time, a trivial fix is here:
>>>>
>>>> https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=vdso/cleanup_fixes&id=cf780a0dc71f7cbd9a417e6ce2d5ddf56abccb74
>>>>
>>>> (or it will be once the mirrors sync)
>>>>
>>>
>>> Unfortunately gcc didn't introduce __BYTE_ORDER__ at the compiler level
>>> until 2010.  This makes it harder to do this in a portable manner.
>>
>> Is there anything wrong with using __get_unaligned_leNN directly?
>>
>
> Minus the double underscore (these files need to be cleaned up), not
> really, and that is what my patch does.
>
> For accessing memory members doing it via a pointer is pretty much TRT,
> but for things that might be in register it is undesirable to force it
> out to memory.

Do you also believe in the folklore that GCC can optimize code
sequences like the things in that header?  Because I'm pretty sure
that no clang or gcc version I've ever seen can do it.

On the other hand, even a factor of ten in the time it takes to run
vdso2c is completely irrelevant.

--Andy
