Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbaA3WyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 17:54:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35204 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbaA3WyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 17:54:12 -0500
Message-ID: <52EAD810.40204@infradead.org>
Date: Thu, 30 Jan 2014 14:54:08 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andiry Xu <andiry@gmail.com>, linux-kernel@vger.kernel.org,
        Andiry Xu <andiry.xu@gmail.com>, Linux MM <linux-mm@kvack.org>
Subject: Re: [BUG] Description for memmap in kernel-parameters.txt is wrong
References: <CAOvWMLa334E8CYJLrHy6-0ZXBRneoMf-05v422SQw+dbGRubow@mail.gmail.com> <52EAA714.3080809@infradead.org> <CAOvWMLbs-sP+gJHV_5O6ZbV8eTpEKPVRVR238gFcPQeqhCjT3A@mail.gmail.com> <52EAB56E.2030102@infradead.org> <alpine.DEB.2.02.1401301416030.15271@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1401301416030.15271@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2014 02:17 PM, David Rientjes wrote:
> On Thu, 30 Jan 2014, Randy Dunlap wrote:
> 
>>>>> Hi,
>>>>>
>>>>> In kernel-parameters.txt, there is following description:
>>>>>
>>>>> memmap=nn[KMG]$ss[KMG]
>>>>>                         [KNL,ACPI] Mark specific memory as reserved.
>>>>>                         Region of memory to be used, from ss to ss+nn.
>>>>
>>>> Should be:
>>>>                           Region of memory to be reserved, from ss to ss+nn.
>>>>
>>>> but that doesn't help with the problem that you describe, does it?
>>>>
>>>
>>> Actually it should be:
>>>                              Region of memory to be reserved, from nn to nn+ss.
>>>
>>> That is, exchange nn and ss.
>>
>> Yes, I understand that that's what you are reporting.  I just haven't yet
>> worked out how the code manages to exchange those 2 values.
>>
> 
> It doesn't, the documentation is correct as written and could be improved 
> by your suggestion of "Region of memory to be reserved, from ss to ss+nn."  
> I think Andiry probably is having a problem with his bootloader 
> interpreting the '$' incorrectly (or variable expansion if coming from the 
> shell) or interpreting the resulting user-defined e820 map incorrectly.
> --

Yeah, I certainly don't see a problem with the code and I would want to
see/understand that before I exchanged the 2 values in the documentation.

I'll submit a patch to make the wording a bit better.

Thanks.

-- 
~Randy
