Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817AbbA0EIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 23:08:12 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:57504 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbbA0EIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 23:08:07 -0500
Message-ID: <54C70F24.5080100@roeck-us.net>
Date: Mon, 26 Jan 2015 20:08:04 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Jisheng Zhang <jszhang@marvell.com>, Doug Anderson <dianders@chromium.org>
CC: Wim Van Sebroeck <wim@iguana.be>, Heiko Stuebner <heiko@sntech.de>,
        Lunxue Dai <lunxue.dai@rock-chips.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] watchdog: dw_wdt: pat the watchdog before enabling
 it
References: <1422314836-30516-1-git-send-email-dianders@chromium.org> <20150127114909.204eeee0@xhacker>
In-Reply-To: <20150127114909.204eeee0@xhacker>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.54C70F26.013F,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 6
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

On 01/26/2015 07:49 PM, Jisheng Zhang wrote:
> Dear Doug,
>
> On Mon, 26 Jan 2015 15:27:15 -0800
> Doug Anderson <dianders@chromium.org> wrote:
>
>> On some dw_wdt implementations the "top" register may be initted to 0
>> at bootup.  In such a case, each "pat" of the watchdog will reset the
>> timer to 0xffff.  That's pretty short.
>>
>> The input clock of the wdt can be any of a wide range of values.  On
>> an rk3288 system, I've seen the wdt clock be 24.75 MHz.  That means
>> each tick is ~40ns and we'll count to 0xffff in ~2.6ms.
>>
>> Because of the above two facts, it's a really good idea to pat the
>> watchdog after initting the "top" register properly and before
>> enabling the watchdog.  If you don't then there's no way we'll get the
>> next heartbeat in time.
>>
>> Jisheng Zhang fixed this problem on some dw_mmc versions by using the
>
> s/dw_mmc/dw_wdt
>
>> TOP_INIT feature.  However, the dw_wdt on rk3288 doesn't have TOP_INIT
>> so it's a good idea to also pat the watchdog manually.
>
> Based on your register dumping, I see the following configurations on rk3288:
>
> WDT_DUAL_TOP is configured as false, so there's no TOP_INIT
>
> WDT_DFLT_TOP is configured as 0, so it will timeout soon.
>
>
> So an extra pat is a must on such platforms with similar configurations. And it
> doesn't hurt anything if we have an extra pat before enabling the WDT
>
> All in all, except the "dw_mmc" typo above, the patch looks good to me.
>

Jisheng,

it would be great if you can provide configuration information shown in
the (undocumented) registers.

Doug,

can you send another version with this information added as comment
to the code ? This will help others to understand what is going on
(and why) later on.

Thanks,
Guenter

