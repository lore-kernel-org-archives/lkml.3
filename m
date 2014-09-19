Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbaISEM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 00:12:56 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:34967 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaISEMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 00:12:55 -0400
Message-ID: <541BAD2C.8080902@roeck-us.net>
Date: Thu, 18 Sep 2014 21:12:28 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Rostislav Lisovy <lisovy@gmail.com>
CC: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, sojkam1@fel.cvut.cz,
        michal.vokac@comap.cz, Rostislav Lisovy <lisovy@merica.cz>
Subject: Re: [PATCH v2] watchdog: omap_wdt: Add 'early_disable' module parameter
References: <1410877228-20925-1-git-send-email-lisovy@merica.cz>	 <20140916154921.GA14725@roeck-us.net> <1410967369.5542.2.camel@lp-lvrv.comap.cz>
In-Reply-To: <1410967369.5542.2.camel@lp-lvrv.comap.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.541BAD46.00C5,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 5
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

On 09/17/2014 08:22 AM, Rostislav Lisovy wrote:
> Hello Guenter;
> Thanks for the review.
>
> On Út, 2014-09-16 at 08:49 -0700, Guenter Roeck wrote:
>> How do you know that the watchdog was already running ?
>> Seems to me you are just making an assumption that it is running
>> without really knowing for sure.
>
> You are definitely right, however the OMAP Watchdog seems to be such a
> sophisticated piece of hardware that there is no possible way how to
> determine if it is running or not (sampling timer counter twice and
> comparing both values is they differ is stupid).
>
How about reading the OMAP_WATCHDOG_SPR register ?

Either case, you can not issue a message about the watchdog being
stopped or started if you don't know if it was actually stopped
or started. Also, if you don't really know if the watchdog was
stopped or started, all you can do is to either stop or start it,
without judgment about its previous condition.

Guenter

