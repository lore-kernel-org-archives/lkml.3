Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaLULrr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 06:47:47 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:41909 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaLULrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 06:47:45 -0500
Message-ID: <5496B343.1010601@roeck-us.net>
Date: Sun, 21 Dec 2014 03:47:15 -0800
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
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com> <1419012268-20805-1-git-send-email-pali.rohar@gmail.com> <5495C228.4030400@roeck-us.net> <201412211013.36508@pali>
In-Reply-To: <201412211013.36508@pali>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.5496B361.0036,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 12/21/2014 01:13 AM, Pali Rohár wrote:
> On Saturday 20 December 2014 19:38:32 Guenter Roeck wrote:
>>> +	if (fan_mult <= 0) {
>>
>> Wonder what to do in the < 0 case. It might be better to make
>> the variable and the module parameter an unsigned int to
>> cover that case, since a negative multiplier doesn't really
>> make sense. Same for fan_max.
>>
>
> In some other kernel modules negative value means autodetect. I
> think we can do that too.
>
But 0 already implies autodetect, so that would be redundant.

>>> +		/*
>>> +		 * Autodetect fan multiplier for each fan based on
>>> nominal rpm +		 * First set default fan multiplier for each
>>> fan +		 * And if it reports rpm value too high then set
>>> multiplier to 1 +		 *
>>> +		 * Try also setting multiplier from current rpm, but
> this
>>> will +		 * work only in case when fan is not turned off. It
>>> is better +		 * then nothing for machines which does not
>>> support nominal rpm +		 * SMM function.
>>> +		 */
>>> +		for (fan = 0; fan < ARRAY_SIZE(i8k_fan_mult); ++fan) {
>>> +			i8k_fan_mult[fan] = I8K_FAN_DEFAULT_MULT;
>>> +			if (i8k_get_fan_speed(fan) > I8K_FAN_MAX_RPM) {
>>> +				i8k_fan_mult[fan] = 1;
>>> +				continue;
>>> +			}
>>
>> What if i8k_get_fan_speed(fan) returns an error ? Doesn't that
>> imply that the fan does not exist, and that you would not
>> need the second loop in the first place ?
>>
>
> See my other email "[PATCH] i8k: Add support for fan labels". DOS
> binary check for fan presence by another function. I bet it is
> because fan could have same problem as temperature sensors. If
> fan is on GPU and GPU is turned off reading fan rpm will fail.
> But my laptop (with GPU which can be turned on/off) does not have
> GPU fan so this is just my assumption.
>
Good point.

Guenter

