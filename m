Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbaLJMNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 07:13:30 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815AbaLJMN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 07:13:28 -0500
Message-ID: <548838E5.8060701@nod.at>
Date: Wed, 10 Dec 2014 13:13:25 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Miklos Szeredi <miklos@szeredi.hu>, Ley Foon Tan <lftan@altera.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Walter <sahne@0x90.at>,
        user-mode-linux-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [BUG] uml panics with "Segfault with no mm" in v3.19-rc
References: <20141210104624.GB32280@tucsk.suse.de>	<54882533.6080901@nod.at> <CAMuHMdUzc2=EodO5vxKVWdaDQeWXUM8w90ssQ4HvPyR6N-g8fA@mail.gmail.com>
In-Reply-To: <CAMuHMdUzc2=EodO5vxKVWdaDQeWXUM8w90ssQ4HvPyR6N-g8fA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 10.12.2014 um 12:59 schrieb Geert Uytterhoeven:
> On Wed, Dec 10, 2014 at 11:49 AM, Richard Weinberger <richard@nod.at> wrote:
>> Am 10.12.2014 um 11:46 schrieb Miklos Szeredi:
>>> The guilty commit is:
>>>
>>>   00f634bc522d "asm-generic: add generic futex for !CONFIG_SMP"
>>
>> Thanks a lot Miklos!
>> Your bisecting faster than I do.
>>
>> Let's dig into the issue!
> 
> Do you need "select HAVE_FUTEX_CMPXCHG if FUTEX"?

> Cfr. commit e571c58f313d35c5 ("m68k: Skip futex_atomic_cmpxchg_inatomic()
> test") and commit 03b8c7b623c80af2 ("futex: Allow architectures to skip
> futex_atomic_cmpxchg_inatomic() test").

Bingo!

If UML selects HAVE_FUTEX_CMPXCHG the code path I've described in my previous mail
is no longer taken and makes it work again.
I did only a small test but nothing exploded so far.

> BTW, I still think the real problem is the wrong address space, cfr.
> "[PATCH/RFC] futex: Switch to USER_DS for futex test"
> (http://www.spinics.net/lists/linux-m68k/msg06597.html), so you may also
> want to try that.
> However, that caused problems on s390, as it ran too early:
> http://permalink.gmane.org/gmane.linux.kernel.next/30165

Yeah, this would also make sense for UML.

Thanks,
//richard
