Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbaD1U13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 16:27:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:39888 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338AbaD1U11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 16:27:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,946,1389772800"; 
   d="scan'208";a="502493289"
Message-ID: <535EB986.9060802@intel.com>
Date: Mon, 28 Apr 2014 22:26:46 +0200
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Zheng, Lv" <lv.zheng@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] ACPICA: Remove deprecated _LINUX definitions for
 ACPICA.
References: <cover.1396930406.git.lv.zheng@intel.com> <cover.1398232408.git.lv.zheng@intel.com> <8e6c90efc629b463709aef5da4957e916fdc0437.1398232409.git.lv.zheng@intel.com> <2215223.yYQsuKoaSF@vostro.rjw.lan> <1AE640813FDE7649BE1B193DEA596E88025586A7@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E88025586A7@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/28/2014 6:10 AM, Zheng, Lv wrote:
> Hi, Rafael
>
>> From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
>> Sent: Monday, April 28, 2014 5:39 AM
>>
>> On Wednesday, April 23, 2014 02:54:22 PM Lv Zheng wrote:
>>> There are _LINUX defined so that when Linux kernel is compiled using broken
>>> compilers that having not __linux__ defined can still include
>>> <acpi/platform/aclinux.h> from <acpi/platform/acenv.h>.
>>>
>>> This behavior is deprecated as all drivers/acpi/acpica files are compiled
>>> without including <linux/acpi.h>, thus without _LINUX defined.  As there is
>>> no issues encountered when we compile ACPICA code without _LINUX defined,
>>> it is OK to remove _LINUX from <linux/acpi.h> now.
>>>
>>> Signed-off-by: Lv Zheng <lv.zheng@intel.com>
>>> ---
>>>   include/linux/acpi.h |    4 ----
>>>   1 file changed, 4 deletions(-)
>>>
>>> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
>>> index 7a8f2cd..9c559f7 100644
>>> --- a/include/linux/acpi.h
>>> +++ b/include/linux/acpi.h
>>> @@ -31,10 +31,6 @@
>>>
>>>   #ifdef	CONFIG_ACPI
>>>
>>> -#ifndef _LINUX
>>> -#define _LINUX
>>> -#endif
>>> -
>>>   #include <linux/list.h>
>>>   #include <linux/mod_devicetable.h>
>> What about <acpi/platform/acenv.h>?  Should it still check if _LINUX is defined
>> after this change?
> If you mean these lines:
>    #if defined(_LINUX) || defined(__linux__)
>    #include <acpi/platform/aclinux.h>
> After deleting "_LINUX" from <linux/acpi.h>, acenv.h still can include aclinux.h because of "__linux__".
> Actually all drivers/acpi/acpica source files are compiled without including <linux/acpi.h>, so "_LINUX" defined in this file is useless to Linux.
> We needn't delete "_LINUX" from acenv.h.
>
> "_LINUX" is only used in ACPICA makefiles, Linux never uses it:
>    https://github.com/acpica/acpica/blob/master/generate/unix/Makefile.config
> ACPICA can be compiled using the following make command:
>    make HOST=_LINUX
> I think this is the only usage of "_LINUX" for now.

Well, my point was: If we delete the definition of _LINUX, why don't we 
drop the symbol itself from everywhere along with it?

It definitely is not useful to refer to a symbol that's never defined, 
is it?

Rafael

