Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbaDGSQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 14:16:39 -0400
Received: from mout.gmx.net ([212.227.17.22]:50055 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755819AbaDGSQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 14:16:37 -0400
Message-ID: <5342EB78.3060002@gmx.de>
Date: Mon, 07 Apr 2014 20:16:24 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Michele Ballabio <barra_cuda@katamail.com>
CC: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Bisected KVM hang on x86-32 between v3.12 and v3.13
References: <5341707F.5000406@katamail.com> <20140407150337.GO10526@twins.programming.kicks-ass.net> <20140407150705.GB13658@twins.programming.kicks-ass.net>
In-Reply-To: <20140407150705.GB13658@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:MdJM47cNkzRGe5YkCLKyvyQeIRbipMnyBWtMPwYmIJWCnjoqaHo
 3NtinS7DdGYQJlrxm48TfAR9LBLhKedEzbc2IctL8Av6zUw5FsJf4IOUzeA4+NaDifhlWP4
 mR2J7TCL4xZjk1tWhENQwCzHz6euF7dYScom1wnBSwnpskP6wGQ9MCVw3jTwzoVmXEal8IA
 Nza8w2Mf4sNSQYxTbx1Hg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 04/07/2014 05:07 PM, Peter Zijlstra wrote:
> On Mon, Apr 07, 2014 at 05:03:37PM +0200, Peter Zijlstra wrote:
>> So what I suspect at this point is that because i386 and x86_64
>> have a difference in current_thread_info() (i386 is stack based),
>> we end up setting the TIF_NEED_RESCHED bit on the wrong stack.
>> 
>> Now I have some vague memories of propagating the TIF flags on
>> stack switch, but I cannot remember what arch we did that for.
>> Let me stare at this a little more.
>> 
>> Also, IFF this is the case, then the fingered patch above (and
>> your suggested 'fix') aren't the real curlpit/cure but simply
>> make it more/less likely to happen.
>> 
>> Now, Steve had a patch somewhere that would make i386 use
>> per-cpu variables for current_thread_info() just like x86_64
>> already does I think. Let me go find them too.
> 
> Ohh, goodie, they're already in Linus' tree. Could you see if
> current git still suffers this problem?
> 
v3.14-10353-g2b3a8fd works fine AFAICS
(BTW the fix is stable material, right ?)

- -- 
MfG/Sincerely
Toralf Förster
pgp finger print:1A37 6F99 4A9D 026F 13E2 4DCF C4EA CDDE 0076 E94E
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlNC63gACgkQxOrN3gB26U6MoQD/QlC0K92TivMFR6H35G9m1QzK
dkdGzHDVn5HtgIswDToA/RhmhblKnqM7bWYzOxwypF7oZGdKRnBQocWbbuMi5lf0
=tw9y
-----END PGP SIGNATURE-----
