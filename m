Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbaKIWZf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 17:25:35 -0500
Received: from coldplug.net ([109.75.184.172]:41861 "EHLO
	external.coldplug.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaKIWZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 17:25:34 -0500
Message-ID: <545FE821.5060107@coldplug.net>
Date: Sun, 09 Nov 2014 23:18:09 +0100
From: lautriv <lautriv@coldplug.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>, Alexey Charkov <alchark@gmail.com>
CC: Tony Prisk <linux@prisktech.co.nz>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: wmt-sdmmc: fix unmatched release_mem_region
References: <1415567571-6144-1-git-send-email-alchark@gmail.com> <CAOMZO5C+O4h=f=vtLTdBZktnfVWzfeLjOQG-oecxh_c9u-QMqA@mail.gmail.com>
In-Reply-To: <CAOMZO5C+O4h=f=vtLTdBZktnfVWzfeLjOQG-oecxh_c9u-QMqA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2014 10:55 PM, Fabio Estevam wrote:
> On Sun, Nov 9, 2014 at 7:12 PM, Alexey Charkov <alchark@gmail.com> wrote:
>
>> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +       if (!res) {
>> +               ret = -ENODEV;
>> +               goto fail1;
> You could save this NULL check...
>
>> +       }
>>          mmc = mmc_alloc_host(sizeof(struct wmt_mci_priv), &pdev->dev);
>>          if (!mmc) {
>>                  dev_err(&pdev->dev, "Failed to allocate mmc_host\n");
>> @@ -813,7 +819,7 @@ static int wmt_mci_probe(struct platform_device *pdev)
>>          if (of_get_property(np, "cd-inverted", NULL))
>>                  priv->cd_inverted = 1;
>>
>> -       priv->sdmmc_base = of_iomap(np, 0);
> If you move ' res = platform_get_resource' right here as
> devm_ioremap_resource() already does the NULL check.
>
>> +       priv->sdmmc_base = devm_ioremap_resource(&pdev->dev, res);
>>          if (!priv->sdmmc_base) {
>>                  dev_err(&pdev->dev, "Failed to map IO space\n");
>>                  ret = -ENOMEM;
This was the original intention but it would fall between the failX 
jumps, i discussed that with Alexey and we decided to change it with the 
cleanup to hold this patch small.
