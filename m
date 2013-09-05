Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab3IESqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 14:46:15 -0400
Received: from smtp3.primus.ca ([209.216.129.203]:59095 "EHLO
	mail-07.primus.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753245Ab3IESqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 14:46:13 -0400
X-Greylist: delayed 1248 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Sep 2013 14:46:13 EDT
Message-ID: <5228CC9C.9020300@bell.net>
Date: Thu, 05 Sep 2013 14:25:32 -0400
From: John David Anglin <dave.anglin@bell.net>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] parisc: Export flush_cache_page() (needed by lustre)
References: <1378373595-29471-1-git-send-email-geert@linux-m68k.org> <1378396919.2142.5.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1378396919.2142.5.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated: danglin-lux@magma.ca - i216-58-24-141.cybersurf.com ([192.168.0.181]) [216.58.24.141]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/5/2013 12:01 PM, James Bottomley wrote:
> On Thu, 2013-09-05 at 11:33 +0200, Geert Uytterhoeven wrote:
>> ERROR: "flush_cache_page" [drivers/staging/lustre/lustre/libcfs/libcfs.ko] undefined!
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> ---
>>   arch/parisc/kernel/cache.c |    1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/parisc/kernel/cache.c b/arch/parisc/kernel/cache.c
>> index c035673..b521c0a 100644
>> --- a/arch/parisc/kernel/cache.c
>> +++ b/arch/parisc/kernel/cache.c
>> @@ -602,6 +602,7 @@ flush_cache_page(struct vm_area_struct *vma, unsigned long vmaddr, unsigned long
>>   		__flush_cache_page(vma, vmaddr, PFN_PHYS(pfn));
>>   	}
>>   }
>> +EXPORT_SYMBOL_GPL(flush_cache_page);
> This is an internal API: no architecture exports this.  Whoever is
> trying to use it needs to use the correct API, so this is the wrong
> patch.
>
There is a declaration for it in arch/parisc/include/asm/cacheflush.h.  
There are a bunch
of callers in mm.  The interface in documented in 
Documentation/cachetlb.txt.  We currently
use it in copy_to_user_page and copy_from_user_page.

Dave

-- 
John David Anglin    dave.anglin@bell.net

