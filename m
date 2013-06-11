Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab3FKEwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 00:52:05 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:51410 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab3FKEwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 00:52:03 -0400
Message-ID: <51B6ACEA.2040408@linaro.org>
Date: Tue, 11 Jun 2013 10:21:54 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-kernel@vger.kernel.org, thierry.reding@gmail.com, patches@linaro.org,
        linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 13/15] pci: mvebu: Convert to use devm_ioremap_resource
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org> <1370864113-17895-14-git-send-email-tushar.behera@linaro.org> <CAK9yfHzcw071CfssSdFjmN1qXOp732NOaud2G0Dcd_8KZBFbgQ@mail.gmail.com>
In-Reply-To: <CAK9yfHzcw071CfssSdFjmN1qXOp732NOaud2G0Dcd_8KZBFbgQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 07:59 PM, Sachin Kamat wrote:
> On 10 June 2013 17:05, Tushar Behera <tushar.behera@linaro.org> wrote:
>> Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
>> introduced devm_ioremap_resource() and deprecated the use of
>> devm_request_and_ioremap().
>>
>> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
>> CC: linux-pci@vger.kernel.org
>> CC: Bjorn Helgaas <bhelgaas@google.com>
>> ---
>>  drivers/pci/host/pci-mvebu.c |    5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
>> index 13a633b..e714876 100644
>> --- a/drivers/pci/host/pci-mvebu.c
>> +++ b/drivers/pci/host/pci-mvebu.c
>> @@ -752,7 +752,7 @@ mvebu_pcie_map_registers(struct platform_device *pdev,
>>         if (ret)
>>                 return NULL;
>>
>> -       return devm_request_and_ioremap(&pdev->dev, &regs);
>> +       return devm_ioremap_resource(&pdev->dev, &regs);
>>  }
>>
>>  static int __init mvebu_pcie_probe(struct platform_device *pdev)
>> @@ -842,9 +842,10 @@ static int __init mvebu_pcie_probe(struct platform_device *pdev)
>>                         continue;
>>
>>                 port->base = mvebu_pcie_map_registers(pdev, child, port);
>> -               if (!port->base) {
>> +               if (IS_ERR(port->base)) {
>>                         dev_err(&pdev->dev, "PCIe%d.%d: cannot map registers\n",
>>                                 port->port, port->lane);
> 
> This error message is redundant.
> 

It provides a little more information regarding the port and lane number
which might be useful in debugging.

>> +                       port->base = NULL;
> Probably this is also not needed.
> 

I was not sure about the default error value for port->base, hence I
replicated the old behaviour.

Thanks.
-- 
Tushar Behera
