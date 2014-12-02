Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbaLBO0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:26:34 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:33347 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaLBO0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:26:33 -0500
Message-ID: <547DCC15.70300@roeck-us.net>
Date: Tue, 02 Dec 2014 06:26:29 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>,
        =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: Re: [PATCH] i8k: Add support for temperature sensor labels
References: <1417277047-15489-1-git-send-email-pali.rohar@gmail.com>	 <201411291849.44032@pali> <20141129175152.GA32510@kroah.com>	 <201411291904.07644@pali> <1417526599.15239.7.camel@chaos.site>
In-Reply-To: <1417526599.15239.7.camel@chaos.site>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020207.547DCC18.0152,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
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

On 12/02/2014 05:23 AM, Jean Delvare wrote:
> Hi Pali, hi Greg,
>
> Le Saturday 29 November 2014 à 19:04 +0100, Pali Rohár a écrit :
>> On Saturday 29 November 2014 18:51:52 Greg Kroah-Hartman wrote:
>>> On Sat, Nov 29, 2014 at 06:49:43PM +0100, Pali Rohár wrote:
>>>> On Saturday 29 November 2014 18:43:15 Greg Kroah-Hartman wrote:
>>>>> No Documentation/ABI/ entry for your new sysfs file?
>>>>
>>>> It is standard hwmon sysfs entry which is used by other
>>>> hwmon drivers... It is not i8k.ko driver specific.
>>>
>>> Ok, then why is this driver not in a "hwmon-standard" location
>>> in the kernel tree?
>>>
>>> greg k-h
>>
>> This is question not for me but for maintainers of hwmon and char
>> trees... I just contributed patch for existing driver.
>>
>> But my idea is that because this driver exported temperature data
>> for a long time only via /proc/i8k character file (since 2.4? or
>> earlier?) and only 3 years ago was added standard hwmon interface
>> to existing code (949a9d70020defd7c241607ab3ed037ea88f551c).
>>
>> So now there are both interfaces. Standard hwmon and old /proc/.
>>
>> CCing Jean Delvare (author of hwmon i8k code)
>
> Yes, that's for historical reasons. Also the i8k driver does more than
> just hardware monitoring, it handles function keys and power status too.
> And it is heavily platform-specific. So while I agree that drivers/char
> isn't necessarily the best place for this driver, I'd rather move it to
> drivers/platform/x86 together with other laptop vendor-specific drivers,
> than to drivers/hwmon.
>
> Ultimately /proc/i8k should be killed altogether and every function
> should use the appropriate standard interface. But I don't have any Dell
> laptop around so I won't go into that myself.
>
The only function not covered by hwmon, as far as I can see, is reading
the "Fn key" status, whatever that is, and reporting the power status
(AC or battery).

The first seems to be covered by the already existing dell drivers in
platform/x86. The latter must be covered as well; Linux does
display the correct power status on all my Dell laptops.

Changing the ABI is not supposed to happen, so I am not sure if we can
just drop the /proc interface.

Guenter

