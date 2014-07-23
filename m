Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758515AbaGWXIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 19:08:48 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:61423 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaGWXIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 19:08:47 -0400
MIME-Version: 1.0
In-Reply-To: <1406156581-6052-1-git-send-email-xerofoify@gmail.com>
References: <1406156581-6052-1-git-send-email-xerofoify@gmail.com>
Date: Thu, 24 Jul 2014 01:08:46 +0200
Message-ID: <CAFLxGvz3bVUrzqVSE9rfX4HA-3amXE1BgLHvx69DstBTY+2ZrA@mail.gmail.com>
Subject: Re: [PATCH] staging: Change kzalloc to kcalloc
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, John Stultz <john.stultz@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Chen Gang <gang.chen.5i5j@gmail.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Dan Carpenter <dan.carpenter@oracle.com>, tomas.winkler@intel.com,
        devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 1:03 AM, Nicholas Krause <xerofoify@gmail.com> wrote:
> This changes the call to kzalloc to kcalloc in ion_dummy_driver
> for allocating the heap.
>
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/staging/android/ion/ion_dummy_driver.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/android/ion/ion_dummy_driver.c b/drivers/staging/android/ion/ion_dummy_driver.c
> index 3a45e79..8883432 100644
> --- a/drivers/staging/android/ion/ion_dummy_driver.c
> +++ b/drivers/staging/android/ion/ion_dummy_driver.c
> @@ -67,9 +67,8 @@ static int __init ion_dummy_init(void)
>  {
>         int i, err;
>
>         idev = ion_device_create(NULL);
> -       heaps = kzalloc(sizeof(struct ion_heap *) * dummy_ion_pdata.nr,
> -                       GFP_KERNEL);
> +       heaps = kcalloc(*dummy_ion_pdata.nr , sizeof((struct ion_heap *) *dummy_ion_pdata.nr) , GFP_KERNEL);

Nick, please go away.
Your patches are threat to Linux.

-- 
Thanks,
//richard
