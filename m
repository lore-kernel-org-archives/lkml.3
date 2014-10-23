Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641AbaJWFVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 01:21:33 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:57797 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaJWFVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 01:21:31 -0400
Message-ID: <54489059.8010606@roeck-us.net>
Date: Wed, 22 Oct 2014 22:21:29 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>
CC: netdev <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/14] net: dsa: Add support for reading switch registers
 with ethtool
References: <1414037002-25528-1-git-send-email-linux@roeck-us.net> <1414037002-25528-12-git-send-email-linux@roeck-us.net> <CAGVrzcbfkSK58iCPouMc4g8MBrAPBemi8QyP6_33xtYiRWFCHg@mail.gmail.com>
In-Reply-To: <CAGVrzcbfkSK58iCPouMc4g8MBrAPBemi8QyP6_33xtYiRWFCHg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A02020A.5448905B.002A,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 10/22/2014 09:40 PM, Florian Fainelli wrote:
> 2014-10-22 21:03 GMT-07:00 Guenter Roeck <linux@roeck-us.net>:
>> Add support for reading switch registers with 'ethtool -d'.
>>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>
> [snip]
>
>>
>> +static int dsa_slave_get_regs_len(struct net_device *dev)
>> +{
>> +       struct dsa_slave_priv *p = netdev_priv(dev);
>> +       struct dsa_switch *ds = p->parent;
>> +
>> +       if (ds->drv->get_regs_len != NULL)
>> +               return ds->drv->get_regs_len(ds, p->port);
>
> Most of the checks in this file are just:
>
> if (ds->drv->callback)
>       return ds->drv->callback(...)
>
Hi Florian,

To be fair, that wasn't the case when I wrote the code ;-).
No problem, I'll do the same.

>> +
>> +       return -EOPNOTSUPP;
>> +}
>> +
>> +static void
>> +dsa_slave_get_regs(struct net_device *dev, struct ethtool_regs *regs, void *_p)
>> +{
>> +       struct dsa_slave_priv *p = netdev_priv(dev);
>> +       struct dsa_switch *ds = p->parent;
>> +
>> +       ds->drv->get_regs(ds, p->port, regs, _p);
>
> We need to check that the driver does implement this callback here as well.
>

Obviously, and embarrassing ;-).

Thanks a lot for the review!
Guenter

