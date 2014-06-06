Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaFFVhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 17:37:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38253 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbaFFVht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 17:37:49 -0400
Message-ID: <53923490.2060407@zytor.com>
Date: Fri, 06 Jun 2014 14:37:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sasha.levin@oracle.com>,
        Stefani Seibold <stefani@seibold.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [GIT PULL] x86/vdso changes for v3.16
References: <201406042235.s54MZgwP020553@terminus.zytor.com> <20140606140017.afb7f91142f66cb3dd13c186@linux-foundation.org> <CA+55aFyKTbBUM4DJukmW5fiH213D0FbVmrreR9wOtMRmmijQ9Q@mail.gmail.com> <CALCETrWA92Q4ro9eaRkUrebjgQT7B2uj+bK81m9byZnDY_eMxA@mail.gmail.com> <CA+55aFx8ezbe-mCYWp6kM8Nh3oUQd_+SNz6mLoGQtMVDk3EALA@mail.gmail.com> <53922F74.20406@linux.intel.com> <CALCETrXpCMdyPjM6MSbxoi0matoYLfduuSiwmTjGCUU62KOsTw@mail.gmail.com> <539231B8.8000400@zytor.com> <CALCETrXUDiN2RspG3hK4ovDU9WSfo8hnvQjx7cx=Au7A7N1v_w@mail.gmail.com>
In-Reply-To: <CALCETrXUDiN2RspG3hK4ovDU9WSfo8hnvQjx7cx=Au7A7N1v_w@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 02:33 PM, Andy Lutomirski wrote:
> On Fri, Jun 6, 2014 at 2:25 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 06/06/2014 02:22 PM, Andy Lutomirski wrote:
>>>
>>> Sounds good.
>>>
>>> In the mean time, a trivial fix is here:
>>>
>>> https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=vdso/cleanup_fixes&id=cf780a0dc71f7cbd9a417e6ce2d5ddf56abccb74
>>>
>>> (or it will be once the mirrors sync)
>>>
>>
>> Unfortunately gcc didn't introduce __BYTE_ORDER__ at the compiler level
>> until 2010.  This makes it harder to do this in a portable manner.
> 
> Is there anything wrong with using __get_unaligned_leNN directly?
> 

Minus the double underscore (these files need to be cleaned up), not
really, and that is what my patch does.

For accessing memory members doing it via a pointer is pretty much TRT,
but for things that might be in register it is undesirable to force it
out to memory.

	-hpa



