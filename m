Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbbAWQD7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:03:59 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:60138 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbbAWQD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:03:58 -0500
Message-ID: <54C270C4.4010407@roeck-us.net>
Date: Fri, 23 Jan 2015 08:03:16 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, Jisheng Zhang <jszhang@marvell.com>
CC: Wim Van Sebroeck <wim@iguana.be>, Heiko Stuebner <heiko@sntech.de>,
        Lunxue Dai <lunxue.dai@rock-chips.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] watchdog: dw_wdt: pat the watchdog before enabling
 it
References: <1421882243-3631-1-git-send-email-dianders@chromium.org>	<20150122132200.4729d38b@xhacker> <CAD=FV=UMmfNAEQVKCxTBapwO=pgno+cWUJNiMS7_uFK7NPevkw@mail.gmail.com>
In-Reply-To: <CAD=FV=UMmfNAEQVKCxTBapwO=pgno+cWUJNiMS7_uFK7NPevkw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.54C270EA.0256,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 01/22/2015 09:09 AM, Doug Anderson wrote:
> Jisheng,
>
> On Wed, Jan 21, 2015 at 9:22 PM, Jisheng Zhang <jszhang@marvell.com> wrote:
>> Dear Doug,
>>
>> On Wed, 21 Jan 2015 15:17:22 -0800
>> Doug Anderson <dianders@chromium.org> wrote:
>>
>>> On some dw_wdt implementations the "top" register may be initted to 0
>>> at bootup.  In such a case, each "pat" of the watchdog will reset the
>>> timer to 0xffff.  That's pretty short.
>>
>> + Guenter Roeck
>>
>> This should have been fixed by dfa07141e7a792("watchdog: dw_wdt: initialise
>> TOP_INIT in dw_wdt_set_top()")
>
> I will admit that I'm testing on a tree that doesn't have your patch
> (I'm on a 3.14 kernel with lots of backports).  ...but I did try
> cherry-picking your patch before I wrote up mine and it didn't fix my
> problem.  I believe that the watchdog that's in Rockchip rk3288 must
> be a slightly different version of the IP block than you're working
> with.
>
> Specifically I see the register WDT_TORR that has an offset of 0x4.
> That's the RANGE_REG in your code.  It shows bits 3:0 set the timeout
> period (0 = 0xffff and 15 = 0x7fffffff).  It shows bits 31:4 as
> "reserved".
>
Not sure where that leaves us. Does that mean the driver supports different
hardware with different register sets ? Should that be documented in the driver,
and should we have (or do we need) different compatible statements for those
variants, and conditional code in the driver ?

And does it mean we need both patches, at least for some of the hardware
variants ? If so, what happens if those patches are applied and the resulting
driver runs on the other hardware ?

Thanks,
Guenter

