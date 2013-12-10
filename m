Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab3LJIpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:45:08 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:33968 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab3LJIpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:45:05 -0500
Message-ID: <52A6D48A.4000507@linaro.org>
Date: Tue, 10 Dec 2013 16:44:58 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        preeti@linux.vnet.ibm.com, "len.brown@intel.com" <len.brown@intel.com>
Subject: Re: questions of cpuidle
References: <52A5C846.30308@linaro.org> <52A5D0E0.7050201@linaro.org> <52A6B5BB.3060506@linaro.org> <52A6C24B.3030800@linaro.org>
In-Reply-To: <52A6C24B.3030800@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 03:27 PM, Daniel Lezcano wrote:
> 
>> And does the wake up pass via GIC to CPU? If so, does the GIC need
>> keep awake when all cpu idle? If not, how the firmware give the
>> interrupt to CPU? And I am wondering if the deep idle cpu voltage get
>> to near 0. How the cpu get the interrupt signal?
> 
> If a deep idle state powers down the GIC, it is up to the PMU to proxy
> the interrupts. When an interrupt occurs, the PMU powers up the logic,
> including the GIC. The notifier call chain with cpu_suspend / cpu_resume
> will save and restore the GIC registers.
> 
> But this is hardware specific and will depend on how the PMU is
> implemented and how far it goes in the power management.
> 
> You have a good example in the drivers/cpuidle/cpuidle-ux500.c to
> understand with the comments how the interrupts are handled through the
> power management unit.
> 
> In the Xillinx documentation available on the web [1], the chapter 24.4
> gives the information about one kind of PMU.
> 
> I believe the mechanism is pretty similar on all the hardware but it is
> obfuscated by a generic power instruction like mwait.
> 
>   -- Daniel
> 
> [1]
> http://www.xilinx.com/support/documentation/user_guides/ug585-Zynq-7000-TRM.pdf
> 

Thanks a lot, Daniel. You are a expert of ARM cpu idle! :)

-- 
Thanks
    Alex
