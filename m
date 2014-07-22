Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbaGVD5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 23:57:38 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:50758 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbaGVD5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 23:57:35 -0400
Message-ID: <53CDE123.6040100@linux.vnet.ibm.com>
Date: Tue, 22 Jul 2014 09:27:23 +0530
From: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: arnd@arndb.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cleanup include/asm-generic/atomic.h
References: <1405985437-16631-1-git-send-email-maddy@linux.vnet.ibm.com> <alpine.DEB.2.02.1407211707510.5825@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1407211707510.5825@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072203-5490-0000-0000-0000007353BD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2014 05:38 AM, David Rientjes wrote:
> On Tue, 22 Jul 2014, Madhavan Srinivasan wrote:
> 
>> Commit 4b358e2206 "cleanup include/asm-generic/atomic.h" added
>> comments for #else/#endif, but ended up adding same comment
>> "BITS_PER_LONG == 64" on both sides. This patch fixes it.
>>
> 
> It's intentionally like that, it comments the condition for which the 
> #endif is matched.

Ok, will change the else comment. And include/asm-generic/local64.h
also needs a change in comment.

Regards
Maddy

> 
>> Signed-off-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
>> ---
>>  include/asm-generic/atomic-long.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/asm-generic/atomic-long.h b/include/asm-generic/atomic-long.h
>> index b7babf0..a8434c6 100644
>> --- a/include/asm-generic/atomic-long.h
>> +++ b/include/asm-generic/atomic-long.h
>> @@ -253,6 +253,6 @@ static inline long atomic_long_add_unless(atomic_long_t *l, long a, long u)
>>  #define atomic_long_xchg(v, new) \
>>  	(atomic_xchg((atomic_t *)(v), (new)))
>>  
>> -#endif  /*  BITS_PER_LONG == 64  */
>> +#endif  /*  BITS_PER_LONG != 64  */
>>  
>>  #endif  /*  _ASM_GENERIC_ATOMIC_LONG_H  */
> 

