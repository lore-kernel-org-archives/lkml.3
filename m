Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbaCKGq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 02:46:27 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:41207 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbaCKGqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 02:46:25 -0400
Date: Tue, 11 Mar 2014 06:46:20 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, sbkim73@samsung.com
Subject: Re: [PATCH] drivers: mfd: silence compiler warning in sec-core.c
Message-ID: <20140311064620.GC2839@lee--X1>
References: <1394017159-4851-1-git-send-email-pankaj.dubey@samsung.com>
 <20140310150700.GC13661@lee--X1>
 <531E74CF.7000602@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <531E74CF.7000602@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>When used 64bit compiler GCC warns as
> >>drivers/mfd/sec-core.c:199:10: warning:
> >>cast from pointer to integer of different size [-Wpointer-to-int-cast]
> >>
> >>This patch fixes this by type-casting "match->data" into "long" before
> >>converting into "int"
> >>
> >>Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> >>---
> >>  drivers/mfd/sec-core.c |    2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >>diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
> >>index a139798..2e7580bd 100644
> >>--- a/drivers/mfd/sec-core.c
> >>+++ b/drivers/mfd/sec-core.c
> >>@@ -187,7 +187,7 @@ static inline int sec_i2c_get_driver_data(struct i2c_client *i2c,
> >>  	if (i2c->dev.of_node) {
> >>  		const struct of_device_id *match;
> >>  		match = of_match_node(sec_dt_match, i2c->dev.of_node);
> >>-		return (int)match->data;
> >>+		return (int)(long)match->data;
> >I think using an unsigned long would be better.
> 
> I could have done that but since "sec_i2c_get_driver_data" return type is
> "int" for me it make sense to return "int", and it does not make much sense
> to change this function signature as return value is used only for getting
> variant type. Also same has been done in "max8998_i2c_get_driver_data", if
> you still think it's better to typecast into "unsigned long" or
> "kernel_ulong_t" please let me know I will change accordingly.

I'd prefer to change the whole thing to unsigned long, based only on
the fact that a) it's a trivial piece of work and b) for consistency
with other MFD drivers who have recently suffered the same issues.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
