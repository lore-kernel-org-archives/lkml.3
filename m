Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbaA3Xnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 18:43:52 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:38522 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbaA3Xnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 18:43:51 -0500
MIME-Version: 1.0
In-Reply-To: <52EAD810.40204@infradead.org>
References: <CAOvWMLa334E8CYJLrHy6-0ZXBRneoMf-05v422SQw+dbGRubow@mail.gmail.com>
	<52EAA714.3080809@infradead.org>
	<CAOvWMLbs-sP+gJHV_5O6ZbV8eTpEKPVRVR238gFcPQeqhCjT3A@mail.gmail.com>
	<52EAB56E.2030102@infradead.org>
	<alpine.DEB.2.02.1401301416030.15271@chino.kir.corp.google.com>
	<52EAD810.40204@infradead.org>
Date: Thu, 30 Jan 2014 15:43:50 -0800
Message-ID: <CAOmQrk1aghJrFb6RNO1yTwN51Brk_88O9k8OuCm_QshP3zag-Q@mail.gmail.com>
Subject: Re: [BUG] Description for memmap in kernel-parameters.txt is wrong
From: Andiry Xu <andiry.xu@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: David Rientjes <rientjes@google.com>, Andiry Xu <andiry@gmail.com>,
        linux-kernel@vger.kernel.org, Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 2:54 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 01/30/2014 02:17 PM, David Rientjes wrote:
>> On Thu, 30 Jan 2014, Randy Dunlap wrote:
>>
>>>>>> Hi,
>>>>>>
>>>>>> In kernel-parameters.txt, there is following description:
>>>>>>
>>>>>> memmap=nn[KMG]$ss[KMG]
>>>>>>                         [KNL,ACPI] Mark specific memory as reserved.
>>>>>>                         Region of memory to be used, from ss to ss+nn.
>>>>>
>>>>> Should be:
>>>>>                           Region of memory to be reserved, from ss to ss+nn.
>>>>>
>>>>> but that doesn't help with the problem that you describe, does it?
>>>>>
>>>>
>>>> Actually it should be:
>>>>                              Region of memory to be reserved, from nn to nn+ss.
>>>>
>>>> That is, exchange nn and ss.
>>>
>>> Yes, I understand that that's what you are reporting.  I just haven't yet
>>> worked out how the code manages to exchange those 2 values.
>>>
>>
>> It doesn't, the documentation is correct as written and could be improved
>> by your suggestion of "Region of memory to be reserved, from ss to ss+nn."
>> I think Andiry probably is having a problem with his bootloader
>> interpreting the '$' incorrectly (or variable expansion if coming from the
>> shell) or interpreting the resulting user-defined e820 map incorrectly.
>> --
>
> Yeah, I certainly don't see a problem with the code and I would want to
> see/understand that before I exchanged the 2 values in the documentation.
>
> I'll submit a patch to make the wording a bit better.
>

I'm using Ubuntu 13.04 with GRUB2. If it's a bootloader issue, what should I do?

Thanks,
Andiry
