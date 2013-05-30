Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030570Ab3E3Kzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 06:55:53 -0400
Received: from server19320154104.serverpool.info ([193.201.54.104]:56681 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968185Ab3E3Kzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 06:55:43 -0400
Message-ID: <51A73026.3030200@hauke-m.de>
Date: Thu, 30 May 2013 12:55:34 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: Libo Chen <clbchenlibo.chen@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        artem.bityutskiy@linux.intel.com, Bill Pemberton <wfp5p@virginia.edu>,
        linux-mtd@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH RESEND 2/2] mtd: bcm47: convert to module_platform_driver
 instead of init/exit
References: <51A6B7D8.8090600@huawei.com> <CAHp75Vc9mYmUM4pmeKLBzxNFsx-xiSez6oxC1F5+Hh-hPXto5A@mail.gmail.com>
In-Reply-To: <CAHp75Vc9mYmUM4pmeKLBzxNFsx-xiSez6oxC1F5+Hh-hPXto5A@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2013 12:30 PM, Andy Shevchenko wrote:
> On Thu, May 30, 2013 at 5:22 AM, Libo Chen <clbchenlibo.chen@huawei.com> wrote:
>>
>> convert to module_platform_driver instead of init/exit
> 
> I give another thought about it. We have to be sure that the flash
> device will be online when it's really needed.
> module_init initcall is quite far in the boot process. Is it what we want?

This is no problem, the flash driver is needed when the root file system
is mounted. The arch code reads the SoC configuration values in its own
code in arch/mips/bcm47xx/nvram.c without using the mtd subsystem. These
values are needed very early in the boot process.

Hauke
