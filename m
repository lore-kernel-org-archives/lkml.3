Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaEHFuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 01:50:32 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:53140 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbaEHFua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 01:50:30 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s485o1Zl027490, This message is accepted by code: ctloc85258
Message-ID: <536B1C0A.2050001@realsil.com.cn>
Date: Thu, 8 May 2014 13:54:18 +0800
From: micky <micky_ching@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Chris Ball <chris@printf.net>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>, Roger <rogerable@realtek.com>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: Re: [PATCH 2/2] mmc: rtsx: Revert "mmc: rtsx: add support for pre_reqandpost_req"
References: <cover.1398735435.git.micky_ching@realsil.com.cn>	<6a8f18cad47244e849adf8a731c621932fa777e0.1398735435.git.micky_ching@realsil.com.cn> <CAPDyKFqSdvjJrsbDeX1KbjQtOjfoAwC0xz3y7Rm-BsD0T8tmxg@mail.gmail.com>
In-Reply-To: <CAPDyKFqSdvjJrsbDeX1KbjQtOjfoAwC0xz3y7Rm-BsD0T8tmxg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee

Sorry for previous email, only [PATCH 2/2] mmc: rtsx: Revert "mmc: rtsx: 
add support for pre_reqand post_req"
if need for 3.15 fix.

Best Regards.
micky.
On 04/29/2014 03:36 PM, Ulf Hansson wrote:
> On 29 April 2014 03:54,<micky_ching@realsil.com.cn>  wrote:
>> >From: Micky Ching<micky_ching@realsil.com.cn>
>> >
>> >This reverts commit c42deffd5b53c9e583d83c7964854ede2f12410d.
>> >
>> >commit <mmc: rtsx: add support for pre_req and post_req> did use
>> >mutex_unlock() in tasklet, but mutex_unlock() can't used in
>> >tasklet(atomic context). The driver need use mutex to avoid concurrency,
>> >so we can't use tasklet here, the patch need to be removed.
>> >
>> >The spinlock host->lock and pcr->lock may deadlock, one way to solve the
>> >deadlock is remove host->lock in sd_isr_done_transfer(), but if using
>> >workqueue the we can avoid using the spinlock and also avoid the problem.
>> >
>> >Signed-off-by: Micky Ching<micky_ching@realsil.com.cn>
> Acked-by: Ulf Hansson<ulf.hansson@linaro.org>
>

