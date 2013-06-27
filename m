Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab3F0I4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 04:56:05 -0400
Received: from intranet.asianux.com ([58.214.24.6]:47838 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab3F0I4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 04:56:02 -0400
X-Spam-Score: -100.9
Message-ID: <51CBFDED.9090203@asianux.com>
Date: Thu, 27 Jun 2013 16:55:09 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Arnd Bergmann <arnd@arndb.de>, Hirokazu Takata <takata@linux-m32r.org>,
        linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch: m32r: include: asm: add ioread*_rep() and iowrite*_rep()
References: <51CBA43F.9050000@asianux.com> <51CBAA1E.8000206@asianux.com> <51CBB1A9.5080203@asianux.com> <51CBC186.3080401@asianux.com> <CAMuHMdVCv=MOJ8C4U=QHntQKZ=rThoKvXorgcR6jFRCA8hLULQ@mail.gmail.com>
In-Reply-To: <CAMuHMdVCv=MOJ8C4U=QHntQKZ=rThoKvXorgcR6jFRCA8hLULQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2013 03:07 PM, Geert Uytterhoeven wrote:
> On Thu, Jun 27, 2013 at 6:37 AM, Chen Gang <gang.chen@asianux.com> wrote:
>> --- a/arch/m32r/include/asm/io.h
>> +++ b/arch/m32r/include/asm/io.h
>> @@ -169,6 +169,20 @@ static inline void _writel(unsigned long l, unsigned long addr)
>>  #define iowrite16 writew
>>  #define iowrite32 writel
>>
>> +#define ioread8_rep(p, dst, count) \
>> +       insb((unsigned long) (p), (dst), (count))
> 
> As ioread8() is mapped to readb() (I/O memory space), not inb() (I/O
> port space),
> ioread8_rep() should map to readsb() (which m32r doesn't have yet
> BTW), not insb().
> For m32r this does matter, as inb() and readb() use different mechanisms
> internally.
> 

Reasonable, but excuse me, I am not quite familiar with it, can any
other members (or maintainer) to help implement it ?

Thanks firstly.

:-)

> It seems include/asm-generic/io.h also has this wrong?
> 

I think it need improvement, if readsb has been defined, it should use
readsb() instead, or just use insb().

Thank you to provide a good chance to send another generic patch.  ;-)


-- 
Chen Gang
