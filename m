Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbaCVUys (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 16:54:48 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:36565 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaCVUyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 16:54:43 -0400
Message-ID: <532E0699.2080303@cogentembedded.com>
Date: Sun, 23 Mar 2014 00:54:33 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Ralf Baechle <ralf@linux-mips.org>, Sanjay Lal <sanjayl@kymasys.com>,
        John Crispin <blogic@openwrt.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mips: export icache_flush_range
References: <20140322154720.GA23863@www.outflux.net> <532E0486.3010702@cogentembedded.com> <532E053C.90007@cogentembedded.com>
In-Reply-To: <532E053C.90007@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2014 12:48 AM, Sergei Shtylyov wrote:

>>> The lkdtm module performs tests against executable memory ranges, so
>>> it needs to flush the icache for proper behaviors. Other architectures
>>> already export this, so do the same for MIPS.

>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>> ---
>>> This is currently untested! I'm building a MIPS cross-compiler now...
>>> If someone can validate this fixes the build when lkdtm is a module,
>>> that would be appreciated. :)
>>> ---
>>>   arch/mips/mm/cache.c |    1 +
>>>   1 file changed, 1 insertion(+)

>>> diff --git a/arch/mips/mm/cache.c b/arch/mips/mm/cache.c
>>> index fde7e56d13fe..b3f1df13d9f6 100644
>>> --- a/arch/mips/mm/cache.c
>>> +++ b/arch/mips/mm/cache.c
>>> @@ -38,6 +38,7 @@ void (*__flush_kernel_vmap_range)(unsigned long vaddr, int
>>> size);
>>>   void (*__invalidate_kernel_vmap_range)(unsigned long vaddr, int size);
>>>
>>>   EXPORT_SYMBOL_GPL(__flush_kernel_vmap_range);
>>> +EXPORT_SYMBOL_GPL(flush_icache_range);

>>     Have you run this thru scripts/checkpatch.pl? It would have told you that
>> an export should immediately follow the corresponding function body, AFAIK.

>     Hm, it doesn't now but definitely used to...

    Decided to check Documentation/CodingStyle, and it still codifies this:

In source files, separate functions with one blank line.  If the function is
exported, the EXPORT* macro for it should follow immediately after the closing
function brace line.  E.g.:

int system_is_up(void)
{
         return system_state == SYSTEM_RUNNING;
}
EXPORT_SYMBOL(system_is_up);

WBR, Sergei

