Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831Ab3CNN0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 09:26:07 -0400
Received: from service87.mimecast.com ([91.220.42.44]:50481 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757749Ab3CNN0F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 09:26:05 -0400
Message-ID: <5141CFE4.2030909@arm.com>
Date: Thu, 14 Mar 2013 13:25:56 +0000
From: Jonathan Austin <jonathan.austin@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "nico@linaro.org" <nico@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [Suggestion] Latest randconfig build errors for CONFIG_MMU=no
References: <514147A0.2060002@asianux.com>
In-Reply-To: <514147A0.2060002@asianux.com>
X-OriginalArrivalTime: 14 Mar 2013 13:26:01.0234 (UTC) FILETIME=[7874AF20:01CE20B7]
X-MC-Unique: 113031413260303601
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chen,

On 14/03/13 03:44, Chen Gang wrote:
> Hello Maintainers:
>
>    when use randconfig:
>      make V=1 EXTRA_CFLAGS=-W ARCH=arm randconfig
>        (and "grep CONFIG_MMU .config" outputs "# CONFIG_MMU is not set")
>
>    the error information:
>      arch/arm/kernel/suspend.c: 在函数‘cpu_suspend’中:
>      arch/arm/kernel/suspend.c:56:32: 错误：提领指向不完全类型的指针
>      arch/arm/kernel/suspend.c:70:3: 错误：隐式声明函数‘cpu_switch_mm’ [-Werror=implicit-function-declaration]
>      arch/arm/kernel/suspend.c:71:3: 错误：隐式声明函数‘local_flush_bp_all’ [-Werror=implicit-function-declaration]
>      arch/arm/kernel/suspend.c:72:3: 错误：隐式声明函数‘local_flush_tlb_all’ [-Werror=implicit-function-declaration]
>
>    I want to be sure whether we can bear it ?
>

You're right that at the moment that suspend code is broken for NOMMU.

However, Will Deacon has a patch to fix it in his nommu branch on 
kernel.org:

https://git.kernel.org/cgit/linux/kernel/git/will/linux.git/commit/?h=nommu

I'll let Will comment on how/when he might look at proposing that code 
to be merged.

Jonny


