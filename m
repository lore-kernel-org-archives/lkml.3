Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab3GHCMQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 22:12:16 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:56968 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab3GHCMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 22:12:14 -0400
Message-ID: <51DA1FAE.3000306@gmail.com>
Date: Mon, 08 Jul 2013 10:10:54 +0800
From: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Chen Gang <gang.chen@asianux.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Greg KH <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Weinberger <richard@nod.at>, Jeff Dike <jdike@addtoit.com>,
        David Sharp <dhsharp@google.com>, Ingo Molnar <mingo@kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        uml-user <user-mode-linux-user@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <trivial@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] include/asm-generic/io.h: add dummy fuctions to support
 'COMPILE_TEST' in 'asm-generic'.
References: <20130704011221.GA11230@kroah.com> <51D617E9.8080907@gmail.com> <51D67D6C.4080603@gmail.com> <201307051313.43491.arnd@arndb.de>
In-Reply-To: <201307051313.43491.arnd@arndb.de>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Firstly, thank you very much for your reply.

On 07/05/2013 07:13 PM, Arnd Bergmann wrote:
> On Friday 05 July 2013, Chen Gang F T wrote:
>> > Hello All:
>> > 
>> > It seems 'asm-generic' dislikes 'mad users' (e.g allmodconfig,
>> > randconfig, and me).
>> > 
>> > I guess the main reason is: 'asm-generic' thinks what mad users talk
>> > about is useless in real world, so it is just noisy.
>> > 
>> > I can understand, at least what I talk about is not for urgent things.
>> > (maybe 'asm-generic' also thinks it not important either, every members
>> > have their own opinions).
>> > 
>> > Next, I still use allmodconfig/randconfig for some architectures which I
>> > am interested in (and also for learning compilers), but I will skip all
>> > things which are related with 'asm-generic', since it dislikes me (a mad
>> > user).
> As the asm-generic maintainer I think I have to clarify a few things:
> 
> * Build-time fixes for warnings and randconfig errors are good,
>   and you have sent a number of good bug fixes all over the kernel,
>   I definitely welcome getting more of those. In many cases the
>   fix is trivial and obvious, in other cases you need to know
>   much more of the background to understand what the underlying
>   problem is and why you should not just fix the symptom.
> 

Since we (at least my company) has already get benifits from Public Open
Source, we should try to provide the contribution back to Public Open
Source.

Providing contributions to Public Open Source is part of my duty (what
I should do).


> * You have made an (understandable) mistake with this particular
>   patch. It would have been nice if you had not made it, but I
>   can see that you are still learning about these things. There
>   is a fine line between what makes sense to be enabled as a
>   'compile test' and what should better be left disabled by
>   Kconfig.
> 

We have to meet three roles: 'user', 'provider' and 'tester' (which is
may mad user, and not quite familiar with the details).

For 'user', they really need 'COMPILE_TEST', so it should be added into
kernel wide. And 'user' often thinks the 'tester' is just a 'mad user'
for 'tester' offten does "mad things" which will be useless in real
world.

For 'provider', he/she often feels the 'tester' is not familiar the
details (in fact, they really not familiar), but he/she has to discuss
with 'tester' (especially 'user' does not care about it). He/She really
feels it is just boring and waste time.

Instead of discussing the details, 'tester' should only provide the
related proof and only can discus the related API, he/she wants the
'provider' to explain about the proof and make the API clearer to every
one (not only for 'expert').

Now, I think, I may just play a 'tester' role for 'asm-generic'.


> * When experienced developers tell you that you are mistaken, you
>   need to make an effort to understand what the mistake was so you
>   can learn from it and not make the same mistake again. If you
>   make the same mistakes again, maintainers will get annoyed and
>   ignore you (or worse), which is not a good situation to be
>   in when you want to get your patches merged.

'tester' wants the 'provider' to explain the proof:

  e.g. 'COMPILE_TEST' help contents whether really say: "can allow 'COMIPLE_TEST=y' in architectures which no related HW support"
  e.g. If compile fails because of no HW support with "COMPILE_TEST=y", can we still let it suspending ?
  e.g. Does it still count an issue, although in real world, it may not happen, at least now ?

'tester' also wants the 'provider' to explain 'asm-generic':

  Arnd said:
    "It's a set of examples for the architectures to look at and include if they want to"
  Steven saind:
    "The purpose of asm-generic is to add a standard infrastructure that some archs may be able to optimize."

  (In fact, they are not precisely the same).

  Did 'provider' have the related document for it (I guess so, could you provide the related location), thanks ?

  according to the definition of 'asm-generic' (either of them):
    the 'CONFIG_BUG' need really remove from 'asm-generic', for it is only related with some of architectures, not generic enough for all architectures
      (we can continue to discus it in the related thread).
    it belongs architectures wide, not kernel wide, is it better to move "./include/asm-generic" to "./arch/asm-default" or "./arch/asm-standard" ?

'tester' also wants to try something (but maybe incorrect).

  one sample for string, its value has 4 kinds: 'volatile string', 'const string', '""', 'NULL'.  ('""' is not equal to 'NULL').
  may we also have the 4 kinds: 'HAS_IOMAP', 'NOMMU', 'COMPILE_TEST', 'N/A' ('COMPILE_TEST' is not equal to 'N/A')?

  (this is maybe just boring or wast time, need not reply).


Thanks.
-- 
Chen Gang
