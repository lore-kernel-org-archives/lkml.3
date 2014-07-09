Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641AbaGIB1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 21:27:41 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63547 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbaGIB1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 21:27:39 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53BC9A89.20809@roeck-us.net>
Date: Tue, 08 Jul 2014 18:27:37 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
CC: torvalds@linux-foundation.org, Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        akpm@linux-foundation.org
Subject: Re: [PATCH 3.2 000/125] 3.2.61-rc1 review
References: <lsq.1404846109.699842714@decadent.org.uk>
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2014 12:01 PM, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.2.61 release.
> There are 125 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Jul 10 19:01:49 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 109 pass: 71 fail: 38
Failed builds:
	alpha:allmodconfig
	arm:defconfig
	arm:imx_v4_v5_defconfig
	arm:mxs_defconfig
	arm:dove_defconfig
	arm:kirkwood_defconfig
	arm:omap2plus_defconfig
	arm:tegra_defconfig
	arm:u8500_defconfig
	arm:at91sam9rl_defconfig
	arm:pxa910_defconfig
	arm:mackerel_defconfig
	arm:ixp4xx_defconfig
	arm:vexpress_defconfig
	arm:msm_defconfig
	arm:at91rm9200_defconfig
	arm:at91sam9263_defconfig
	arm:at91sam9g45_defconfig
	arm:assabet_defconfig
	i386:defconfig
	i386:allyesconfig
	i386:allmodconfig
	m32r:defconfig
	microblaze:mmu_defconfig
	microblaze:nommu_defconfig
	mips:defconfig
	mips:allmodconfig
	mips:bcm47xx_defconfig
	mips:bcm63xx_defconfig
	mips:ar7_defconfig
	mips:fuloong2e_defconfig
	mips:malta_defconfig
	score:defconfig
	sparc64:allmodconfig
	um:defconfig
	unicore32:defconfig
	xtensa:defconfig
	xtensa:allmodconfig

Qemu images fail to build for mips, mips64, and x86.

Build error seems to be always the same.

lib/nlattr.c: In function 'nla_parse':
lib/nlattr.c:201:3: error: dereferencing pointer to incomplete type
make[1]: *** [lib/nlattr.o] Error 1

Culprit is bfc5184b69 (netlink: rate-limit leftover bytes warning
and print process name). In 3.2, it is necessary to include <linux/sched.h>
explicitly to get the definition of 'struct task_struct'.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter

