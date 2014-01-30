Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbaA3TeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 14:34:00 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33089 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaA3Td7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 14:33:59 -0500
MIME-Version: 1.0
In-Reply-To: <52EAA714.3080809@infradead.org>
References: <CAOvWMLa334E8CYJLrHy6-0ZXBRneoMf-05v422SQw+dbGRubow@mail.gmail.com>
	<52EAA714.3080809@infradead.org>
Date: Thu, 30 Jan 2014 11:33:59 -0800
Message-ID: <CAOvWMLbs-sP+gJHV_5O6ZbV8eTpEKPVRVR238gFcPQeqhCjT3A@mail.gmail.com>
Subject: Re: [BUG] Description for memmap in kernel-parameters.txt is wrong
From: Andiry Xu <andiry@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andiry Xu <andiry.xu@gmail.com>,
        Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 11:25 AM, Randy Dunlap <rdunlap@infradead.org> wrote:
> [adding linux-mm mailing list]
>
> On 01/30/2014 08:52 AM, Andiry Xu wrote:
>> Hi,
>>
>> In kernel-parameters.txt, there is following description:
>>
>> memmap=nn[KMG]$ss[KMG]
>>                         [KNL,ACPI] Mark specific memory as reserved.
>>                         Region of memory to be used, from ss to ss+nn.
>
> Should be:
>                           Region of memory to be reserved, from ss to ss+nn.
>
> but that doesn't help with the problem that you describe, does it?
>

Actually it should be:
                             Region of memory to be reserved, from nn to nn+ss.

That is, exchange nn and ss.

>
>> Unfortunately this is incorrect. The meaning of nn and ss is reversed.
>> For example:
>>
>> Command                  Expected                 Result
>> memmap 2G$6G        6G - 8G reserved      2G - 8G reserved
>> memmap 6G$2G        2G - 8G reserved      6G - 8G reserved
>
> Are you testing on x86?
> The code in arch/x86/kernel/e820.c always parses mem_size followed by start address.
> I don't (yet) see where it goes wrong...
>

Yes, it's a x86 machine.

>
>> Test kernel version 3.13, but I believe the issue has been there long ago.
>>
>> I'm not sure whether the description or implementation should be
>> fixed, but apparently they do not match.
>
> I prefer to change the documentation and leave the implementation as is.
>

That's fine. memmap itself works OK, it's just the description is
wrong and people like me get confused.

Thanks,
Andiry
