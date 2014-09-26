Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbaIZFvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 01:51:38 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:51754 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbaIZFvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 01:51:37 -0400
Message-ID: <5424FEE0.2020806@roeck-us.net>
Date: Thu, 25 Sep 2014 22:51:28 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Wim Van Sebroeck <wim@iguana.be>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Carlo Caione <carlo@caione.org>
Subject: Re: linux-next: build failure after merge of the watchdog tree
References: <20140926154031.4bc4dc39@canb.auug.org.au>
In-Reply-To: <20140926154031.4bc4dc39@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.5424FEE8.00C9,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 09/25/2014 10:40 PM, Stephen Rothwell wrote:
> Hi Wim,
>
> After merging the watchdog tree, today's linux-next build (arm
> multi_v7_defconfig) failed like this:
>
>
> drivers/watchdog/meson_wdt.c: In function 'meson_wdt_probe':
> drivers/watchdog/meson_wdt.c:178:2: error: implicit declaration of function 'register_restart_handler' [-Werror=implicit-function-declaration]
>    err = register_restart_handler(&meson_wdt->restart_handler);
>    ^
> drivers/watchdog/meson_wdt.c: In function 'meson_wdt_remove':
> drivers/watchdog/meson_wdt.c:193:2: error: implicit declaration of function 'unregister_restart_handler' [-Werror=implicit-function-declaration]
>    unregister_restart_handler(&meson_wdt->restart_handler);
>    ^
>
> Caused by commit 575f4153957b ("ARM: meson: add watchdog driver").
>
> I have reverted that commit for today.
>

Those functions are defined by patches which reside in Andrew's tree.
Is that merged later ?

Guenter

