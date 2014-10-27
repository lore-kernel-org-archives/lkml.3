Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbaJ0PdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:33:09 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:47791 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbaJ0PdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:33:04 -0400
MIME-Version: 1.0
In-Reply-To: <40072ff932074ee189999faf5dc0a434@BL2FFO11FD037.protection.gbl>
References: <1414063861-5491-1-git-send-email-mike.looijmans@topic.nl>
	<1414063861-5491-2-git-send-email-mike.looijmans@topic.nl>
	<40072ff932074ee189999faf5dc0a434@BL2FFO11FD037.protection.gbl>
Date: Mon, 27 Oct 2014 16:33:00 +0100
Message-ID: <CAPDyKFpuiPqZ+5h-SS2-7XeVVh4J2v3SQr=RtjaTZw=0=bXABw@mail.gmail.com>
Subject: Re: [PATCH 2/2] mmc/host/sdhci-of-arasan.c: Skip EPROBE_DEFER error messages
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Mike Looijmans <mike.looijmans@topic.nl>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 October 2014 13:47, Michal Simek <michal.simek@xilinx.com> wrote:
> Hi Chris,
>
> On 10/23/2014 01:31 PM, Mike Looijmans wrote:
>> When the error code is -EPROBE_DEFER, this will already be reported
>> so don't emit an error message in that case.
>>
>> Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
>> ---
>>  drivers/mmc/host/sdhci-of-arasan.c |    6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/mmc/host/sdhci-of-arasan.c b/drivers/mmc/host/sdhci-of-arasan.c
>> index 7ac6718..d5812a0 100644
>> --- a/drivers/mmc/host/sdhci-of-arasan.c
>> +++ b/drivers/mmc/host/sdhci-of-arasan.c
>> @@ -161,7 +161,8 @@ static int sdhci_arasan_probe(struct platform_device *pdev)
>>       host = sdhci_pltfm_init(pdev, &sdhci_arasan_pdata, 0);
>>       if (IS_ERR(host)) {
>>               ret = PTR_ERR(host);
>> -             dev_err(&pdev->dev, "platform init failed (%d)\n", ret);
>> +             if (ret != -EPROBE_DEFER)
>> +                     dev_err(&pdev->dev, "platform init failed (%d)\n", ret);
>>               goto clk_disable_all;
>>       }
>>
>> @@ -172,7 +173,8 @@ static int sdhci_arasan_probe(struct platform_device *pdev)
>>
>>       ret = sdhci_add_host(host);
>>       if (ret) {
>> -             dev_err(&pdev->dev, "platform register failed (%d)\n", ret);
>> +             if (ret != -EPROBE_DEFER)
>> +                     dev_err(&pdev->dev, "platform register failed (%d)\n", ret);
>>               goto err_pltfm_free;
>>       }
>
>
> I checked other drivers and they are not reporting these bugs. I have briefly looked
> at sdhci_add_host and sdhci_platfm_init and they are pretty good error description
> + core itself should report if driver probe failed.
> That's why I think that it is just reasonable to remove these both dev_err completely.
>
> What do you think?

I agree, this seems reasonable!

Kind regards
Uffe
