Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab3GCAwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 20:52:49 -0400
Received: from intranet.asianux.com ([58.214.24.6]:46211 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab3GCAwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 20:52:47 -0400
X-Spam-Score: -100.7
Message-ID: <51D375AA.5060300@asianux.com>
Date: Wed, 03 Jul 2013 08:51:54 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Richard Weinberger <richard@nod.at>, Arnd Bergmann <arnd@arndb.de>,
        Jeff Dike <jdike@addtoit.com>, David Sharp <dhsharp@google.com>,
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
References: <51CA8AB8.7080504@asianux.com> <51CA900E.9020407@nod.at> <51CA9E92.4000107@asianux.com> <51CAA0C6.60007@nod.at> <51CAA78C.5040900@asianux.com> <51CAA8D6.9000505@nod.at> <51CAAD1D.8050801@asianux.com> <51CAAE7C.9090003@nod.at> <51CAB556.4070700@asianux.com> <51CAB689.70008@nod.at> <CAMuHMdXw6VYhnNWcVfWc9ssxKTqKFcDbN4WXL5i=eNGy+gXcRA@mail.gmail.com> <51CABBDD.403@asianux.com> <51CABFAC.1040505@nod.at> <51CAC0D0.60505@asianux.com> <51D0DE09.4090702@asianux.com> <51D0FAFE.5010500@asianux.com> <51D23766.8000605@asianux.com> <CAMuHMdUvctqqStGE0QKM_BqgK2f6f_E6T=przdYszZo9A_oDzg@mail.gmail.com> <51D2888E.8020503@asianux.com> <CAMuHMdW58CZ0m-10ibs2Vyh8exqP1nSH+-ZOr5J58tx=uorM+Q@mail.gmail.com>
In-Reply-To: <CAMuHMdW58CZ0m-10ibs2Vyh8exqP1nSH+-ZOr5J58tx=uorM+Q@mail.gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2013 06:57 PM, Geert Uytterhoeven wrote:
> On Tue, Jul 2, 2013 at 10:00 AM, Chen Gang <gang.chen@asianux.com> wrote:
>> > On 07/02/2013 03:19 PM, Geert Uytterhoeven wrote:
>>> >> On Tue, Jul 2, 2013 at 4:13 AM, Chen Gang <gang.chen@asianux.com> wrote:
>>>>> >>> > 'asm-generic' need provide necessary configuration checking, if can't
>>>>> >>> > pass checking, 'asm-generic' shouldn't implement it.
>>>>> >>> >
>>>>> >>> > For 'COMPILE_TEST', according to its help contents, 'asm-generic' need
>>>>> >>> > let it pass configuration checking, and provide related dummy contents
>>>>> >>> > for it.
>>>>> >>> >
>>>>> >>> > Part of 'COMPLE_TEST' help contents in "init/Kconfig":
>>>>> >>> >
>>>>> >>> >   "...Despite they cannot be loaded there (or even when they load they cannot be used due to missing HW support)..."
>>>>> >>> >
>>>>> >>> >
>>>>> >>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>> >> NAKed-by: Geert Uytterhoeven <geert@linux-m68k.org>
>>> >>
>>> >> Please don't clutter the code with checks for CONFIG_COMPILE_TEST.
>> >
>> > Do you mean: 'asm-generic' should not support 'COMPILE_TEST' (the
>> > platform should not support 'COMPILE_TEST") ?
>> >
>> > Or you mean: 'COMPILE_TEST' should not exist in kernel ?
> I mean that COMPILE_TEST should exist in Kconfig files only.
> It's only meant to have more compile coverage, not to "fix" (through #ifdef)
> more code to make it compile.

If so, can we allow the module to 'COMPILE_TEST' under one platform
which not support the related HW ?

  e.g. "...Despite they cannot be loaded there (or even when they load
they cannot be used due to missing HW support)...".


'asm-generic' need provide generic layer to users (both architecture
guys and module guys).

So for 'default', it can depend on some conditions (e.g. HW support);
but for 'generic', it need try to be independent from any conditions.

And it is also necessary for 'generic' to provide the configuration
checking features, but this checking must be no negative effect (or
consistent) with its 'generic' services.

So it is necessary to check 'NOMMU', 'CONFIG_HAS_IOMEM' ..., but it
also necessary to consider about 'COMPILE_TEST' to be consistent with
its 'generic' services.


BTW: 20% code are for 80% features, but the left 20% features, need 80%
code, if we have to make it complete, we have to face this 'rule'.


Thanks.
-- 
Chen Gang
