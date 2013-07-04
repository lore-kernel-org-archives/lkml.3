Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab3GDD2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 23:28:22 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:39642 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247Ab3GDD2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 23:28:20 -0400
Message-ID: <51D4EB7D.2020809@gmail.com>
Date: Thu, 04 Jul 2013 11:26:53 +0800
From: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Chen Gang <gang.chen@asianux.com>, Greg KH <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Weinberger <richard@nod.at>, Jeff Dike <jdike@addtoit.com>,
        David Sharp <dhsharp@google.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Ingo Molnar <mingo@kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        uml-user <user-mode-linux-user@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <trivial@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] include/asm-generic/io.h: add dummy fuctions to support
 'COMPILE_TEST' in 'asm-generic'.
References: <51CA8AB8.7080504@asianux.com>    <CAMuHMdW58CZ0m-10ibs2Vyh8exqP1nSH+-ZOr5J58tx=uorM+Q@mail.gmail.com>    <51D375AA.5060300@asianux.com> <201307031014.12583.arnd@arndb.de>    <51D3E440.7090105@asianux.com> <51D4C87E.5070605@asianux.com>    <20130704011221.GA11230@kroah.com> <51D4D4A0.6080401@asianux.com>   <1372903390.22688.139.camel@gandalf.local.home>   <51D4D9A4.3020402@gmail.com>  <1372904975.22688.142.camel@gandalf.local.home>  <51D4E133.2010201@gmail.com> <1372907201.22688.147.camel@gandalf.local.home>
In-Reply-To: <1372907201.22688.147.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2013 11:06 AM, Steven Rostedt wrote:
> On Thu, 2013-07-04 at 10:42 +0800, Chen Gang F T wrote:
> 
>> > Hmm..., I think maybe also has another way: get rid of 'COMPILE_TEST'
>> > (regress the related patch, which is only existent in next-* tree).
> I'm not working on linux-next at the moment. Hmm, I'm not even working
> on mainline at the moment, the kernel I have is still 3.10-rc5.
> 

OK, thanks. I can understand.

Every contributors have their own focus areas, each area is valuable enough to go deeper and deeper.

>> > 
>> > Or could you provide your suggestions or completions about it ?
>> > 
>> > Thanks.
>> > 
>>> > > I'm still confused by what you are trying to accomplish.
>> > 
>> > Currently, I am trying to compile all architectures with allmodconfig in
>> > next-* tree (which will have "COMPILE_TEST=y").
>> > 
>> > So I can find and solve the related issues (I am one of contributors).
>> > 
> So, you want all archs to pass an allmodconfig?
> 

Yeah, that is my current goal.

By this way, I can find more issues and try to solve them (it will be
good for public kernel), and also I can familiar the compiler step by
step (the cross-compilers also has their issues).

(In fact, I also want randconfig, and has already done for some
architectures). ;-)


> Well, one thing is, if a module doesn't build for an arch, then why not
> keep that module from building for that arch.
> 

Please see the related comment in "init/Kconfig" of next-* tree.

config COMPILE_TEST
       bool "Compile also drivers which will not load"
       default n
       help
         Some drivers can be compiled on a different platform than they are
         intended to be run on. Despite they cannot be loaded there (or even
         when they load they cannot be used due to missing HW support),
         developers still, opposing to distributors, might want to build such
         drivers to compile-test them.

         If you are a developer and want to build everything available, say Y
         here. If you are a user/distributor, say N here to exclude useless
         drivers to be distributed.


> If module foo.ko doesn't build for arch bazinga, then just add in the
> Kconfig for the module foo:
> 
> config FOO
>   depends on !BAZINGA
> 
> Then that module wont build for the specific arch, and all are happy. If
> someone someday wants to support module foo for arch bazinga, then they
> can fix module foo for that arch.

If get rid of 'COMPILE_TEST', what you said above are reasonable.

When one module select "COMPILE_TEST=y", if it can not pass compiling
because of HW not support, it is not the module's issue, at least.

Hmm..., but at least for me, I still think, "COMPILE_TEST=y" is really
useful.


Thanks.
-- 
Chen Gang
