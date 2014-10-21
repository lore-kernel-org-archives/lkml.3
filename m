Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbaJUSS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 14:18:29 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:37520 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482AbaJUSS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 14:18:27 -0400
Message-ID: <54466069.5070702@roeck-us.net>
Date: Tue, 21 Oct 2014 06:32:25 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, Johan Hovold <johan@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Alexander Graf <agraf@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiko Stuebner <heiko@sntech.de>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        =?UTF-8?B?UGhpbGlwcGUgUsOpdG9ybmF6?= <philippe.retornaz@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH v2 01/47] kernel: Add support for poweroff handler call
 chain
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net> <1413864783-3271-2-git-send-email-linux@roeck-us.net> <20141021093405.GA2113@localhost> <20141021103007.GI26842@x1>
In-Reply-To: <20141021103007.GI26842@x1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.5446A373.013A,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 8
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2014 03:30 AM, Lee Jones wrote:
> On Tue, 21 Oct 2014, Johan Hovold wrote:
>
>> On Mon, Oct 20, 2014 at 09:12:17PM -0700, Guenter Roeck wrote:
>>
>>> v2:
>>> - poweroff -> power_off
>>
>> Do you want to stick to power[-_ ]off consistently throughout?
>
> I guess you'll want to fix all of these before I review the MFD
> patches?
>
>>> - Add defines for default priorities
>>> - Use raw notifiers protected by spinlocks instead of atomic notifiers
>>> - Add register_poweroff_handler_simple
>>> - Add devm_register_power_off_handler
>>>
>>>   include/linux/pm.h              |  22 ++++
>>>   kernel/power/Makefile           |   1 +
>>>   kernel/power/poweroff_handler.c | 252 ++++++++++++++++++++++++++++++++++++++++
>>>   3 files changed, 275 insertions(+)
>>>   create mode 100644 kernel/power/poweroff_handler.c
>>>
>>> diff --git a/include/linux/pm.h b/include/linux/pm.h
>>> index 383fd68..7e0cb36 100644
>>> --- a/include/linux/pm.h
>>> +++ b/include/linux/pm.h
>>> @@ -34,7 +34,29 @@
>>>   extern void (*pm_power_off)(void);
>>>   extern void (*pm_power_off_prepare)(void);
>>>
>>> +/*
>>> + * Callbacks to manage poweroff handlers
>>
>> power-off
>
> power_off, no?
>
That is describing text, so hopefully I can use real words here and
don't have to use a term derived from variable and function names.

Sure, I can change poweroff in all describing text to power-off
if that is preferred, no big deal.

Thanks,
Guenter

