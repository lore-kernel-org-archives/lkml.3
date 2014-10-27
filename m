Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbaJ0NWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 09:22:40 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:58072 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbaJ0NWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 09:22:38 -0400
Message-ID: <544E471B.8080507@roeck-us.net>
Date: Mon, 27 Oct 2014 06:22:35 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 09/15] net: dsa: Add support for switch EEPROM access
References: <1414342365-27191-1-git-send-email-linux@roeck-us.net> <1414342365-27191-10-git-send-email-linux@roeck-us.net> <20141027024121.GA16998@lunn.ch> <544DC264.9020600@roeck-us.net> <20141027085048.GC4748@netboy>
In-Reply-To: <20141027085048.GC4748@netboy>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.544E471E.00BA,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 10/27/2014 01:50 AM, Richard Cochran wrote:
> On Sun, Oct 26, 2014 at 08:56:20PM -0700, Guenter Roeck wrote:
>>
>> Also, it seems that you request two separate properties, one for presence
>> and another for length. Is that correct ? Again, I thought that would not
>> provide any value since presence is indicated by length != 0 in the ethtool
>> callback function. No problem, though, I'll be happy to create two separate
>> properties and platform data variables if you think that would be better.
>
> The fewer properties, the better.
>

Right now I have:

Optional properties:
- eeprom-length         : Set to the length of an EEPROM connected to the
                           switch. Must be set if the switch can not detect
                           the presence and/or size of a connected EEPROM,
                           otherwise optional.

and I think Andrew is asking for the following:

Optional properties:
- eeprom-present	: Boolean property indicating that an EEPROM is present.
			  Must be set if an EEPROM is present.
- eeprom-length         : Set to the length of an EEPROM connected to the
                           switch. Must be set if the switch can not detect
                           the size of a connected EEPROM, otherwise optional.

Platform data semantics would be the same.

I can go either way, but I would like to get some kind of agreement before I jump
into writing the code.

Thanks,
Guenter

