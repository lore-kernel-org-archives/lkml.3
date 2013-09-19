Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab3ISSLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 14:11:35 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:63428 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab3ISSLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 14:11:33 -0400
MIME-Version: 1.0
In-Reply-To: <1379614006-3844-1-git-send-email-will.deacon@arm.com>
References: <1379614006-3844-1-git-send-email-will.deacon@arm.com>
Date: Thu, 19 Sep 2013 13:11:32 -0500
X-Google-Sender-Auth: lFVc8p37XKe05EyiLuFqimqFxE4
Message-ID: <CA+55aFxuc3yD5pH2w5uEr_VDsEANvEiGCWA6tu1cSFrAiaU4Ow@mail.gmail.com>
Subject: Re: [PATCH] lockref: use cmpxchg64 explicitly for lockless updates
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Waiman Long <Waiman.Long@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 1:06 PM, Will Deacon <will.deacon@arm.com> wrote:
> The cmpxchg() function tends not to support 64-bit arguments on 32-bit
> architectures. This could be either due to use of unsigned long arguments
> (like on ARM) or lack of instruction support (cmpxchgq on x86). However,
> these architectures may implement a specific cmpxchg64() function to
> provide 64-bit cmpxchg support instead

I'm certainly ok with this, but I wonder how much point there is to
use the cmpxchg alternatives for 32-bit architectures at all...

>From a performance standpoint, lockref really is expected to mainly
help with big machines. Only insane people would do big machines with
32-bit kernels these days.

Of course, it may be that cmpxchg is actually faster on some
architectures, but at least on x86-32, cmpxchg8b is traditionally
quite slow.

In other words, I'd actually like to see some numbers if there are
loads where this actually helps and matters...

                   Linus
