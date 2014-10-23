Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbaJWNUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:20:22 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:33994 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbaJWNUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:20:15 -0400
Message-ID: <5449008C.4050505@roeck-us.net>
Date: Thu, 23 Oct 2014 06:20:12 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        netdev@vger.kernel.org
CC: "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/14] net: dsa: Report known silicon revisions for Marvell
 88E6060
References: <1414037002-25528-1-git-send-email-linux@roeck-us.net> <1414037002-25528-3-git-send-email-linux@roeck-us.net> <5448F9B4.9010209@cogentembedded.com>
In-Reply-To: <5448F9B4.9010209@cogentembedded.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.5449008F.005A,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
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

On 10/23/2014 05:51 AM, Sergei Shtylyov wrote:
> Hello.
>
> On 10/23/2014 8:03 AM, Guenter Roeck wrote:
>
>> Report known silicon revisions when probing Marvell 88E6060 switches.
>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>>   drivers/net/dsa/mv88e6060.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>
>> diff --git a/drivers/net/dsa/mv88e6060.c b/drivers/net/dsa/mv88e6060.c
>> index 05b0ca3..c29aebe 100644
>> --- a/drivers/net/dsa/mv88e6060.c
>> +++ b/drivers/net/dsa/mv88e6060.c
>> @@ -69,8 +69,11 @@ static char *mv88e6060_probe(struct device *host_dev, int sw_addr)
>>
>>       ret = mdiobus_read(bus, sw_addr + REG_PORT(0), 0x03);
>>       if (ret >= 0) {
>> -        ret &= 0xfff0;
>>           if (ret == 0x0600)
>> +            return "Marvell 88E6060 (A0)";
>> +        if (ret == 0x0601 || ret == 0x0602)
>
>     *else* *if*.
>
>> +            return "Marvell 88E6060 (B0)";
>> +        if ((ret & 0xfff0) == 0x0600)
>
>     Likewise?
>

The if case returns, so the else would just introduce an unnecessary
additional level of indentation. I think nowadays even checkpatch
complains about an unnecessary else after return.

Thanks,
Guenter

