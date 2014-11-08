Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaKHETR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 23:19:17 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:58471 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbaKHETQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 23:19:16 -0500
Message-ID: <545D99BA.5020707@roeck-us.net>
Date: Fri, 07 Nov 2014 20:19:06 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Beniamino Galvani <b.galvani@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v5 20/48] mfd: rn5t618: Register power-off handler with
 kernel power-off handler
References: <1415292213-28652-1-git-send-email-linux@roeck-us.net> <1415292213-28652-21-git-send-email-linux@roeck-us.net> <20141107210006.GA22111@gmail.com>
In-Reply-To: <20141107210006.GA22111@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020207.545D99C3.0192,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 11/07/2014 01:00 PM, Beniamino Galvani wrote:
> On Thu, Nov 06, 2014 at 08:43:04AM -0800, Guenter Roeck wrote:
>> Register with kernel power-off handler instead of setting pm_power_off
>> directly. Register with low priority to reflect that the original code
>> only sets pm_power_off if it was not already set.
>>
>> Cc: Beniamino Galvani <b.galvani@gmail.com>
>> Acked-by: Lee Jones <lee.jones@linaro.org>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>> v5:
>> - Rebase to v3.18-rc3
>> v4:
>> - Do not use notifiers but internal functions and data structures to manage
>>    the list of power-off handlers. Drop unused parameters from callbacks, and
>>    make the power-off function type void
>> v3:
>> - Replace poweroff in all newly introduced variables and in text
>>    with power_off or power-off as appropriate
>> - Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
>> v2:
>> - New patch
>>
>>   drivers/mfd/rn5t618.c       | 28 ++++++++++++----------------
>>   include/linux/mfd/rn5t618.h |  2 ++
>>   2 files changed, 14 insertions(+), 16 deletions(-)
>
> Tested-by: Beniamino Galvani <b.galvani@gmail.com>
>
Thanks!

Guenter

