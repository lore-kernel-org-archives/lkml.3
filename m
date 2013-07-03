Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab3GCIpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 04:45:05 -0400
Received: from intranet.asianux.com ([58.214.24.6]:33800 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129Ab3GCIoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 04:44:38 -0400
X-Spam-Score: -100.7
Message-ID: <51D3E440.7090105@asianux.com>
Date: Wed, 03 Jul 2013 16:43:44 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Weinberger <richard@nod.at>, Jeff Dike <jdike@addtoit.com>,
        David Sharp <dhsharp@google.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        uml-user <user-mode-linux-user@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] include/asm-generic/io.h: add dummy fuctions to support
 'COMPILE_TEST' in 'asm-generic'.
References: <51CA8AB8.7080504@asianux.com> <CAMuHMdW58CZ0m-10ibs2Vyh8exqP1nSH+-ZOr5J58tx=uorM+Q@mail.gmail.com> <51D375AA.5060300@asianux.com> <201307031014.12583.arnd@arndb.de>
In-Reply-To: <201307031014.12583.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2013 04:14 PM, Arnd Bergmann wrote:
> On Wednesday 03 July 2013, Chen Gang wrote:
>> > On 07/02/2013 06:57 PM, Geert Uytterhoeven wrote:
>>> > > On Tue, Jul 2, 2013 at 10:00 AM, Chen Gang <gang.chen@asianux.com> wrote:
>>>>> > >> > On 07/02/2013 03:19 PM, Geert Uytterhoeven wrote:
>>>>>>> > >>> >> On Tue, Jul 2, 2013 at 4:13 AM, Chen Gang <gang.chen@asianux.com> wrote:
>>> > > I mean that COMPILE_TEST should exist in Kconfig files only.
>>> > > It's only meant to have more compile coverage, not to "fix" (through #ifdef)
>>> > > more code to make it compile.
>> > 
>> > If so, can we allow the module to 'COMPILE_TEST' under one platform
>> > which not support the related HW ?
>> > 
>> >   e.g. "...Despite they cannot be loaded there (or even when they load
>> > they cannot be used due to missing HW support)...".
> There is a reason why ioremap and the associated functions make no
> sense on UML, and it remains important to not provide them here
> so we can find drivers that accidentally use them and are missing
> a dependency on HAS_IOMEM.
>  

Yeah, it is necessary for "asm-generic" to provide the configuration
checking features (e.g. check HAS_IOMEM, HAS_IOMAP, ...).

And it really make no sense on UML.

>> > 'asm-generic' need provide generic layer to users (both architecture
>> > guys and module guys).
> No. It's a set of examples for the architectures to look at and
> include if they want to.
> 

If really just like what you said, I recommend to use "asm-default"
instead of "asm-generic".

And for module guys, they have to use another 'generic' files instead
of current 'asm-generic', they really need some 'generic' things to
prevent the various definitions/implementations spread into anywhere.

>> > So for 'default', it can depend on some conditions (e.g. HW support);
>> > but for 'generic', it need try to be independent from any conditions.
>> > 
>> > And it is also necessary for 'generic' to provide the configuration
>> > checking features, but this checking must be no negative effect (or
>> > consistent) with its 'generic' services.
>> > 
>> > So it is necessary to check 'NOMMU', 'CONFIG_HAS_IOMEM' ..., but it
>> > also necessary to consider about 'COMPILE_TEST' to be consistent with
>> > its 'generic' services.
> The important distinction is between drivers we want to enable in
> COMPILE_TEST because they are written in a portable way but are just
> useless if you don't have the hardware, and other drivers that rely
> on an interface and that should not be built when that interface
> is not available.

For user/distributor, they are just like what you said above, but for
some of developers ...

The comments of 'COMPILE_TEST' in init/Kconfig:

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


Thanks.
-- 
Chen Gang
