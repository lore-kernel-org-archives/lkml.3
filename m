Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611Ab3JQQQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:16:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:57973 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757115Ab3JQQQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 12:16:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,515,1378882800"; 
   d="scan'208";a="309153044"
Message-ID: <52600D4A.8030506@linux.intel.com>
Date: Thu, 17 Oct 2013 09:16:10 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux@roeck-us.net,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86: unify copy_from_user() checking
References: <525E964402000078000FB70C@nat28.tlf.novell.com> <525E9BF7.7020706@linux.intel.com> <525EC6C402000078000FB895@nat28.tlf.novell.com> <525EC73E.3060204@linux.intel.com> <525FCDD702000078000FBBF5@nat28.tlf.novell.com> <52600608.2010704@linux.intel.com> <5260241602000078000FBDD9@nat28.tlf.novell.com> <52600A99.2070507@linux.intel.com> <5260279702000078000FBDE8@nat28.tlf.novell.com>
In-Reply-To: <5260279702000078000FBDE8@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2013 9:08 AM, Jan Beulich wrote:
>>>> On 17.10.13 at 18:04, Arjan van de Ven <arjan@linux.intel.com> wrote:
>>>
>>> ... and the non-constant case be taken care of at run time.
>>> That's precisely what the patch does.
>>
>> fair enough.
>>
>> I would like to see a comment above the code to describe this reasoning
>> and the objective and what the desired behavior is... so that we don't
>> have to reverse engineer this again 2 years from now ;-)
>
> Will do, and then perhaps mirror the whole behavior to
> copy_to_user().

yeah that certainly makes sense



in hindsight we should have made the copy_*_user prototype take a "type" argument,
so that the sizeof/etc are done inside the macro.
Or at least have this available as an option with a "advanced" version with just a size.
but that's a 20 year old thing at this point...
