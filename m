Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbaJXD7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 23:59:16 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:43567 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbaJXD7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 23:59:14 -0400
Message-ID: <5449CE8E.8000304@roeck-us.net>
Date: Thu, 23 Oct 2014 20:59:10 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>, Chris Healy <chealy@imsco-us.com>,
        Andrew Lunn <andrew@lunn.ch>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/14] net: dsa/mv88e6352: Implement EEPROM accessfunctions
References: <1414037002-25528-1-git-send-email-linux@roeck-us.net><141403700	2-25528-11-git-send-email-linux@roeck-us.net><20141023135412.GC25190@lunn.ch>,<20141023164052.GB21343@roeck-us.net> <724F6C6CDC8C86478473775085778C4E0A465931@ImsEx1.ims.dom> <54494F2A.10509@gmail.com>
In-Reply-To: <54494F2A.10509@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.5449CE91.0138,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
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

On 10/23/2014 11:55 AM, Florian Fainelli wrote:
> On 10/23/2014 11:41 AM, Chris Healy wrote:
>> Hi Guenter,
>>
>> I do not believe it is possible to know if an EEPROM is attached or not.
>
> If we cannot do this, how about a DT/platform data set of properties
> that describes the EEPROM when present?
>
Yes, I think that is a good idea.

Thanks,
Guenter

>>
>> Chris
>> ________________________________________
>> From: Guenter Roeck [linux@roeck-us.net]
>> Sent: Thursday, October 23, 2014 9:40 AM
>> To: Andrew Lunn
>> Cc: netdev@vger.kernel.org; David S. Miller; Florian Fainelli; linux-kernel@vger.kernel.org; Chris Healy
>> Subject: Re: [PATCH 10/14] net: dsa/mv88e6352: Implement EEPROM         accessfunctions
>>
>> On Thu, Oct 23, 2014 at 03:54:12PM +0200, Andrew Lunn wrote:
>>> On Wed, Oct 22, 2014 at 09:03:18PM -0700, Guenter Roeck wrote:
>>>> MV88E6352 supports read and write access to its configuration eeprom.
>>>
>>> Hi Guenter
>>>
>>> I don't have the datasheet for the MV88E6352. Is the EEPROM built in,
>>> or external on an i2c bus?
>>>
>> External.
>>
>>>> +static int mv88e6352_get_eeprom_len(struct dsa_switch *ds)
>>>> +{
>>>> +   return 0x200;
>>>> +}
>>>
>>> How do you handle the case of it being external and not populated.
>>> Would it not be better to try to detect it here, and return 0 if it
>>> does not exist?
>>>
>> Makes sense, if it is detectable that it the EEPROM not there. Browsing
>> through the datasheet, I don't see how I could detect it; there does not
>> seem to be a status bit indicating if the EEPROM is there or not. There
>> are sw_mode pins which determine if the eeprom should be loaded after
>> reset or not, but I don't see anything in the register set which would
>> tell me.
>>
>> Chris, do you know if there is a means to detect if the EEPROM is present
>> on the MV88E6352 ?
>>
>> Thanks,
>> Guenter
>>
>> ________________________________
>>
>>
>> This email and any files transmitted with it are confidential & proprietary to Systems and Software Enterprises, LLC. This information is intended solely for the use of the individual or entity to which it is addressed. Access or transmittal of the information contained in this e-mail, in full or in part, to any other organization or persons is not authorized.
>>
>
>

