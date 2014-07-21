Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbaGUWnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 18:43:00 -0400
Received: from mail-yk0-f169.google.com ([209.85.160.169]:42532 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbaGUWm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 18:42:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140720213025.GA5103@ravnborg.org>
References: <1405733677-16650-1-git-send-email-viniciustinti@gmail.com>
	<20140720100239.GA3496@ravnborg.org>
	<20140720210458.GA5019@ravnborg.org>
	<20140720213025.GA5103@ravnborg.org>
Date: Mon, 21 Jul 2014 19:42:57 -0300
Message-ID: <CALD9WKxTzPYeaAZRrYYuLjNK4VvF1pDxzeDPDvWLuSOpw7_1Tw@mail.gmail.com>
Subject: Re: [PATCH] kbuild: add support to generate LLVM bitcode files
From: Tinti <viniciustinti@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Behan Webster <behanw@converseincode.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) Can we drop the test for $(COMPILER) here?

Yes.

2) And help section should be updated to list .ll too.

I will be adding it too.

3) This chunk belongs together with the other chunk.
There is no reason to separate .S => .ll and .c => .ll rules.

Sure. But in fact I was not able to create the .ll from .S and neither
create the .s
from the .S in some assembly files on kernel. Do you know how it works?

4) Also $(DISABLE_LTO) looks like a left-over.

Remove $(DISABLE_LTO)

5) quiet_cmd_cc_ll_c = CC $(quiet_modtag)  $@
      cmd_cc_ll_c = $(CC) $(c_flags) ....

Understood.

Thanks.

On Sun, Jul 20, 2014 at 6:30 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Sun, Jul 20, 2014 at 11:04:58PM +0200, Sam Ravnborg wrote:
>> > >
>> > > +ifeq ($(COMPILER),clang)
>> > > +quiet_cmd_cc_ll_c = CC $(quiet_modtag)  $@
>> > > +cmd_cc_ll_c       = $(CC) $(c_flags) $(DISABLE_LTO) -fverbose-asm -emit-llvm -S -o $@ $<
>> >
>> > Can we drop the test for COMPILER here too?
>> > Do -fverbose-asm make sense when generating .ll files?
>> > It looks like a leftover from what you copied.
>>
>> Also  $(DISABLE_LTO) looks like a left-over.
>> It was added to avoid LTO when generating asm-offstes.s which
>> the original rule is also used for.
>> So this should be skipped too.
> Third thing.
> In some places we indent the assignmnet like this:
> quiet_cmd_cc_ll_c = CC $(quiet_modtag)  $@
>       cmd_cc_ll_c = $(CC) $(c_flags) ....
>
> This makes it more obvious that the "cmd_cc_ll_c" is actually the same.
> Makefile.build does not do this much but please do for these targets.
>
>         Sam



-- 
Simplicity is the ultimate sophistication
