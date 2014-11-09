Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaKIXzF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 18:55:05 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:58236 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbaKIXzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 18:55:01 -0500
Message-ID: <545FFECD.9050600@roeck-us.net>
Date: Sun, 09 Nov 2014 15:54:53 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>,
        devel@driverdev.osuosl.org
CC: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v5 33/48] staging: nvec: Register with kernel power-off
 handler
References: <1415292213-28652-1-git-send-email-linux@roeck-us.net> <1415292213-28652-34-git-send-email-linux@roeck-us.net> <5008744.rVN94atT9b@ax5200p>
In-Reply-To: <5008744.rVN94atT9b@ax5200p>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020207.545FFED4.01A3,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 11/09/2014 01:41 PM, Marc Dietrich wrote:
> Am Donnerstag 06 November 2014, 08:43:17 schrieb Guenter Roeck:
>> Register with kernel power-off handler instead of setting pm_power_off
>> directly. Register with default priority since we don't know any better.
>>
>> Cc: Julian Andres Klode <jak@jak-linux.org>
>> Cc: Marc Dietrich <marvin24@gmx.de>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net
>
> ok, this version (V5) actually switches the device off in contrast to the
> first implementation. Somehow I have to find out why it works at all without
> irqs.
>
> Acked-by: Marc Dietrich <mavin24@gmx.de>
>

Hi Marc,

The most recent version does not turn off interrupts as long as the
infrastructure (architecture code, ie machine_power_off) doesn't
turn it off.

Thanks a lot for (re-)testing.

Guenter

