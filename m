Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbaEKOoG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 10:44:06 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:47556 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbaEKOoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 10:44:02 -0400
MIME-Version: 1.0
In-Reply-To: <536E814E.4020805@cogentembedded.com>
References: <1399715823-19839-1-git-send-email-gautam.vivek@samsung.com>
	<1399715823-19839-6-git-send-email-gautam.vivek@samsung.com>
	<536E814E.4020805@cogentembedded.com>
Date: Sun, 11 May 2014 20:14:00 +0530
X-Google-Sender-Auth: A3sokhQztmKtgtXBgUlzDaYaIKM
Message-ID: <CAFp+6iGSfhLB4J4Wr80WSih2bdzcO8vWhgZAonPv6SXbCp-Cmw@mail.gmail.com>
Subject: Re: [PATCH 5/6] usb: host: ehci-tegra: Use devm_ioremap_resource
 instead of devm_ioremap
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-tegra@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kukjin Kim <kgene.kim@samsung.com>, thierry.reding@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Sun, May 11, 2014 at 1:13 AM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> Hello.
>
>
> On 05/10/2014 01:57 PM, Vivek Gautam wrote:
>
>> Using devm_ioremap_resource() API should actually be preferred over
>> devm_ioremap(), since the former request the mem region first and then
>> gives back the ioremap'ed memory pointer.
>> devm_ioremap_resource() calls request_mem_region(), therby preventing
>> other drivers to make any overlapping call to the same region.
>
>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> ---
>>   drivers/usb/host/ehci-tegra.c |    3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>
>
>> diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
>> index 572634c..ccc6433 100644
>> --- a/drivers/usb/host/ehci-tegra.c
>> +++ b/drivers/usb/host/ehci-tegra.c
>> @@ -411,9 +411,8 @@ static int tegra_ehci_probe(struct platform_device
>> *pdev)
>>         }
>>         hcd->rsrc_start = res->start;
>>         hcd->rsrc_len = resource_size(res);
>> -       hcd->regs = devm_ioremap(&pdev->dev, res->start,
>> resource_size(res));
>> +       hcd->regs = devm_ioremap_resource(&pdev->dev, res);
>>         if (!hcd->regs) {
>
>
>    This has to be changed as well as devm_ioremap_resource() returns error,
> not NULL.

Have already updated in the v2 version of this patch, and others in the series.

>
>
>> -               dev_err(&pdev->dev, "Failed to remap I/O memory\n");
>>                 err = -ENOMEM;
>
>
>    This needs to be changed as well, to pass up the error code
> devm_ioremap_resource() returned.

ditoo



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
