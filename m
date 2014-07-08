Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbaGHQDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 12:03:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:15427 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859AbaGHQDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 12:03:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,625,1400050800"; 
   d="scan'208";a="566792378"
Message-ID: <53BC164E.4040900@linux.intel.com>
Date: Wed, 09 Jul 2014 00:03:26 +0800
From: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jaehoon Chung <jh80.chung@samsung.com>, chris@printf.net,
        ulf.hansson@linaro.org, tgih.jun@samsung.com, aaron.lu@intel.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        jackey.shen@amd.com, gregkh@linuxfoundation.org
Subject: Re: One bug of SDHCI driver
References: <53B249A4.2040404@linux.intel.com> <53B57B23.4020607@linux.intel.com> <53B61403.7040602@samsung.com> <53B968EB.60401@linux.intel.com>
In-Reply-To: <53B968EB.60401@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Why add "mmc->caps2 |= MMC_CAP2_SDIO_IRQ_NOTHREAD;" ?  How to fix this bug?

Could you please give out some idea about this bug?


Thanks,
Zhonghui


On 2014/7/6 23:19, Fu, Zhonghui wrote:
> Yes, "mmc->caps2 |= MMC_CAP2_SDIO_IRQ_NOTHREAD;" of "sdhci_add_host" function in host/sdhci.c file make oops.
>
> "sdio_card_irq_get" function in core/sdio_irq.c file:
> if (!(host->caps2 & MMC_CAP2_SDIO_IRQ_NOTHREAD)) {  /* the condition is false */
>             atomic_set(&host->sdio_irq_thread_abort, 0);
>             host->sdio_irq_thread =                                               
>                 kthread_run(sdio_irq_thread, host,
>                         "ksdioirqd/%s", mmc_hostname(host));
>
>
> This will make  "host->sdio_irq_thread" a NULL pointer in "mmc_sdio_resume" functon of core/sdio.c file.
>
>
>
> Thanks,
> Zhonghui
>
>
>
> On 2014/7/4 10:40, Jaehoon Chung wrote:
>> Hi,
>>
>> just use the MMC_CAP2_SDIO_IRQ_NOTHREAD?
>>
>> if (!err && host->sdio_irq && !(host->quirks & MMC_CAP2_SDIO_IRQ_NOTHREAD))
>> 	wake_up_process(host->sdio_irq_thread);
>>
>> I didn't test this..but i believe that it will be fixed.
>>
>> Best Regards,
>> Jaehoon Chung
>>
>> On 07/04/2014 12:47 AM, Fu, Zhonghui wrote:
>>> Hi, all
>>>
>>> The statement "mmc->caps2 |= MMC_CAP2_SDIO_IRQ_NOTHREAD;" is added in "sdhci_add_host" function in host/sdhci.c file. In some cases, this will make  "host->sdio_irq_thread" a NULL pointer in "mmc_sdio_resume" functon of core/sdio.c file and lead to resume failure. Could you please give me some advice how to fix this bug?
>>>
>>>
>>>
>>> Thanks,
>>> Zhonghui
>>>
>>>
>>>
>>>
>>>
>>>

