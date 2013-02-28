Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab3B1GIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 01:08:23 -0500
Received: from intranet.asianux.com ([58.214.24.6]:5131 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3B1GIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 01:08:20 -0500
X-Spam-Score: -100.8
Message-ID: <512EF43D.1070805@asianux.com>
Date: Thu, 28 Feb 2013 14:07:57 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: JBottomley@parallels.com, David Miller <davem@davemloft.net>,
        kxie@chelsio.com, michaelc@cs.wisc.edu
CC: linux-scsi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/scsi/cxgbi: correcting the include path, so can
 pass compiling.
References: <50F15A35.4000400@asianux.com> <50FB9A33.2090204@asianux.com> <51077BB3.2010809@asianux.com> <512ECDDC.2020607@asianux.com>
In-Reply-To: <512ECDDC.2020607@asianux.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  I find another more suitable way to fix this issue.
    using ccflags-y instead of EXTRA_FLAGS.
    according to the file ./script/checkpatch.pl:

1755                 if (($realfile =~ /Makefile.*/ || $realfile =~ /Kbuild.*/) &&
1756                     ($line =~ /\+(EXTRA_[A-Z]+FLAGS).*/)) {
1757                         my $flag = $1;
1758                         my $replacement = {
1759                                 'EXTRA_AFLAGS' =>   'asflags-y',
1760                                 'EXTRA_CFLAGS' =>   'ccflags-y',
1761                                 'EXTRA_CPPFLAGS' => 'cppflags-y',
1762                                 'EXTRA_LDFLAGS' =>  'ldflags-y',
1763                         };
1764                    
1765                         WARN("DEPRECATED_VARIABLE",
1766                              "Use of $flag is deprecated, please use \`$replacement->{$flag} instead.\n" . $herecurr) if ($replacement  ->{$flag});


  I need send new patch for it.

  welcome any members to provide additional suggestions or completions.

  thanks.

  :-)

gchen.


于 2013年02月28日 11:24, Chen Gang 写道:
> Hello relative Maintainers:
> 
>   could any one help checking this patch ?
> 
>     this patch fixes the compiling issue.
>     the make command in my x86_64 laptop is: "make V=1 allmodconfig"
>     the patch was sent in Jan-12-2013, and get non-reply now.
> 
>   could you please give a glance when you have time.
> 
>   thanks.
> 
>   :-)
> 
> gchen.
> 
> 
> 于 2013年01月29日 15:35, Chen Gang 写道:
>> Hello JBottomley@parallels.com
>>
>>   have you already fixed it by another patches ?
>>
>>   if so:
>>     better to let me know about it, so I should not bother you, again.
>>   else
>>     please give a glance to this patch, when you have time
>>      (since compiling errors are always belong to critical errors)
>>
>>   thanks.
>>
>>
>> by the way:
>>    I get the sending mail address from ./script/get_maintainer.pl.
>>    if I sent to an incorrect member, please tell me.
>>
>>   thanks.
>>
>> gchen.
>>
>>
>> 于 2013年01月20日 15:18, Chen Gang 写道:
>>> Hello JBottomley@parallels.com
>>>
>>>   when you have free time, could you give a glance for this patch ?
>>>
>>>   thanks.
>>>
>>> gchen.
>>>
>>>
>>> 于 2013年01月12日 20:42, Chen Gang 写道:
>>>>
>>>>   correct the include path,
>>>>   or the compiler will report can not find "common.h"...
>>>>
>>>>   both cxgb3/ and cxgb4/ sub directly have l2t.h (they are different).
>>>>   so it is not suitable to '-I' sub-directy, directly.
>>>>
>>>>
>>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>>> ---
>>>>  drivers/scsi/cxgbi/Makefile        |    4 ++++
>>>>  drivers/scsi/cxgbi/cxgb3i/cxgb3i.c |   14 +++++++-------
>>>>  drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |   10 +++++-----
>>>>  3 files changed, 16 insertions(+), 12 deletions(-)
>>>>
>>>> diff --git a/drivers/scsi/cxgbi/Makefile b/drivers/scsi/cxgbi/Makefile
>>>> index 86007e3..aff2998 100644
>>>> --- a/drivers/scsi/cxgbi/Makefile
>>>> +++ b/drivers/scsi/cxgbi/Makefile
>>>> @@ -1,2 +1,6 @@
>>>> +
>>>> +ccflags-y			:= -Idrivers/net/ethernet/chelsio
>>>> +subdir-ccflags-y		:= -Idrivers/net/ethernet/chelsio
>>>> +
>>>>  obj-$(CONFIG_SCSI_CXGB3_ISCSI)	+= libcxgbi.o cxgb3i/
>>>>  obj-$(CONFIG_SCSI_CXGB4_ISCSI)	+= libcxgbi.o cxgb4i/
>>>> diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
>>>> index 49692a1..ca92e72 100644
>>>> --- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
>>>> +++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
>>>> @@ -18,13 +18,13 @@
>>>>  #include <linux/moduleparam.h>
>>>>  #include <scsi/scsi_host.h>
>>>>  
>>>> -#include "common.h"
>>>> -#include "t3_cpl.h"
>>>> -#include "t3cdev.h"
>>>> -#include "cxgb3_defs.h"
>>>> -#include "cxgb3_ctl_defs.h"
>>>> -#include "cxgb3_offload.h"
>>>> -#include "firmware_exports.h"
>>>> +#include "cxgb3/common.h"
>>>> +#include "cxgb3/t3_cpl.h"
>>>> +#include "cxgb3/t3cdev.h"
>>>> +#include "cxgb3/cxgb3_defs.h"
>>>> +#include "cxgb3/cxgb3_ctl_defs.h"
>>>> +#include "cxgb3/cxgb3_offload.h"
>>>> +#include "cxgb3/firmware_exports.h"
>>>>  #include "cxgb3i.h"
>>>>  
>>>>  static unsigned int dbg_level;
>>>> diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
>>>> index f924b3c..a5795d5 100644
>>>> --- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
>>>> +++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
>>>> @@ -20,11 +20,11 @@
>>>>  #include <net/dst.h>
>>>>  #include <linux/netdevice.h>
>>>>  
>>>> -#include "t4_msg.h"
>>>> -#include "cxgb4.h"
>>>> -#include "cxgb4_uld.h"
>>>> -#include "t4fw_api.h"
>>>> -#include "l2t.h"
>>>> +#include "cxgb4/t4_msg.h"
>>>> +#include "cxgb4/cxgb4.h"
>>>> +#include "cxgb4/cxgb4_uld.h"
>>>> +#include "cxgb4/t4fw_api.h"
>>>> +#include "cxgb4/l2t.h"
>>>>  #include "cxgb4i.h"
>>>>  
>>>>  static unsigned int dbg_level;
>>>>
>>>
>>>
>>
>>
> 
> 


-- 
Chen Gang

Asianux Corporation
