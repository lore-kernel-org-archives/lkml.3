Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbaJDDQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 23:16:52 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:35981 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799AbaJDDQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 23:16:50 -0400
Message-ID: <542F6694.5020103@roeck-us.net>
Date: Fri, 03 Oct 2014 20:16:36 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.14 000/238] 3.14.20-stable review
References: <20141003212913.680985295@linuxfoundation.org>
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Suspect
X-CTCH-VOD: Unknown
X-CTCH-Flags: 512
X-CTCH-RefID: str=0001.0A020209.542F66A2.0040,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=512,sb=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 6
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 6
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

On 10/03/2014 02:28 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.14.20 release.
> There are 238 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Oct  5 21:28:26 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 137 pass: 135 fail: 2
Failed builds:
	arm:omap2plus_defconfig
	arm:multi_v7_defconfig

Qenu test results:
	total: 28 pass: 28 fail: 0

---
Build error:

arch/arm/mach-omap2/omap_hwmod_7xx_data.c: In function 'dra7xx_hwmod_init':
arch/arm/mach-omap2/omap_hwmod_7xx_data.c:2735:2: error: implicit declaration of function 'soc_is_dra74x'
arch/arm/mach-omap2/omap_hwmod_7xx_data.c:2737:2: error: implicit declaration of function 'soc_is_dra72x'


Culprit:

'ARM: DRA7: hwmod: Add dra74x and dra72x specific ocp interface lists'

Needs patch af438fec6cb9 ("ARM: DRA7: Add support for soc_is_dra74x() and soc_is_dra72x() variants")
as prerequisit.

Same problem is in 3.16 as well.

Guenter

