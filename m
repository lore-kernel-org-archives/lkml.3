Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbbA0EH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 23:07:58 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:57476 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbbA0EH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 23:07:56 -0500
Message-ID: <54C70F17.7070003@roeck-us.net>
Date: Mon, 26 Jan 2015 20:07:51 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Jisheng Zhang <jszhang@marvell.com>, Doug Anderson <dianders@chromium.org>
CC: Wim Van Sebroeck <wim@iguana.be>, Heiko Stuebner <heiko@sntech.de>,
        Lunxue Dai <lunxue.dai@rock-chips.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] watchdog: dw_wdt: pat the watchdog before enabling
 it
References: <1421882243-3631-1-git-send-email-dianders@chromium.org>	<20150122132200.4729d38b@xhacker>	<CAD=FV=UMmfNAEQVKCxTBapwO=pgno+cWUJNiMS7_uFK7NPevkw@mail.gmail.com>	<20150126142210.4cd0b33f@xhacker>	<CAD=FV=WKeH2hmgsB1Hh8G6LWGqSVf_nOTCs7PVqLZV_gB_VqhA@mail.gmail.com> <20150127114403.71736c3f@xhacker>
In-Reply-To: <20150127114403.71736c3f@xhacker>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.54C70F1B.0071,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 1
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

On 01/26/2015 07:44 PM, Jisheng Zhang wrote:
> Dear Doug,
>
> On Mon, 26 Jan 2015 09:01:37 -0800
> Doug Anderson <dianders@chromium.org> wrote:
>
>> Jisheng,
>>
>> On Sun, Jan 25, 2015 at 10:22 PM, Jisheng Zhang <jszhang@marvell.com> wrote:
>>>> Specifically I see the register WDT_TORR that has an offset of 0x4.
>>>> That's the RANGE_REG in your code.  It shows bits 3:0 set the timeout
>>>> period (0 = 0xffff and 15 = 0x7fffffff).  It shows bits 31:4 as
>>>> "reserved".
>>>
>>> Could you please dump registers' value at offset 0xf4 and 0xf8 if you
>>> don't mind?
>>
>> Those are not documented in the user manual that I have, but:
>>
>>>>> r(0xff8000f4)
>> 0x10000a02
>>>>> r(0xff8000f8)
>> 0x3130332a
>
Hi Jisheng,

This translates to ascii "103*". How does it translate to "1.02a" ?

> Thanks. Now I got some information about your platform:
>
> wdt version: v1.02a
>
> WDT_DUAL_TOP is configured as false, so there's no TOP_INIT
> WDT_DFLT_TOP is configured as 0, so it will timeout soon.
>
Any chance you can provide the bit map for the register reporting
those flags ?

Thanks,
Guenter

