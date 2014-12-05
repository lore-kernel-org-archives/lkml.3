Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbaLEVo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 16:44:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53052 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaLEVo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 16:44:56 -0500
Date: Fri, 5 Dec 2014 13:44:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefan Agner <stefan@agner.ch>
Cc: Sanchayan Maity <maitysanchayan@gmail.com>, a.zummo@towertech.it,
        rtc-linux@googlegroups.com, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCHv2] drivers/rtc/rtc-snvs: Add clock support
Message-Id: <20141205134455.7901c40277cbc2093ccabfd2@linux-foundation.org>
In-Reply-To: <5536a0707e516d0f4a0c6eaf9d4d9291@agner.ch>
References: <cover.1417585458.git.maitysanchayan@gmail.com>
	<bf8571fc7474877be39a5a4e9d4705358e63d840.1417585458.git.maitysanchayan@gmail.com>
	<20141204161207.0753031dc675793e9534c1de@linux-foundation.org>
	<5536a0707e516d0f4a0c6eaf9d4d9291@agner.ch>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Dec 2014 15:54:15 +0100 Stefan Agner <stefan@agner.ch> wrote:

> It can be fixed, with something like this:
> 
> @@ -346,7 +347,10 @@ static int snvs_rtc_resume(struct device *dev)
>  }
>  #endif
>  
> -static SIMPLE_DEV_PM_OPS(snvs_rtc_pm_ops, snvs_rtc_suspend,
> snvs_rtc_resume);
> +static const struct dev_pm_ops snvs_rtc_pm_ops = {
> +       .suspend_noirq = snvs_rtc_suspend,
> +       .resume_noirq = snvs_rtc_resume,
> +};
>  
>  static const struct of_device_id snvs_dt_ids[] = {
>         { .compatible = "fsl,sec-v4.0-mon-rtc-lp", },
> 
> 
> 
> Andrew, this patch is already merged, so it would need another fix for
> this, right?

A replacement patch is OK.  An incremental patch is OK too.  I almost
always turn the replacement into an incremental so that I and others
can see what changed.
