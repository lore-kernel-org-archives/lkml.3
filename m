Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236AbaD1K6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:58:24 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:49414 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848AbaD1K6V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:58:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140428105350.GM21279@lee--X1>
References: <1398670584-26687-1-git-send-email-micky_ching@realsil.com.cn>
	<20140428105350.GM21279@lee--X1>
Date: Mon, 28 Apr 2014 12:58:20 +0200
Message-ID: <CAPDyKFr6kNjfE+adx_j05wes0Y1fg=zD-AwciWy0vQdw=DbOrg@mail.gmail.com>
Subject: Re: [PATCH] mmc: rtsx: Revert "mmc: rtsx: add support for pre_req and post_req"
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: micky <micky_ching@realsil.com.cn>, Chris Ball <chris@printf.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@linuxdriverproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>, Roger <rogerable@realtek.com>,
        Wei WANG <wei_wang@realsil.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 April 2014 12:53, Lee Jones <lee.jones@linaro.org> wrote:
>> From: Micky Ching <micky_ching@realsil.com.cn>
>>
>> This reverts commit c42deffd5b53c9e583d83c7964854ede2f12410d.
>
> Why was this patch even merged without an MFD Ack?
>
>> commit <mmc: rtsx: add support for pre_req and post_req> did use
>> mutex_unlock() in tasklet, but mutex_unlock() can't used in
>> tasklet(atomic context). The driver need use mutex to avoid concurrency,
>> so we can't use tasklet here, the patch need to be removed.
>>
>> The spinlock host->lock and pcr->lock may deadlock, one way to solve the
>> deadlock is remove host->lock in sd_isr_done_transfer(), but if using
>> workqueue the we can avoid using the spinlock and also avoid the problem.
>>
>> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
>> ---
>>  drivers/mfd/rtsx_pcr.c            |  132 ++++--------
>>  drivers/mmc/host/rtsx_pci_sdmmc.c |  418 ++++++-------------------------------
>>  include/linux/mfd/rtsx_common.h   |    1 -
>>  include/linux/mfd/rtsx_pci.h      |    6 -
>>  4 files changed, 109 insertions(+), 448 deletions(-)
>
> This patch should be sent to the -rcs as soon as possible:

Do you mind helping out doing it here Lee? Not sure how busy Chris is
at the moment.

Kind regards
Ulf Hansson

>
> Acked-by: Lee Jones <lee.jones@linaro.org>
>
> --
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
