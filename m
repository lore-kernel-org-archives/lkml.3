Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbaLUMYA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 07:24:00 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:46278 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbaLUMX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 07:23:59 -0500
Message-ID: <5496BBC4.90705@roeck-us.net>
Date: Sun, 21 Dec 2014 04:23:32 -0800
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
Subject: Re: [PATCH v3] i8k: Autodetect maximal fan speed and fan RPM multiplier
References: <1419012268-20805-1-git-send-email-pali.rohar@gmail.com> <1419153618-6930-1-git-send-email-pali.rohar@gmail.com> <5496B594.6050205@roeck-us.net> <201412211309.41077@pali>
In-Reply-To: <201412211309.41077@pali>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.5496BBDE.0112,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 12/21/2014 04:09 AM, Pali Rohár wrote:
> On Sunday 21 December 2014 12:57:08 Guenter Roeck wrote:
>>> -#define I8K_FAN_MULT		30
>>> +#define I8K_FAN_MAX_RPM		30000
>>>
>>>    #define I8K_MAX_TEMP		127
>>>
>>>    #define I8K_FN_NONE		0x00
>>>
>>> @@ -64,7 +66,7 @@ static DEFINE_MUTEX(i8k_mutex);
>>>
>>>    static char bios_version[4];
>>>    static struct device *i8k_hwmon_dev;
>>>    static u32 i8k_hwmon_flags;
>>>
>>> -static int i8k_fan_mult;
>>> +static int i8k_fan_mult = 30;
>>
>> Why did you drop I8K_FAN_MULT ?
>>
>
> Because I think it is not needed anymore... It is used only in
> one place (there ^). But if you want I can revert it back.
>
That is not a reason to drop a define.

>>>    static int __init i8k_probe(void)
>>>    {
>>>
>>> +	const struct i8k_config_data *conf;
>>
>> Why did you move this variable declaration ?
>>
>
> Comes from previous version of patches where I moved all
> variables to start of function. I will revert this change.
>
>>>
>>> -		const struct i8k_config_data *conf = id->driver_data;
>>> +		conf = id->driver_data;
>>> +		if (fan_mult <= 0 && conf->fan_mult > 0)
>>
>> I still don't see the value in accepting fan_mult < 0
>> (compeared to == 0).
>>
>
> Ok. What kernel driver should do if user load it with negative
> parameter? We should not propagate negative value to functions.
>
You have multiple options: Ignore it (bad idea ;-), abort loading
the module with -EINVAL, or make the module parameter an unsigned.

I would prefer the latter. Either case, that should be a separate patch
(different logical change).

Thanks,
Guenter

