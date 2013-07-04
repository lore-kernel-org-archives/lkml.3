Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191Ab3GDBvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 21:51:40 -0400
Received: from intranet.asianux.com ([58.214.24.6]:28547 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493Ab3GDBvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 21:51:38 -0400
X-Spam-Score: -100.8
Message-ID: <51D4D4A0.6080401@asianux.com>
Date: Thu, 04 Jul 2013 09:49:20 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, Geert Uytterhoeven <geert@linux-m68k.org>,
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
        Jiri Kosina <trivial@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] include/asm-generic/io.h: add dummy fuctions to support
 'COMPILE_TEST' in 'asm-generic'.
References: <51CA8AB8.7080504@asianux.com> <CAMuHMdW58CZ0m-10ibs2Vyh8exqP1nSH+-ZOr5J58tx=uorM+Q@mail.gmail.com> <51D375AA.5060300@asianux.com> <201307031014.12583.arnd@arndb.de> <51D3E440.7090105@asianux.com> <51D4C87E.5070605@asianux.com> <20130704011221.GA11230@kroah.com>
In-Reply-To: <20130704011221.GA11230@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2013 09:12 AM, Greg KH wrote:
> On Thu, Jul 04, 2013 at 08:57:34AM +0800, Chen Gang wrote:
>> > 'COMPILE_TEST=y' will let 'asm-generic' provide self checking sevices to
>> > both modules and architectures (especially with allmodconfig and
>> > "EXTRA_CFLAGS=-W")
> No it doesn't.
> 

"If add 'COMPILE_TEST=y' to 'asm-generic', it will provide self checking
services to both modules and architectures"

Is it correct ?

>> > For modules (especially which will run under the specific architecture
>> > soon), the developer can find more compiling issues before they really
>> > support it.
> Huh?
> 

For developers, they may has hobby to let their code pass compiling as
much as possible in the integrating environments, although the modules
may not really load/run.


>> > For architectures, can let modules compile as much as possible (if
>> > "COMPILE_TEST=y"), it will give a better check for the architectures.
>> > 
>> > At present, most of architectures (include various machine/cpu in an
>> > architecture) can not pass compiling with 'allmodconfig'. One of the
>> > main reasons is the HW of the specific architecture does not support.
>> > 
>> > It is neither architectures issue nor modules issue, the root cause is:
>> > "now, 'asm-generic' doesn't provide the related necessary public
>> > services for it".
> That's not what asm-generic is for at all.

Hmm... at least, it is neither architectures issue nor modules issue.

So we have to look for who have duty for it, since it is a 'generic'
issue for many architectures and modules, we have to find it in
'generic' area (e.g. "./include/*").

At least now, it seems only "asm-generic/*" can play the unlucky role !!

Or, do you think it is still the modules issue themselves ?


Thanks.
-- 
Chen Gang
