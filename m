Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbaFPMkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 08:40:12 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:45557 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaFPMkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 08:40:11 -0400
MIME-Version: 1.0
In-Reply-To: <539EB43B.8070707@realsil.com.cn>
References: <cover.1402037562.git.micky_ching@realsil.com.cn>
	<7b58fb0b0915ea0b0838404c74ec22a3b6e5f5a8.1402037565.git.micky_ching@realsil.com.cn>
	<CAPDyKFq1wYZRbuwhLjTMbwN1KYgKuNuZDb7t8FV78Pa=W85oqg@mail.gmail.com>
	<539EB43B.8070707@realsil.com.cn>
Date: Mon, 16 Jun 2014 14:40:09 +0200
Message-ID: <CAPDyKFqKDAqvacwCVKM8KLjxfykpBq38MS_RgWCcA7+He4_S5w@mail.gmail.com>
Subject: Re: [PATCH 2/2] mmc: rtsx: add support for async request
From: Ulf Hansson <ulf.hansson@linaro.org>
To: micky <micky_ching@realsil.com.cn>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chris Ball <chris@printf.net>, devel@linuxdriverproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Roger <rogerable@realtek.com>, Wei WANG <wei_wang@realsil.com.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 June 2014 11:09, micky <micky_ching@realsil.com.cn> wrote:
> On 06/16/2014 04:42 PM, Ulf Hansson wrote:
>>>
>>> @@ -36,7 +37,10 @@ struct realtek_pci_sdmmc {
>>> >         struct rtsx_pcr         *pcr;
>>> >         struct mmc_host         *mmc;
>>> >         struct mmc_request      *mrq;
>>> >+       struct workqueue_struct *workq;
>>> >+#define SDMMC_WORKQ_NAME       "rtsx_pci_sdmmc_workq"
>>> >
>>> >+       struct work_struct      work;
>>
>> I am trying to understand why you need a work/workqueue to implement
>> this feature. Is that really the case?
>>
>> Could you elaborate on the reasons?
>
> Hi Uffe,
>
> we need return as fast as possible in mmc_host_ops request(ops->request)
> callback,
> so the mmc core can continue handle next request.
> when next request everything is ready, it will wait previous done(if not
> done),
> then call ops->request().
>
> we can't use atomic context, because we use mutex_lock() to protect

ops->request should never executed in atomic context. Is that your concern?

> resource, and we have to hold the lock during handle request.
> So I use workq, we just queue a work and return in ops->request(),
> The mmc core can continue without blocking at ops->request().
>
> Best Regards.
> micky.

Kind regards
Uffe
