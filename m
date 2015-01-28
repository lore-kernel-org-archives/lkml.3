Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933229AbbA2CHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:07:36 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:42082 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbbA2CHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:07:32 -0500
Message-ID: <54C8EE4B.20502@roeck-us.net>
Date: Wed, 28 Jan 2015 06:12:27 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: lizf@kernel.org, stable@vger.kernel.org
CC: linux-kernel@vger.kernel.org, satoru.takeuchi@gmail.com,
        Zefan Li <lizefan@huawei.com>
Subject: Re: [PATCH 3.4 000/177] 3.4.106-rc1 review
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.54C8EE5E.0189,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
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

On 01/27/2015 08:07 PM, lizf@kernel.org wrote:
> From: Zefan Li <lizefan@huawei.com>
>
> This is the start of the stable review cycle for the 3.4.106 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri Jan 30 03:58:34 UTC 2015.
> Anything received after that time might be too late.
>

Build results:
	total: 119 pass: 113 fail: 6
Failed builds:
	mips:allmodconfig
	powerpc:allmodconfig (binutils 2.23 and 2.24)
	score:defconfig
	sparc64:allmodconfig
	xtensa:allmodconfig

Qemu tests:
	total: 23 pass: 22 fail: 1
Failed tests:
	arm:arm_versatile_defconfig

New powerpc and sparc64 build failures:

drivers/of/selftest.c: In function 'of_selftest':
drivers/of/selftest.c:218:2: error: implicit declaration of function 'of_selftest_property_match_string'

That function was renamed to of_selftest_property_string() with
'of: Fix overflow bug in string property parsing functions',
but apparently missed one caller in 3.4.

Guenter

