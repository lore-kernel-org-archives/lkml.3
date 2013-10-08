Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362Ab3JHQp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:45:28 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:42314 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756285Ab3JHQpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:45:23 -0400
MIME-Version: 1.0
In-Reply-To: <1381249090.2081.240.camel@joe-AO722>
References: <CAOMFOmXfw2DkesOYip9VFDdUQgVN48qbJfuertPaSCz5aGdaeA@mail.gmail.com>
	<1381248622-27809-1-git-send-email-anatol.pomozov@gmail.com>
	<1381249090.2081.240.camel@joe-AO722>
Date: Tue, 8 Oct 2013 18:45:21 +0200
Message-ID: <CAFLxGvzrEQGE8+QAFCQL=z2hwe578pBdWOu4B+DkJDjxkM0=hw@mail.gmail.com>
Subject: Re: [PATCH] core: Catch overflows in do_div() function
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Anatol Pomozov <anatol.pomozov@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, rdunlap@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 6:18 PM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2013-10-08 at 09:10 -0700, Anatol Pomozov wrote:
>> If second parameter passed to this function was 64 then it silently
>> truncates to 32 bits. Catch such situation.
> []
>> diff --git a/include/asm-generic/div64.h b/include/asm-generic/div64.h
> []
>> @@ -25,6 +26,7 @@
>>  # define do_div(n,base) ({                                   \
>>       uint32_t __base = (base);                               \
>>       uint32_t __rem;                                         \
>> +     BUG_ON(sizeof(base) > 4 && base >= (1UL<<32));          \
>
> I think this would be better as a BUILD_BUG_ON

No. BUILD_BUG_ON works only for constants.

Anatol, have you tested whether your change increases the kernel size?

-- 
Thanks,
//richard
