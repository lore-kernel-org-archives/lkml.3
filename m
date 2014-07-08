Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaGHFst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 01:48:49 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:42548 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaGHFss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 01:48:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140707150523.cc671116bf366e8db73209c5@linux-foundation.org>
References: <20140705112238.16142.42735.stgit@zurg>
	<20140707150523.cc671116bf366e8db73209c5@linux-foundation.org>
Date: Tue, 8 Jul 2014 09:48:47 +0400
Message-ID: <CALYGNiMjL_GYqqkid4yQsubpnbydVXxTPnKW0GqJcg05x9zbHQ@mail.gmail.com>
Subject: Re: [PATCH] checkstack: use $UTS_MACHINE as target architecture
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, x86@kernel.org,
        UML devel <user-mode-linux-devel@lists.sourceforge.net>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 2:05 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sat, 05 Jul 2014 15:22:38 +0400 Konstantin Khlebnikov <koct9i@gmail.com> wrote:
>
>> This fixes command # make checkstack for i386/x86_64.
>> Looks like $UTS_MACHINE is exactly what scripts/checkstack.pl needs.
>>
>> By default $UTS_MACHINE is equal to $ARCH, but some arch/${ARCH}/Makefile
>> overrides it. This patch updates it also in arch/x86/Makefile.um
>>
>> broken in ffee0de ("x86: Default to ARCH=x86 to avoid overriding CONFIG_64BIT")
>
> The changelog doesn't describe the bug which is being fixed.  It should
> do so please.  If there are any compiler/make error messages then those
> should be included.
>

Oh, ok. checkstalk.pl needs either i386 or x86_64, x86 isn't enough.

$ make checkstack
objdump -d vmlinux $(find . -name '*.ko') | \
perl /home/blind/src/linux-stable/scripts/checkstack.pl x86
wrong or unknown architecture "x86"
