Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbaKSPwL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:52:11 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:39529 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbaKSPwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:52:08 -0500
Date: Wed, 19 Nov 2014 15:52:01 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Maxime Coquelin <maxime.coquelin@st.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        edubezval@gmail.com, kernel@stlinux.com, linux-pm@vger.kernel.org
Subject: Re: [STLinux Kernel] [PATCH] thermal: sti: Ignore suspend/resume
 functions when !PM
Message-ID: <20141119155201.GC1875@x1>
References: <1416404939-365-1-git-send-email-lee.jones@linaro.org>
 <546CAC92.3020504@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <546CAC92.3020504@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014, Maxime Coquelin wrote:

> 
> On 11/19/2014 02:48 PM, Lee Jones wrote:
> >Prevents build warning:
> >
> >st_thermal.c:278:12:
> >     warning: ‘st_thermal_suspend’ defined but not used [-Wunused-function]
> >st_thermal.c:286:12:
> >     warning: ‘st_thermal_resume’ defined but not used [-Wunused-function]
> >
> >Signed-off-by: Lee Jones <lee.jones@linaro.org>
> You can add my:
> Acked-by: Maxime Coquelin <maxime.coquelin@st.com>

Sorry Maxime, I made a booboo!

Resubmitted.

> >---
> >  drivers/thermal/st/st_thermal.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> >diff --git a/drivers/thermal/st/st_thermal.c b/drivers/thermal/st/st_thermal.c
> >index 90163b3..9841488 100644
> >--- a/drivers/thermal/st/st_thermal.c
> >+++ b/drivers/thermal/st/st_thermal.c
> >@@ -275,6 +275,7 @@ int st_thermal_unregister(struct platform_device *pdev)
> >  }
> >  EXPORT_SYMBOL_GPL(st_thermal_unregister);
> >+#ifdef CONFIG_PM
> >  static int st_thermal_suspend(struct device *dev)
> >  {
> >  	struct platform_device *pdev = to_platform_device(dev);
> >@@ -305,6 +306,8 @@ static int st_thermal_resume(struct device *dev)
> >  	return 0;
> >  }
> >+#endif
> >+
> >  SIMPLE_DEV_PM_OPS(st_thermal_pm_ops, st_thermal_suspend, st_thermal_resume);
> >  EXPORT_SYMBOL_GPL(st_thermal_pm_ops);
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
