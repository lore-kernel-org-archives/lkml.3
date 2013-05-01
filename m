Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab3EAWMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 18:12:36 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:39056 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab3EAWMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 18:12:34 -0400
MIME-Version: 1.0
X-Originating-IP: [212.159.75.221]
In-Reply-To: <20130501214335.GB11630@ZenIV.linux.org.uk>
References: <1367442257-7897-1-git-send-email-james.hogan@imgtec.com>
	<20130501214335.GB11630@ZenIV.linux.org.uk>
Date: Wed, 1 May 2013 23:12:33 +0100
X-Google-Sender-Auth: Tn3UpqCbYH-aO0PMVocoKupk47s
Message-ID: <CAAG0J99nmKeXiReJ_qK==zQy5rjTo0WzG_hF1O-oee9ADTDZGw@mail.gmail.com>
Subject: Re: [PATCH] linkage.h: fix build breakage due to symbol prefix handling
From: James Hogan <james.hogan@imgtec.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 May 2013 22:43, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, May 01, 2013 at 10:04:17PM +0100, James Hogan wrote:
>> Al's commit e1b5bb6d1236d4ad2084c53aa83dde7cdf6f8eea ("consolidate
>> cond_syscall and SYSCALL_ALIAS declarations") broke the build on
>> blackfin and metag due to the following code:
>>
>>   #ifndef SYMBOL_NAME
>>   #ifdef CONFIG_SYMBOL_PREFIX
>>   #define SYMBOL_NAME(x) CONFIG_SYMBOL_PREFIX ## x
>>   #else
>>   #define SYMBOL_NAME(x) x
>>   #endif
>>   #endif
>>   #define __SYMBOL_NAME(x) __stringify(SYMBOL_NAME(x))
>>
>> __stringify literally stringifies CONFIG_SYMBOL_PREFIX ##x, so you get
>> lines like this in kernel/sys_ni.s:
>>
>>   .weak CONFIG_SYMBOL_PREFIXsys_quotactl
>>   .set CONFIG_SYMBOL_PREFIXsys_quotactl,CONFIG_SYMBOL_PREFIXsys_ni_syscall
>>
>> The patches in Rusty's modules-next tree such as "CONFIG_SYMBOL_PREFIX:
>> cleanup." clean up the whole mess around symbol prefixes, so this patch
>> just attempts to fix the build in the mean time. The intermediate
>> definition of SYMBOL_NAME above isn't used and is incorrect when
>> CONFIG_SYMBOL_PREFIX is defined as CONFIG_SYMBOL_PREFIX is a quoted
>> string literal, so define __SYMBOL_NAME directly depending on
>> CONFIG_SYMBOL_PREFIX.
>
> Oh, hell...  Guys, my deep apologies - what happened is that this thing
> has been caught in -next, rebase done here (on top of Rusty's commit)
> and *not* pushed to linux-next.  Unfortunately, folks had been too polite
> and didn't keep kicking me - mistake, since the whole thing got forgotten ;-/
> Sigh...

No worries. Unfortunately after the tip of linux-next started working
again with Rusty's commit it sort of fell off my radar.

Cheers
James
