Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab3IKSQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 14:16:54 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:39543 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab3IKSQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 14:16:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130910220638.GG11427@tassilo.jf.intel.com>
References: <CACT4Y+Y6r=HV7nFgbu=B=d-4ka3J4yotRjgX1M1xGkNkFn1sOQ@mail.gmail.com>
 <20130910220638.GG11427@tassilo.jf.intel.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Wed, 11 Sep 2013 22:16:32 +0400
Message-ID: <CACT4Y+Y2-d0TFq=oq-xFt8udrYc0r8_aROdUfVU29KJBhwWpAQ@mail.gmail.com>
Subject: Re: Out-of-bounds access in get_wchan (arch/x86/kernel/process_64.c)
To: Andi Kleen <ak@linux.intel.com>, Wolfram Gloger <wg@malloc.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Turner <pjt@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Kostya Serebryany <kcc@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 2:06 AM, Andi Kleen <ak@linux.intel.com> wrote:
>> Indeed, get_wchan ensures that fp<stack+THREAD_SIZE, but then dereferences fp+8:
>>
>> 434                 if (fp < (unsigned long)stack ||
>> 435                     fp >= (unsigned long)stack+THREAD_SIZE)
>> 436                         return 0;
>> 437                 ip = *(u64 *)(fp+8);
>>
>> It must check that fp+8<stack+THREAD_SIZE.
>> As far as I see, the bug can lead to garbage return values or in the
>> worst case to crash.
>
> Thanks for the report.
>
> The change looks good to me. Can you please submit a formal signed off patch
> to x86@kernel.org ?

Hi Andi,

Wolfram has a patch for it.
Wolfram, please send your patch to x86@kernel.org.
