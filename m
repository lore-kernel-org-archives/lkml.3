Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbaEEJbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 05:31:32 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:53921 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517AbaEEJb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 05:31:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDyKFqSdvjJrsbDeX1KbjQtOjfoAwC0xz3y7Rm-BsD0T8tmxg@mail.gmail.com>
References: <cover.1398735435.git.micky_ching@realsil.com.cn>
	<6a8f18cad47244e849adf8a731c621932fa777e0.1398735435.git.micky_ching@realsil.com.cn>
	<CAPDyKFqSdvjJrsbDeX1KbjQtOjfoAwC0xz3y7Rm-BsD0T8tmxg@mail.gmail.com>
Date: Mon, 5 May 2014 11:31:28 +0200
Message-ID: <CAPDyKFoEWkzHDfPn3BXVuXFMcfsLFtZdvsV36a7ic0DjCgu+NA@mail.gmail.com>
Subject: Re: [PATCH 2/2] mmc: rtsx: Revert "mmc: rtsx: add support for pre_req
 and post_req"
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Chris Ball <chris@printf.net>, micky <micky_ching@realsil.com.cn>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@linuxdriverproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>, Roger <rogerable@realtek.com>,
        Wei WANG <wei_wang@realsil.com.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 April 2014 09:36, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> On 29 April 2014 03:54,  <micky_ching@realsil.com.cn> wrote:
>> From: Micky Ching <micky_ching@realsil.com.cn>
>>
>> This reverts commit c42deffd5b53c9e583d83c7964854ede2f12410d.
>>
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
>
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Hi Lee,

Would you mind to pick this up and send it for 3.15 fixes?

The other revert "[PATCH 1/2] mmc: rtsx: Revert "mmc: rtsx: modify
error handle and remove smatch warnings", needs to go through the mmc
tree.

Kind regards
Uffe
