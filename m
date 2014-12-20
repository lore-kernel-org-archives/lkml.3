Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbaLTMpr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 07:45:47 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:40822 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbaLTMpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 07:45:43 -0500
Message-ID: <54956F4B.9070401@roeck-us.net>
Date: Sat, 20 Dec 2014 04:44:59 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>
Subject: Re: [PATCH v2 1/2] i8k: Autodetect maximal fan speed and fan RPM
 multiplier
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com> <201412200957.38638@pali> <549565B3.5070504@roeck-us.net> <201412201318.08216@pali>
In-Reply-To: <201412201318.08216@pali>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.54956F80.0145,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 12/20/2014 04:18 AM, Pali Rohár wrote:
> On Saturday 20 December 2014 13:04:03 Guenter Roeck wrote:
>> On 12/20/2014 12:57 AM, Pali Rohár wrote:
>>> On Friday 19 December 2014 20:28:08 Guenter Roeck wrote:
>>>> On Fri, Dec 19, 2014 at 07:51:25PM +0100, Pali Rohár wrote:
>>>>> On Friday 19 December 2014 19:32:37 Guenter Roeck wrote:
>>>>>>> -static int i8k_fan_mult;
>>>>>>> -static int i8k_pwm_mult;
>>>>>>> -static int i8k_fan_max = I8K_FAN_HIGH;
>>>>>>> +static int i8k_fan_mult[2];
>>>>>>> +static int i8k_pwm_mult[2];
>>>>>>> +static int i8k_fan_max[2];
>>>>>>
>>>>>> The rationale for this change is not explained in the
>>>>>> commit log.
>>>>>>
>>>>>> Do you have any indication that those values would ever
>>>>>> be different for the two fans, ie that you actually need
>>>>>> arrays here ?
>>>>>
>>>>> I do not know... But if we decide to use only single value
>>>>> for multiplier and max value which fan to use for
>>>>> autodetection?
>>>>
>>>> That does not answer my question. That you can not decide
>>>> which fan to use for auto-detection does not mean that the
>>>> result of that auto-detection would be different for
>>>> different fans.
>>>
>>> Really I do not know if some dell products which have more
>>> fans (some Precision models have 2) and each fan is using
>>> different multiplier or has different max speed value.
>>
>> "I do not know" is not a reason for introducing such code.
>>
>> Guenter
>
> And having broken fan rpm output in userspace is not good.
>

Sure, but only if it is in fact broken.

> My code introduce fan rpm detection for each fan. I do not see
> any problem for doing this detection per fan. You suggest to do
> some global detection and use it for each fan. And for your
> suggestion I have 2 objections:
>
The problem is that there is no evidence that a per-fan multiplier
is needed. You may not see it that way, but unnecessary code _is_
a problem since it increases code size for no good reason. Furthermore,
people not involved in this discussion will be inclined to believe
that the code is necessary, in the wrong assumption that it would
not have been introduced unless it was necessary.

> 1) I do not know if global multiplier will work for all fans.
> Detection per fan does not have this problem "I do not know".
>
It has been working all along, with no evidence that it doesn't work.

> 2) How to do that global multiplier detection? I have no idea how
> you want to do that.
>
A single multiplier worked all along. It doesn't matter which fan is
used to auto-detect the multiplier, it is still a single multiplier.

Again, introducing code if you don't know that or if it may be
needed is not an argument for introducing such code. Introduce it
if and when there is evidence that it is needed.

Thanks,
Guenter

