Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbaKKKmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 05:42:35 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:43540 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbaKKKmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 05:42:33 -0500
Message-ID: <5461E80D.4010307@roeck-us.net>
Date: Tue, 11 Nov 2014 02:42:21 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>
CC: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Alexander Graf <agraf@suse.de>,
        linuxppc-dev list <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH v6 41/48] powerpc: Register with kernel power-off handler
References: <1415583785-6980-1-git-send-email-linux@roeck-us.net>	 <1415583785-6980-42-git-send-email-linux@roeck-us.net> <1415691766.9757.1.camel@concordia>
In-Reply-To: <1415691766.9757.1.camel@concordia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Suspect
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.5461E819.0112,ss=2,re=0.001,recu=0.000,reip=0.000,cl=2,cld=1,fgs=0
X-CTCH-Score: 0.001
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

On 11/10/2014 11:42 PM, Michael Ellerman wrote:
> On Sun, 2014-11-09 at 17:42 -0800, Guenter Roeck wrote:
>> Register with kernel power-off handler instead of setting pm_power_off
>> directly.
>>
>> If there is an indication that there can be more than one power-off handler,
>> use register_power_off_handler, otherwise use register_power_off_handler_simple
>> to register the power-off handler.
>>
>> If the power-off handler only resets or stops the system, select the fallback
>> priority to indicate that the power-off handler is one of last resort.
>> If the power-off handler powers off the system, select the default priority,
>> unless the power-off handler installation code suggests that there can be
>> more than one power-off handler and the new handler is only installed
>> conditionally. In this case, install the handler with low priority.
>>
>> Cc: Alexander Graf <agraf@suse.de>
>> Cc: Michael Ellerman <mpe@ellerman.id.au>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>
> Can you fold in the patch below. I know pm.h is included by device.h, so most
> things will already have it, but I'd rather be explicit.
>
> With that you can add my:
>
> Acked-by: Michael Ellerman <mpe@ellerman.id.au>
>

Done.

Thanks,
Guenter


