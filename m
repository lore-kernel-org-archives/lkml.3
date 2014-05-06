Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbaEFUoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:44:14 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54855 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754806AbaEFUoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:44:13 -0400
Message-ID: <53694978.3050303@free-electrons.com>
Date: Tue, 06 May 2014 22:43:36 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bryan Evenson <bevenson@melinkcorp.com>
CC: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtc: rtc-at91rm9200: fix infinite wait for ACKUPD irq
References: <94c06375c1b44c8eb5233b0ccf2e4b13@BY2PR05MB048.namprd05.prod.outlook.com> <1399386481-18643-1-git-send-email-boris.brezillon@free-electrons.com> <aed75d16aa46476eb6f6c5b0d4bef30d@BLUPR05MB037.namprd05.prod.outlook.com>
In-Reply-To: <aed75d16aa46476eb6f6c5b0d4bef30d@BLUPR05MB037.namprd05.prod.outlook.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/05/2014 21:06, Bryan Evenson wrote:
> Boris,
>
>> -----Original Message-----
>> From: Boris BREZILLON [mailto:boris.brezillon@free-electrons.com]
>> Sent: Tuesday, May 06, 2014 10:28 AM
>> To: Bryan Evenson
>> Cc: Andrew Victor; Nicolas Ferre; Jean-Christophe Plagniol-Villard; linux-arm-
>> kernel@lists.infradead.org; Alessandro Zummo; rtc-
>> linux@googlegroups.com; linux-kernel@vger.kernel.org; Boris BREZILLON
>> Subject: [PATCH] rtc: rtc-at91rm9200: fix infinite wait for ACKUPD irq
>>
>> The rtc user must wait at least 1 sec between each time/calandar update
>> (see atmel's datasheet chapter "Updating Time/Calendar").
>>
>> Use the 1Hz interrupt to update the at91_rtc_upd_rdy flag and wait for
>> the at91_rtc_wait_upd_rdy event if the rtc is not ready.
>>
>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
>> Reported-by: Bryan Evenson <bevenson@melinkcorp.com>
>> ---
>> Hello Bryan,
>>
>> I reproduced your bug (using your script) and this patch seems to fix the
>> problem.
>>
>> Could you try it and let me know if it works for you ?
> Looks good to me.  I modified the test script as follows:
>
> ----------
> #!/bin/sh
> i=0
> while [ 1 ]; do
>   hwclock -w -u > /dev/null 2>&1
>   echo $$ $i $?
>   : $((i++))
> done
> ----------
>
> This version then attempts to write to the RTC as often as possible (script change was due to a suggestion on the Busybox mailing list).  I ran two instances of the script, which each looped through about 60,000 times over a 30 minute run.  At no point has access to the RTC been permanently locked out on my system.  I'd call this fixed.

Great!

> I'd assume this patch would be backported to the longterm releases?

I'd like to wait for Nicolas' ack before asking for a backport to stable
releases.

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

