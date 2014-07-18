Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945944AbaGRUP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 16:15:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43440 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757110AbaGRUP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 16:15:56 -0400
Message-ID: <53C98055.5070301@zytor.com>
Date: Fri, 18 Jul 2014 13:15:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: build warning after merge of the tip tree
References: <20140718150005.73db8eb9@canb.auug.org.au> <53C97287.5020509@zytor.com> <CALCETrXs4fdKDA1C4ts3qzgbB6PrmCZZyK3R4cBLaO9RbBp0YA@mail.gmail.com> <53C97E0F.6090601@zytor.com> <CALCETrXP+Rz8wi_N2G7WLwnGuFMC8zeo5o+jgGmvpZkndrM+2Q@mail.gmail.com>
In-Reply-To: <CALCETrXP+Rz8wi_N2G7WLwnGuFMC8zeo5o+jgGmvpZkndrM+2Q@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 01:08 PM, Andy Lutomirski wrote:
> 
> i isn't an index in to the syms array at all.  This code is completely
> wrong.  See the patch I sent in reply to Stephen's original email.
> 
> But, to your earlier point, presumably this could warn:
> 
> for (int i = 0; i < 10; i++)
>   if (array[i] > array[5] + 1)
>     fail();
> 
> I think that's absurd.  There's nothing wrong with that code.  A given
> test should have to be always true or always false on *all* loop
> iterations to be flagged, I think.
> 

No, the issue is that gcc is telling you that the code will do the wrong
thing in this case.  Yes, only for one iteration, but still.

The reason this is a concern is that: (x > x + n) and its variants is
often used to mean (x > INT_MAX - n) without the type knowledge, but
that is actually invalid standard C because signed types are not
guaranteed to wrap.

	-hpa

