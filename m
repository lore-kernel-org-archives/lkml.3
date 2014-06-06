Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbaFFVHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 17:07:23 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:43067 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbaFFVHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 17:07:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140606140017.afb7f91142f66cb3dd13c186@linux-foundation.org>
References: <201406042235.s54MZgwP020553@terminus.zytor.com>
	<20140606140017.afb7f91142f66cb3dd13c186@linux-foundation.org>
Date: Fri, 6 Jun 2014 14:07:17 -0700
X-Google-Sender-Auth: rP8TxYndDrGfwbFDy1vDvG-nqmI
Message-ID: <CA+55aFyKTbBUM4DJukmW5fiH213D0FbVmrreR9wOtMRmmijQ9Q@mail.gmail.com>
Subject: Re: [GIT PULL] x86/vdso changes for v3.16
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Peter Anvin <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Stefani Seibold <stefani@seibold.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pavel Emelyanov <xemul@parallels.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2014 at 2:00 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> arch/x86/vdso/vdso2c.h: In function 'go64':
> arch/x86/vdso/vdso2c.h:21: warning: implicit declaration of function 'le64toh'
> arch/x86/vdso/vdso2c.h:21: warning: implicit declaration of function 'le32toh'
> arch/x86/vdso/vdso2c.h:21: warning: implicit declaration of function 'le16toh'
> arch/x86/vdso/vdso2c.h:119: warning: implicit declaration of function 'htole16'
>
> My Fedora Core 6 (lol gotcha) test box doesn't have these.

Suggested fix: only use the helper functions on non-x86 (or
non-little-endian) platforms.

Peter, Andy?

             Linus
