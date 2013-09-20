Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab3ITCgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 22:36:10 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:53302 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab3ITCgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 22:36:08 -0400
Message-ID: <523BB48F.9020403@linux.vnet.ibm.com>
Date: Fri, 20 Sep 2013 08:05:59 +0530
From: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
CC: Benjamin Poirier <bpoirier@suse.de>, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]kconfig/menu.c: fix uninitialized variable warning
References: <1379575697-6740-1-git-send-email-maddy@linux.vnet.ibm.com> <20130919152227.GB19364@d2.synalogic.ca> <20130919172751.GA3317@free.fr> <20130919191315.GA19703@d2.synalogic.ca> <20130919200430.GC3317@free.fr>
In-Reply-To: <20130919200430.GC3317@free.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092002-8878-0000-0000-000008E98D4B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 September 2013 01:34 AM, Yann E. MORIN wrote:
> Benjamin, All,
> 
> On 2013-09-19 15:13 -0400, Benjamin Poirier spake thusly:
>> On 2013/09/19 19:27, Yann E. MORIN wrote:
>>> Benjamin, Madhavan, All,
>>>
>>> On 2013-09-19 11:22 -0400, Benjamin Poirier spake thusly:
>>>> On 2013/09/19 12:58, Madhavan Srinivasan wrote:
>>>>> In file included from scripts/kconfig/zconf.tab.c:2537:0:
>>>>> scripts/kconfig/menu.c: In function ‘get_symbol_str’:
>>>>> scripts/kconfig/menu.c:586:18: warning: ‘jump’ may be used uninitialized in
>>>>> this function [-Wmaybe-uninitialized]
>>>>                    ^^^^^
>>>>
>>>> from gcc(1):
>>>> 	"These warnings are made optional because GCC is not smart
>>>> 	enough to see all the reasons why the code might be correct
>>>> 	despite appearing to have an error."
>>>>
>>>> I do not see this warning with gcc 4.7.2 or 4.8.1. Which version are you
>>>> using?
>>>>
>>>> The code does:
>>>>
>>>> static void get_prompt_str(struct gstr *r, struct property *prop,
>>>> [...]
>>>> 	if (head && location) {
>>>> 		jump = xmalloc(sizeof(struct jump_key));
>>>> [... different basic block ...]
>>>> 			if (head && location && menu == location)
>>>> 				jump->offset = r->len - 1;
>>>>
>>>> If the second "if" is true, then the first one was true as well, and
>>>> "jump" is initilized.
>>>
>>> Exactly what I was going to say.
>>>
>>> However:
>>>   - I believe we should strive for a warning-free code whenever possible
>>>   - while still getting help from gcc to pinpoint potential issues.
>>>
>>> Clearly, gcc is wrong here. Setting jump to NULL will cause fault if we
>>> try to dereference it. Since this should never happen given the code as
>>> it currently is, I'm slightly in favour of acking this patch.
>>>
>>> Any other reason not to apply it?
>>
>> Did you manage to get that warning as well? I didn't. If it's only from
>> old versions of gcc I'd feel better leaving the warning there than
>> masking it, in case a future code change does really introduce a use
>> before initialize.
> 
> No, I was not able to reproduce it with either gcc-4.4.7, gcc-4.6.4 or
> gcc-4.7.3 on my Ubuntu 13.04. Neither gcc-4.5 nor 4.8 are packaged, so
> I could not test them.
> 
> Anyway, -Wmaybe-uninitialized is new with 4.7. So, the warning can't
> happen with gcc < 4.7.
> 
> Madhavan, what gcc version are you using?
gcc i have is gcc version 4.8.0 20130526
> 
> Regards,
> Yann E. MORIN.
> 

