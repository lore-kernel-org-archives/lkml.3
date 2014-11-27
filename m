Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbaK0UPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 15:15:17 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:51781 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbaK0UPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 15:15:12 -0500
Message-ID: <54778649.8000408@roeck-us.net>
Date: Thu, 27 Nov 2014 12:15:05 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: lizf@kernel.org, stable@vger.kernel.org
CC: linux-kernel@vger.kernel.org, satoru.takeuchi@gmail.com,
        Zefan Li <lizefan@huawei.com>
Subject: Re: [PATCH 3.4 00/91] 3.4.105-rc1 review
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.5477864F.0217,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 11/27/2014 12:36 AM, lizf@kernel.org wrote:
> From: Zefan Li <lizefan@huawei.com>
>
> This is the start of the stable review cycle for the 3.4.105 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by 2014年 11月 29日 星期六 08:05:38 UTC.
> Anything received after that time might be too late.
>

Build results:
	total: 119 pass: 114 fail: 5
Failed builds:
	arm:s3c6400_defconfig
	arm:nhk8815_defconfig
	score:defconfig
	sparc64:allmodconfig
	xtensa:allmodconfig

Qemu test results:
	total: 23 pass: 22 fail: 1
Failed tests:
	arm:arm_versatile_defconfig

The arm build failures are due to

Inconsistent kallsyms data
This is a bug - please report about it
Try make KALLSYMS_EXTRA_PASS=1 as a workaround
make: *** [vmlinux] Error 1

This seems to be toolchain related. I switched from the cross toolchain
provided with yocto 1.4.2 to the toolchain provided with yocto 1.7.
This seems to fix the problem. Just mentioning it here in case someone
uses an older toolchain.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter

