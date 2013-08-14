Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951Ab3HNARz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 20:17:55 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:43455 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998Ab3HNARy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 20:17:54 -0400
MIME-Version: 1.0
In-Reply-To: <1376438836-13339-2-git-send-email-andi@firstfloor.org>
References: <1376438836-13339-1-git-send-email-andi@firstfloor.org>
	<1376438836-13339-2-git-send-email-andi@firstfloor.org>
Date: Tue, 13 Aug 2013 17:17:53 -0700
X-Google-Sender-Auth: Dv-6pUk3WKHImFZFd4IFHtztasM
Message-ID: <CA+55aFz6GMqmXUFHNi94-oT+3v1Qt050Ui3DmEYOuyv1Z526Yg@mail.gmail.com>
Subject: Re: [PATCH 1/8] x86: Add 1/2/4/8 byte optimization to 64bit __copy_{from,to}_user_inatomic
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 5:07 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> 32bit already did this correctly by duplicating the code.

I wonder how much of this could be in asm/uaccess.h? We already do all
the fixed-size get_user/put_user stuff in that generic x86 code, and
I'm wondering why we don't do the "__builtin_constant_p()" cases of
copy_to/from_user() there too?

It's independent of this patch-series, but it might be good to take a
look at unifying these things..

             Linus
