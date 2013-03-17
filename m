Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab3CQOk7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 10:40:59 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43877 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756360Ab3CQOk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 10:40:58 -0400
Date: Sun, 17 Mar 2013 14:40:30 +0000
From: Will Deacon <will.deacon@arm.com>
To: Jonathan Austin <Jonathan.Austin@arm.com>
Cc: Chen Gang <gang.chen@asianux.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "nico@linaro.org" <nico@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Suggestion] Latest randconfig build errors for CONFIG_MMU=no
Message-ID: <20130317144030.GF19071@mudshark.cambridge.arm.com>
References: <514147A0.2060002@asianux.com>
 <5141CFE4.2030909@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5141CFE4.2030909@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 01:25:56PM +0000, Jonathan Austin wrote:
> On 14/03/13 03:44, Chen Gang wrote:
> > Hello Maintainers:
> >
> >    when use randconfig:
> >      make V=1 EXTRA_CFLAGS=-W ARCH=arm randconfig
> >        (and "grep CONFIG_MMU .config" outputs "# CONFIG_MMU is not set")
> >
> >    the error information:
> >      arch/arm/kernel/suspend.c: 在函数‘cpu_suspend’中:
> >      arch/arm/kernel/suspend.c:56:32: 错误：提领指向不完全类型的指针
> >      arch/arm/kernel/suspend.c:70:3: 错误：隐式声明函数‘cpu_switch_mm’ [-Werror=implicit-function-declaration]
> >      arch/arm/kernel/suspend.c:71:3: 错误：隐式声明函数‘local_flush_bp_all’ [-Werror=implicit-function-declaration]
> >      arch/arm/kernel/suspend.c:72:3: 错误：隐式声明函数‘local_flush_tlb_all’ [-Werror=implicit-function-declaration]
> >
> >    I want to be sure whether we can bear it ?
> >
> 
> You're right that at the moment that suspend code is broken for NOMMU.
> 
> However, Will Deacon has a patch to fix it in his nommu branch on 
> kernel.org:
> 
> https://git.kernel.org/cgit/linux/kernel/git/will/linux.git/commit/?h=nommu
> 
> I'll let Will comment on how/when he might look at proposing that code 
> to be merged.

I can probably bring that up to speed with -rc2 if people are interested.
The tricky part is testing -- I used a software model that had a magic
control block for killing off CPUs when I wrote this originally.

Will
