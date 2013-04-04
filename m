Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763036Ab3DDQ2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:28:33 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:35002 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762961Ab3DDQ2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:28:32 -0400
MIME-Version: 1.0
In-Reply-To: <20130404141116.GC16459@redhat.com>
References: <1365035906-3208-1-git-send-email-yinghai@kernel.org>
	<1365035906-3208-2-git-send-email-yinghai@kernel.org>
	<20130404141116.GC16459@redhat.com>
Date: Thu, 4 Apr 2013 09:28:31 -0700
X-Google-Sender-Auth: 9CMfcBVNzGt71wh2c1-Ox_S2JSQ
Message-ID: <CAE9FiQU++oXMDEhro9R=Q8Vi0nu-CLdBFh8oNnhb-=gD=YYbQA@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] x86, kdump: Set crashkernel_low automatically
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 4, 2013 at 7:11 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Apr 03, 2013 at 05:38:23PM -0700, Yinghai Lu wrote:
>
> [..]
>> +     if (ret != 0) {
>> +             /*
>> +              * two parts from lib/swiotlb.c:
>> +              *      swiotlb size: user specified with swiotlb= or default.
>> +              *      swiotlb overflow buffer: now is hardcoded to 32k,
>> +              *              round to 8M to cover more others.
>> +              */
>> +             low_size = swiotlb_size_or_default() + (8UL<<20);
>> +             auto_set = true;
>
> What is the correlation between swiotlb size of first kernel and second
> kernel. They might be completely different kernel and with different
> default size for swiotlb buffers.
>

You are right.
That is most good guess assume they are the same.


> [..]
>>
>> +     crashkernel_low=size[KMG]
>> +                     [KNL, x86_64] range under 4G. When crashkernel= is
>> +                     passed, kernel allocate physical memory region
>> +                     above 4G,
>
> This is not right. "When crashkernel=X;high is passed kernel first tries
> to allocate memory above 4G". crashkernel=X does not try to allocate
> memory above 4G.

This is first patch, the text will be updated in second and fourth patch.

Thanks

Yinghai
