Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933782AbaIDBOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 21:14:31 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:11267 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933250AbaIDBO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 21:14:29 -0400
Message-ID: <5407BCAE.7030606@huawei.com>
Date: Thu, 4 Sep 2014 09:13:18 +0800
From: "long.wanglong" <long.wanglong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux@arm.linux.org.uk>, <santosh.shilimkar@ti.com>,
        <victor.kamensky@linaro.org>, <nico@linaro.org>,
        <ben.dooks@codethink.co.uk>, <cov@codeaurora.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [SMP BUG?] the return value of is_smp() is bug?
References: <1409550563-92081-1-git-send-email-long.wanglong@huawei.com> <540443DA.7030502@huawei.com> <25226905.0IHWyHSRxb@wuerfel>
In-Reply-To: <25226905.0IHWyHSRxb@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.88.174]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/1 18:26, Arnd Bergmann wrote:
> On Monday 01 September 2014 18:00:58 long.wanglong wrote:
>> On 2014/9/1 13:49, Wang Long wrote:
>>>
>>> Hi,all
>>>
>>> In kernel 3.17-rc2, when i set CONFIG_HAVE_SMP = y and CONFIG_SMP_ON_UP = y 
>>> in .config file. the secondary core can not boot.
>>>
>>> when i set CONFIG_HAVE_SMP = y and CONFIG_SMP_ON_UP = n in .config file,
>>> the secondary core can boot.
>>>
>>> But this does not happen in kernel 3.10 lts kernel, Whether the 
>>> CONFIG_SMP_ON_UP is set yes or no ,the secondary core can boot.
>>>
>>> Does the meaning of CONFIG_SMP_ON_UP changed or this is a bug in kernel 3.17-rc2 ? 
>>>
>>>
>>
>> hi Arnd
>>
>> In above two cases, i also set  CONFIG_SMP = y. in addtion,
>> the CONFIG_SMP_ON_UP depends on CONFIG_SMP. when set
>> CONFIG_SMP_ON_UP = y, the value of CONFIG_SMP must be y.
> 
> I see.
> 
> I'm looking at the code more closely now:
> 
>>> config:     set CONFIG_HAVE_SMP = y and CONFIG_SMP_ON_UP = y
>>> command:    # qemu-system-arm -M vexpress-a9 -smp 2  -m 128M -kernel arch/arm/boot/zImage -nographic
>>> The output:
>>>
>>> ..........
>>> is_smp() return false;
> 
> This test basically checks whether the __fixup_smp_on_up code was
> run or not. This has changed in bc41b8724f24 "ARM: 7846/1: Update
> SMP_ON_UP code to detect A9MPCore with 1 CPU devices", in order
> to support a quirk in the Aegis platform. Can you try reverting
> that commit?
> 
> 	Arnd
> 
> .
> 


Hi Arnd

When i revert the commit bc41b8724f24, the secondary core can boot.
The problem is that qemu doesn't provide emulation of the SCU base
address register. When reading the SCU base, qemu just return 0.

In the real hardware, there is no this problem.

