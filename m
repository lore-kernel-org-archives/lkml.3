Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbaA1Rw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:52:26 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753894AbaA1RwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:52:25 -0500
Message-ID: <52E7EE54.8030408@nod.at>
Date: Tue, 28 Jan 2014 18:52:20 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, Cong Ding <dinggnu@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
References: <CAFLxGvxJ0A6hZ52RWffkg_zXXScyPn10P4HcKvdAXfE43h32Eg@mail.gmail.com>	<CAGXu5jLcy9R_N_FQHMFheVTYSB9uobd-Orh7spEmpMaMXDtwEQ@mail.gmail.com>	<52E6954F.2060303@nod.at>	<CAGXu5jKXqUhTdhX_n8xSe+d3sPmZ0SK-aTQh2jCXWL6TgA5o=w@mail.gmail.com>	<20140128062806.GA20750@gmail.com>	<52E76997.40303@nod.at>	<52E7D2E5.8090208@linux.intel.com>	<52E7D9FF.1080506@nod.at>	<52E7DB15.3090808@zytor.com>	<CA+55aFzRJNEt-tOGgj-6OPB0cMW9ReM6y6kzCyR5bfts1de-Jg@mail.gmail.com>	<20140128170507.GA16279@gmail.com>	<CA+55aFw_xs1tUteDrXz21QZB7BFk5p+F5NZ-SpV=CUVjeFwapA@mail.gmail.com>	<52E7E7D8.2050605@nod.at> <CA+55aFyYoi_KW5h=RxvjXHe89ZgCifAiS=5DqRnvS=K=Rbitsg@mail.gmail.com>
In-Reply-To: <CA+55aFyYoi_KW5h=RxvjXHe89ZgCifAiS=5DqRnvS=K=Rbitsg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 28.01.2014 18:35, schrieb Linus Torvalds:
> On Tue, Jan 28, 2014 at 9:24 AM, Richard Weinberger <richard@nod.at> wrote:
>>
>> Hmm, my gdb does not like that notion.
>>
>> (gdb) list schedule+0x45
>> Function "schedule+0x45" not defined.
> 
> I don't have a debug build, so maybe it's something specific to gdb
> actually seeing type information and then being confused..
> 
> Can you do "x/10i schedule+0x45" because that definitely works for me.
> But I literally detest DBUG_INFO builds, because it's useless crap.
> 99% of everything I debug is from people reporting problems on their
> kernels, so it's not like my local debug info would match that anyway.

x/10i schedule+0x45 works.

> Anyway, if it's a type information thing due to DEBUG_INFO that
> confuses gdb and makes it think that the "+0x45" part doesn't make
> sense, you may need to add a cast to get gdb to ignore the type
> information. IOW, does
> 
>   list (void *)schedule + 0x45
> 
> work for you?

Nope.

(gdb) list (void *)schedule + 0x45
Function "(void *)schedule + 0x45" not defined.

> I happen to have gdb-7.6.50 here that I tested with, but I've used
> "symbol+offset" forever afaik, so it's definitely not something new.

I'm on 7.5.1.

Thanks,
//richard
