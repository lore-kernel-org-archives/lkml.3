Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbaIZGMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 02:12:12 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:55019 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbaIZGMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 02:12:10 -0400
Message-ID: <542503B1.9090206@roeck-us.net>
Date: Thu, 25 Sep 2014 23:12:01 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: Wim Van Sebroeck <wim@iguana.be>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Carlo Caione <carlo@caione.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the watchdog tree
References: <20140926154031.4bc4dc39@canb.auug.org.au> <5424FFF4.4010506@smartplayin.com>
In-Reply-To: <5424FFF4.4010506@smartplayin.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.542503BA.0059,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 09/25/2014 10:56 PM, Pramod Gurav wrote:
> On Friday 26 September 2014 11:10 AM, Stephen Rothwell wrote:
>> Hi Wim,
>>
>> After merging the watchdog tree, today's linux-next build (arm
>> multi_v7_defconfig) failed like this:
>>
>>
>> drivers/watchdog/meson_wdt.c: In function 'meson_wdt_probe':
>> drivers/watchdog/meson_wdt.c:178:2: error: implicit declaration of function 'register_restart_handler' [-Werror=implicit-function-declaration]
>>    err = register_restart_handler(&meson_wdt->restart_handler);
>>    ^
>> drivers/watchdog/meson_wdt.c: In function 'meson_wdt_remove':
>> drivers/watchdog/meson_wdt.c:193:2: error: implicit declaration of function 'unregister_restart_handler' [-Werror=implicit-function-declaration]
>>    unregister_restart_handler(&meson_wdt->restart_handler);
>>    ^
>>
> This is because Guenter Roeck's restart_notifier mechanism [1] has not
> yet made it to linux-next.
>
No, that isn't it; it is there, coming from Andrew Morton's tree.
I think the problem is that the functions are not in Wim's tree,
and neither is ARCH_MESON. For this reason, the driver does not
build in Wim's tree, nor in my tree, which in turn explains why
we don't see the error. Maybe Stephen merges Andrew's tree after the
watchdog tree, and builds the watchdog code immediately after pulling it.
If the MESON code is already merged at that time we would see that error.

Question is how to handle that kind of situation. An idea, anyone ?

Someone suggested that I should create an immutable tree with the
restart handler patchset, which everyone using the restart handlers
could merge. Is that an option ? I could technically do that,
but I would want to pick the patches from Andrew's tree to retain
his sign-off. Andrew, any thoughts/comments ?

Thanks,
Guenter

