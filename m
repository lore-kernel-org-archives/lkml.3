Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbaK2SP5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 13:15:57 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:35662 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaK2SP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 13:15:56 -0500
Message-ID: <547A0D58.5020806@roeck-us.net>
Date: Sat, 29 Nov 2014 10:15:52 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: Re: [PATCH] i8k: Add support for temperature sensor labels
References: <1417277047-15489-1-git-send-email-pali.rohar@gmail.com> <5479F328.7080304@roeck-us.net> <201411291730.28743@pali>
In-Reply-To: <201411291730.28743@pali>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.547A0D5B.0227,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 11/29/2014 08:30 AM, Pali Rohár wrote:
> On Saturday 29 November 2014 17:24:08 Guenter Roeck wrote:
>> On 11/29/2014 08:04 AM, Pali Rohár wrote:
>>> +static bool __init i8k_check_temp(int sensor)
>>> +{
>>> +	int err;
>>> +
>>> +	/*
>>> +	 * Check if temperature sensor type is valid.
>>> +	 *
>>> +	 * If it is valid then sensor should work. But some
>>> sensors are not +	 * available at any time. E.g GPU sensor
>>> on Optimus/PowerExpress/Enduro +	 * card does not work (or
>>> return bogus value) when card is turned off. +	 * So this
>>> function should not fail in this case. +	 */
>>> +	err = i8k_get_temp_type(sensor);
>>> +	if (err >= 0)
>>> +		return true;
>>> +
>>
>> Are you sure this function is provided for all systems ?
>> I am a bit concerned that we may wrongly disable sensors this
>> way, especially on older systems.
>>
>
> I do not know if that function is provided on all systems. But
> this code does not disable sensors. If function fail, then we
> fallback to temperature read down. Return true means that we
> enable sensor.
>

You are right. Guess I didn't have enough coffee this morning.

Thanks,
Guenter

