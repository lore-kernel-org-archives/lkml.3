Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbaGHIBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:01:36 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:62117 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbaGHIBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:01:34 -0400
MIME-Version: 1.0
In-Reply-To: <CALYGNiMjL_GYqqkid4yQsubpnbydVXxTPnKW0GqJcg05x9zbHQ@mail.gmail.com>
References: <20140705112238.16142.42735.stgit@zurg>
	<20140707150523.cc671116bf366e8db73209c5@linux-foundation.org>
	<CALYGNiMjL_GYqqkid4yQsubpnbydVXxTPnKW0GqJcg05x9zbHQ@mail.gmail.com>
Date: Tue, 8 Jul 2014 10:01:33 +0200
Message-ID: <CAFLxGvzxvuizdHyjQ0SjUm8jJcj=w+qS5ut-u76Xo-m2sftvvw@mail.gmail.com>
Subject: Re: [uml-devel] [PATCH] checkstack: use $UTS_MACHINE as target architecture
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        UML devel <user-mode-linux-devel@lists.sourceforge.net>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 7:48 AM, Konstantin Khlebnikov <koct9i@gmail.com> wrote:
> On Tue, Jul 8, 2014 at 2:05 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> On Sat, 05 Jul 2014 15:22:38 +0400 Konstantin Khlebnikov <koct9i@gmail.com> wrote:
>>
>>> This fixes command # make checkstack for i386/x86_64.
>>> Looks like $UTS_MACHINE is exactly what scripts/checkstack.pl needs.
>>>
>>> By default $UTS_MACHINE is equal to $ARCH, but some arch/${ARCH}/Makefile
>>> overrides it. This patch updates it also in arch/x86/Makefile.um
>>>
>>> broken in ffee0de ("x86: Default to ARCH=x86 to avoid overriding CONFIG_64BIT")
>>
>> The changelog doesn't describe the bug which is being fixed.  It should
>> do so please.  If there are any compiler/make error messages then those
>> should be included.
>>
>
> Oh, ok. checkstalk.pl needs either i386 or x86_64, x86 isn't enough.
>
> $ make checkstack
> objdump -d vmlinux $(find . -name '*.ko') | \
> perl /home/blind/src/linux-stable/scripts/checkstack.pl x86
> wrong or unknown architecture "x86"

And now we need ARCH, SUBARCH and UTS_MACHINE on UML? :-(

-- 
Thanks,
//richard
