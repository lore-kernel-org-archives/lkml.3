Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbaFFVKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 17:10:17 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:49749 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbaFFVKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 17:10:15 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyKTbBUM4DJukmW5fiH213D0FbVmrreR9wOtMRmmijQ9Q@mail.gmail.com>
References: <201406042235.s54MZgwP020553@terminus.zytor.com>
 <20140606140017.afb7f91142f66cb3dd13c186@linux-foundation.org> <CA+55aFyKTbBUM4DJukmW5fiH213D0FbVmrreR9wOtMRmmijQ9Q@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 6 Jun 2014 14:09:54 -0700
Message-ID: <CALCETrWA92Q4ro9eaRkUrebjgQT7B2uj+bK81m9byZnDY_eMxA@mail.gmail.com>
Subject: Re: [GIT PULL] x86/vdso changes for v3.16
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Peter Anvin <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sasha.levin@oracle.com>,
        Stefani Seibold <stefani@seibold.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pavel Emelyanov <xemul@parallels.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2014 at 2:07 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Jun 6, 2014 at 2:00 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> arch/x86/vdso/vdso2c.h: In function 'go64':
>> arch/x86/vdso/vdso2c.h:21: warning: implicit declaration of function 'le64toh'
>> arch/x86/vdso/vdso2c.h:21: warning: implicit declaration of function 'le32toh'
>> arch/x86/vdso/vdso2c.h:21: warning: implicit declaration of function 'le16toh'
>> arch/x86/vdso/vdso2c.h:119: warning: implicit declaration of function 'htole16'
>>
>> My Fedora Core 6 (lol gotcha) test box doesn't have these.
>
> Suggested fix: only use the helper functions on non-x86 (or
> non-little-endian) platforms.
>
> Peter, Andy?

The only real downside to that would be the chance of bitrot if that
code isn't getting used on native builds.

Blech.

--Andy
