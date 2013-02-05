Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637Ab3BEWXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:23:53 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37924 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755964Ab3BEWXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:23:51 -0500
Message-ID: <51118671.7020204@linux.vnet.ibm.com>
Date: Tue, 05 Feb 2013 14:23:45 -0800
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux MM <linux-mm@kvack.org>, David Hansen <dave@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 1/9] mm: add SECTION_IN_PAGE_FLAGS
References: <1358463181-17956-1-git-send-email-cody@linux.vnet.ibm.com> <1358463181-17956-2-git-send-email-cody@linux.vnet.ibm.com> <20130201162002.49eadeb7.akpm@linux-foundation.org>
In-Reply-To: <20130201162002.49eadeb7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020522-9360-0000-0000-000010335FC3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2013 04:20 PM, Andrew Morton wrote:
> On Thu, 17 Jan 2013 14:52:53 -0800
> Cody P Schafer <cody@linux.vnet.ibm.com> wrote:
>
>> Instead of directly utilizing a combination of config options to determine this,
>> add a macro to specifically address it.
>>
>> ...
>>
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -625,6 +625,10 @@ static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct *vma)
>>   #define NODE_NOT_IN_PAGE_FLAGS
>>   #endif
>>
>> +#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
>> +#define SECTION_IN_PAGE_FLAGS
>> +#endif
>
> We could do this in Kconfig itself, in the definition of a new
> CONFIG_SECTION_IN_PAGE_FLAGS.

Yep, I only put it here because it "sounds" the similar to 
NODE_NOT_IN_PAGE_FLAGS, but (of course) NODE_NOT_IN_PAGE_FLAGS isn't 
defined based on pure dependencies, while this is.

> I'm not sure that I like that sort of thing a lot though - it's rather a
> pain to have to switch from .[ch] over to Kconfig to find the
> definitions of things.  I should get off my tail and teach my ctags
> scripts to handle this.



