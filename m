Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbaITCk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 22:40:56 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:59518 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbaITCky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 22:40:54 -0400
Message-ID: <541CE92D.70301@roeck-us.net>
Date: Fri, 19 Sep 2014 19:40:45 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, anish@chelsio.com
CC: rdunlap@infradead.org, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, JBottomley@parallels.com,
        mchan@broadcom.com
Subject: Re: linux-next: Tree for Sep 19
References: <541CC721.2010207@roeck-us.net>	<541CD3C3.3010905@infradead.org>	<525DB349B3FB5444AE057A887CB2A8D88EF892@nice.asicdesigners.com> <20140919.220856.2166907140359359148.davem@davemloft.net>
In-Reply-To: <20140919.220856.2166907140359359148.davem@davemloft.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-0.4
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.541CE936.0028,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
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

On 09/19/2014 07:08 PM, David Miller wrote:
> From: Anish Bhatt <anish@chelsio.com>
> Date: Sat, 20 Sep 2014 01:43:05 +0000
>
>> Original config causing issues can be seen here :
>> https://lkml.org/lkml/2014/9/9/500
>>
>> As CNIC depends on IPV6, CNIC can be only compiled as a module when IPV6 is
>> compiled as a module. This was the patch I originally commited. Previous
>> behaviour was to disable all ipv6 code in such a case. However, having bnx2fc/i
>>   as built-in overrides CNIC's tristate from m to built-in (as they select CNIC),
>>   causing build issues. As far as I know, there is no way to control the state
>> that select sets.
>
> Really, nothing that has dependencies should be "select"'d, ever.
>
> What people hack up is that they try to do this, and "make it work"
> by "select"'ing all of the selected object's dependencies.  And
> then you have to do this recursively for dependencies which have
> dependencies.
>
> This is really incredibly stupid.
>
> And once something in that chain gains a new dependency, all of
> these "select" instances break.
>
> I really want all of these netlink users to "depend" on "NET"
> rather than "select" it, and so on and so forth down to the
> users of these netlink using subsystems.
>

Sure, that makes sense on some level, but you would have to make sure
that any changes made are clean and don't break existing configurations,
and/or you would have to make sure that all affected configurations are
updated as needed. A single-line change in a configuration file, to hell
with the consequences, just doesn't cut it.

We already know that 11 out of 55 mips configurations are broken in
linux-next. I don't even want to know what else is broken. That is
a pretty high price to pay to achieve purity.

Guenter

