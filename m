Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbaDGT5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 15:57:07 -0400
Received: from mout.gmx.net ([212.227.17.21]:56623 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162AbaDGT5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 15:57:05 -0400
Message-ID: <5343030C.3040004@gmx.de>
Date: Mon, 07 Apr 2014 21:57:00 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Michele Ballabio <barra_cuda@katamail.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Bisected KVM hang on x86-32 between v3.12 and v3.13
References: <5341707F.5000406@katamail.com> <20140407150337.GO10526@twins.programming.kicks-ass.net> <20140407150705.GB13658@twins.programming.kicks-ass.net> <5342EB78.3060002@gmx.de> <20140407185949.GC4106@localhost.localdomain>
In-Reply-To: <20140407185949.GC4106@localhost.localdomain>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:znOQWvHic+VTDX6rOuygL48d3zxK4onTzknkcmC/cZIvjLyVlOA
 DWaImo83dNPrQQUZU62Jllkoxll1rlIigQ95ztBFQJqZww3LdDzYvzStKMU+ZnwN3UZej3X
 S22U7URpztpdF8vqq8Nj9+UdmXTAU69eDBFU2xbXCT23JgYSFLA/6+rQrVW5fYwvhE9UxEB
 TpWgZS7m2QrzMQRGLYAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 04/07/2014 08:59 PM, Frederic Weisbecker wrote:
> On Mon, Apr 07, 2014 at 08:16:24PM +0200, Toralf Förster wrote:
>> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA256
>> 
>> On 04/07/2014 05:07 PM, Peter Zijlstra wrote:
>>> On Mon, Apr 07, 2014 at 05:03:37PM +0200, Peter Zijlstra
>>> wrote:
>>>> So what I suspect at this point is that because i386 and
>>>> x86_64 have a difference in current_thread_info() (i386 is
>>>> stack based), we end up setting the TIF_NEED_RESCHED bit on
>>>> the wrong stack.
>>>> 
>>>> Now I have some vague memories of propagating the TIF flags
>>>> on stack switch, but I cannot remember what arch we did that
>>>> for. Let me stare at this a little more.
>>>> 
>>>> Also, IFF this is the case, then the fingered patch above
>>>> (and your suggested 'fix') aren't the real curlpit/cure but
>>>> simply make it more/less likely to happen.
>>>> 
>>>> Now, Steve had a patch somewhere that would make i386 use 
>>>> per-cpu variables for current_thread_info() just like x86_64 
>>>> already does I think. Let me go find them too.
>>> 
>>> Ohh, goodie, they're already in Linus' tree. Could you see if 
>>> current git still suffers this problem?
>>> 
>> v3.14-10353-g2b3a8fd works fine AFAICS (BTW the fix is stable
>> material, right ?)
> 
> If we are reffering to 198d208df4371734ac4728f69cb585c284d20a15 
> (x86: Keep thread_info on thread stack in x86_32) it doesn't carry
> a stable tag.
> 
> So to be clear, you are saying that v3.14 is fine but other
> release are buggy? Which ones are these?
> 
No, 3.13.x and 3.14 have the issue, latest git is fine and 3.12.x

> If a backport is needed, 198d208df4371734ac4728f69cb585c284d20a15
> looks too large...
> 


- -- 
MfG/Sincerely
Toralf Förster
pgp finger print:1A37 6F99 4A9D 026F 13E2 4DCF C4EA CDDE 0076 E94E
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlNDAwwACgkQxOrN3gB26U5Z7AD+OMcd+262s1fJV9Fg8NjL5TaI
Y4hZHzdv76fU/9P1lrkA/RUbQFYn6r9fZz61UrEIZ5lg5dUX04DDcQkfPUMZRow3
=Ifk8
-----END PGP SIGNATURE-----
