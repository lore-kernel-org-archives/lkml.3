Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaAHRno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 12:43:44 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:58270 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbaAHRnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 12:43:42 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <201401081709.s08H9nMr038265@swsrvapps-02.lan>
References: <201401081709.s08H9nMr038265@swsrvapps-02.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH V1] input: fix memory leak in da9052 touchscreen driver
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Wed, 08 Jan 2014 09:26:16 -0800
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Huqiu Liu <liuhq11@mails.tsinghua.edu.cn>,
        David Dajun Chen <david.chen@diasemi.com>
Message-ID: <7aad8e91-f5d9-4527-8a94-bc038a9ccd85@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Olech <anthony.olech.opensource@diasemi.com> wrote:
>The touchscreen component driver for the da9052/3 Dialog PMICs
>leaks memory by not freeing the input device in the remove call.
>
>This patch matches the existing call to input_alloc_device()
>in da9052_ts_probe() to a new call to input_free_device() in
>da9052_ts_remove()
>
>Suggested-by: Huqiu Liu <liuhq11@mails.tsinghua.edu.cn>
>Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
>---
>This patch is relative to linux-next repository tag next-20140108
>
>Many thanks to Huqiu Liu who found the bug.

No, this is not a bug. Please refer to input API spec in input.h

Thanks.

>
> drivers/input/touchscreen/da9052_tsi.c |    2 ++
> 1 file changed, 2 insertions(+)
>
>diff --git a/drivers/input/touchscreen/da9052_tsi.c
>b/drivers/input/touchscreen/da9052_tsi.c
>index ab64d58..43a69d1 100644
>--- a/drivers/input/touchscreen/da9052_tsi.c
>+++ b/drivers/input/touchscreen/da9052_tsi.c
>@@ -320,6 +320,7 @@ err_free_mem:
> static int  da9052_ts_remove(struct platform_device *pdev)
> {
> 	struct da9052_tsi *tsi = platform_get_drvdata(pdev);
>+	struct input_dev *input_dev = tsi->dev;
> 
> 	da9052_reg_write(tsi->da9052, DA9052_LDO9_REG, 0x19);
> 
>@@ -328,6 +329,7 @@ static int  da9052_ts_remove(struct platform_device
>*pdev)
> 
> 	input_unregister_device(tsi->dev);
> 	kfree(tsi);
>+	input_free_device(input_dev);
> 
> 	return 0;
> }


-- 
Dmitry
