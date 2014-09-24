Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbaIXBlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 21:41:25 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:46345 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaIXBlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 21:41:23 -0400
Message-ID: <54222123.2050703@roeck-us.net>
Date: Tue, 23 Sep 2014 18:40:51 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jisheng Zhang <jszhang@marvell.com>
CC: "wim@iguana.be" <wim@iguana.be>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/2] watchdog: dw_wdt: add restart handler support
References: <1411458132-5410-1-git-send-email-jszhang@marvell.com>	<1411458132-5410-3-git-send-email-jszhang@marvell.com>	<20140923183159.GB24930@roeck-us.net> <20140924091101.60e065cd@xhacker>
In-Reply-To: <20140924091101.60e065cd@xhacker>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A02020A.54222143.0045,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
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

On 09/23/2014 06:11 PM, Jisheng Zhang wrote:
[ ... ]
>>> +	dw_wdt.restart_handler.notifier_call = dw_wdt_restart_handle;
>>> +	dw_wdt.restart_handler.priority = 128;
>>> +	ret = register_restart_handler(&dw_wdt.restart_handler);
>>> +	if (ret)
>>> +		pr_warn("cannot register restart handler\n");
>>
>> Please use dev_warn(&pdev->dev, ...).
>
> Yep, that's what I thought when patching the code. But the original source is
> using pr_*(), so I use pr_warn() to keep unification. Is there any better
> solution?
>

Good point. Makes sense, then, to leave that as cleanup.

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

