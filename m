Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab3CNMKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 08:10:17 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:39679 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab3CNMKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 08:10:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130314105155.GG32369@arwen.pp.htv.fi>
References: <1363257898-17504-1-git-send-email-gautam.vivek@samsung.com>
	<1363257898-17504-2-git-send-email-gautam.vivek@samsung.com>
	<20130314105155.GG32369@arwen.pp.htv.fi>
Date: Thu, 14 Mar 2013 17:40:12 +0530
Message-ID: <CAFp+6iHZRfiSAXnbwhFNs4Rm7fzFx=v83pcWFJHsOo+JPya6VQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] usb: dwc3: exynos: Use of_platform API to create dwc3
 core pdev
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: balbi@ti.com
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        gregkh@linuxfoundation.org, rob.herring@calxeda.com,
        kgene.kim@samsung.com, thomas.abraham@linaro.org,
        dianders@chromium.org, Kishon Vijay Abraham I <kishon@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 4:21 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Thu, Mar 14, 2013 at 04:14:57PM +0530, Vivek Gautam wrote:
>> @@ -170,7 +155,6 @@ static int dwc3_exynos_remove(struct platform_device *pdev)
>>  {
>>       struct dwc3_exynos      *exynos = platform_get_drvdata(pdev);
>>
>> -     platform_device_unregister(exynos->dwc3);
>
> don't you want to do what Kishon did here and have:
>
> static int dwc3_exynos_remove_child(struct device *dev, void *unused)
> {
>         struct platform_device  *pdev = to_platform_device(dev);
>
>         platform_device_unregister(pdev);
>
>         return 0;
> }
>
> device_for_each_child(&pdev->dev, NULL, dwc3_exynos_remove_child);
>
> ???

Hmm, right. We need to do that. :-)

>
> --
> balbi



-- 
Thanks & Regards
Vivek
