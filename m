Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762462AbaGRUvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 16:51:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43775 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762161AbaGRUvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 16:51:23 -0400
Message-ID: <53C9889F.3040107@zytor.com>
Date: Fri, 18 Jul 2014 13:50:39 -0700
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
References: <20140718150005.73db8eb9@canb.auug.org.au> <53C97287.5020509@zytor.com> <CALCETrXs4fdKDA1C4ts3qzgbB6PrmCZZyK3R4cBLaO9RbBp0YA@mail.gmail.com> <53C97E0F.6090601@zytor.com> <CALCETrXP+Rz8wi_N2G7WLwnGuFMC8zeo5o+jgGmvpZkndrM+2Q@mail.gmail.com> <53C98055.5070301@zytor.com> <CALCETrVWSjqBJyEC4k6qAfa2PcoKq6LWR8HH2WyuMBU+98pJsQ@mail.gmail.com>
In-Reply-To: <CALCETrVWSjqBJyEC4k6qAfa2PcoKq6LWR8HH2WyuMBU+98pJsQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 01:20 PM, Andy Lutomirski wrote:
>>
>> The reason this is a concern is that: (x > x + n) and its variants is
>> often used to mean (x > INT_MAX - n) without the type knowledge, but
>> that is actually invalid standard C because signed types are not
>> guaranteed to wrap.
> 
> Right, but the constant in this case is *much* less than INT_MAX.
> Anyway, this is moot.

It isn't about the constant (n) at all, it is about the value of x.

> I do wonder whether the kind of people who build hardened kernels
> should enable -fwrapv, though.

-fwrapv in gcc makes signed arithmetic strict 2's-complement, which is
what I think we want in the kernel.  Someone would just have to make
sure there isn't some key codepath in the kernel which gets pessimized.

	-hpa


