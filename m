Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbaKRRBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:01:55 -0500
Received: from service87.mimecast.com ([91.220.42.44]:56196 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbaKRRBx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:01:53 -0500
Message-ID: <546B7B8D.1070201@arm.com>
Date: Tue, 18 Nov 2014 17:02:05 +0000
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, "jcm@redhat.com" <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "Kangkang.Shen@huawei.com" <Kangkang.Shen@huawei.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v5 01/18] ARM64: Move the init of cpu_logical_map(0) before
 unflatten_device_tree()
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org> <1413553034-20956-2-git-send-email-hanjun.guo@linaro.org> <546B4D8D.2020605@linaro.org> <20141118164312.GL28279@e104818-lin.cambridge.arm.com> <20141118165713.GT18842@arm.com>
In-Reply-To: <20141118165713.GT18842@arm.com>
X-OriginalArrivalTime: 18 Nov 2014 17:01:45.0776 (UTC) FILETIME=[55A38B00:01D00351]
X-MC-Unique: 114111817014800401
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

I was writing to reply to Catalin's mail :)

On 18/11/14 16:57, Will Deacon wrote:
> On Tue, Nov 18, 2014 at 04:43:13PM +0000, Catalin Marinas wrote:
>> On Tue, Nov 18, 2014 at 01:45:49PM +0000, Hanjun Guo wrote:
>>> On 2014年10月17日 21:36, Hanjun Guo wrote:
>>>> It always make sense to initialize CPU0's logical map entry from the
>>>> hardware values, so move the initialization of cpu_logical_map(0)
>>>> before unflatten_device_tree() which is needed by ACPI code later.
>>>>
>>>> Acked-by: Olof Johansson <olof@lixom.net>
>>>> Acked-by: Mark Rutland <mark.rutland@arm.com>
>>>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>>>
>>> Could you merge this patch first in 3.19? It was acked by Olof and
>>> Mark, and it will make sense without ACPI too.
>>
>> I think it can go in for 3.19 (it's Will's turn this time ;)).
>
> This patch doesn't apply on for-next/core, as it conflicts with some of
> Rutland's rework ("arm64: log physical ID of boot CPU").
>

It's actually not required anymore, as "arm64: log physical ID of boot
CPU" move it quite early in the sequence from setup_arch to
smp_setup_processor_id while this patch just moves it up in setup_arch.

Regards,
Sudeep


