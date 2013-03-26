Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934250Ab3CZJPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 05:15:52 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7589 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759734Ab3CZJPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 05:15:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 26 Mar 2013 02:15:22 -0700
Message-ID: <51516695.8020808@nvidia.com>
Date: Tue, 26 Mar 2013 14:42:53 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Graeme Gregory <gg@slimlogic.co.uk>
CC: Kishon Vijay Abraham I <kishon@ti.com>, "balbi@ti.com" <balbi@ti.com>,
        Rajendra Nayak <rnayak@ti.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "s-guiriec@ti.com" <s-guiriec@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v3] USB: PHY: Palmas USB Transceiver Driver
References: <1362662506-14823-4-git-send-email-kishon@ti.com> <1364203926-24488-1-git-send-email-kishon@ti.com> <51501CFB.4020905@nvidia.com> <51513A40.7080905@ti.com> <515163F6.3010400@slimlogic.co.uk>
In-Reply-To: <515163F6.3010400@slimlogic.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 March 2013 02:31 PM, Graeme Gregory wrote:
> On 26/03/13 06:03, Kishon Vijay Abraham I wrote:
>>> +static int palmas_usb_read(struct palmas *palmas, unsigned int reg,
>>> +               unsigned int *dest)
>>> +{
>>> +       unsigned int addr;
>>> +       int slave;
>>> +
>>> +       slave = PALMAS_BASE_TO_SLAVE(PALMAS_USB_OTG_BASE);
>>> +       addr = PALMAS_BASE_TO_REG(PALMAS_USB_OTG_BASE, reg);
>>> +
>>> +       return regmap_read(palmas->regmap[slave], addr, dest);
>>>
>>>
>>> Please use the generic api for palmas_read()/palmas_write(0 as it will
>>> be ease on debugging on register access.
>>> Direct regmap_read() does not help much on this.
>> Graeme,
>> Any reason why you dint use palmas_read()/palmas_write here?
>> Btw palmas_read()/palmas_write() internally uses regmap APIs.
> Because I was not a fan of tightly coupling the child devices to the
> parent MFD. palmas_read/write were added by Laxman.


But still you are using the PALMAS macro here and indirectly it is tied 
up. It is not completely independent.
If need to be independent then regmap pointer with address need to be 
passed as independt header and no where on code whould refer the PALMA.
I think as per current code, it is not possible although it is your big 
plan what I understand from some time back in one of patch discussion.


>>>> +       palmas_usb->dev         = &pdev->dev;
>>>> +
>>>> +       palmas_usb->irq1 = regmap_irq_get_virq(palmas->irq_data,
>>>> +                                               PALMAS_ID_OTG_IRQ);
>>>> +       palmas_usb->irq2 = regmap_irq_get_virq(palmas->irq_data,
>>>> +                                               PALMAS_ID_IRQ);
>>>> +       palmas_usb->irq3 = regmap_irq_get_virq(palmas->irq_data,
>>>> +                                               PALMAS_VBUS_OTG_IRQ);
>>>> +       palmas_usb->irq4 = regmap_irq_get_virq(palmas->irq_data,
>>>> +                                               PALMAS_VBUS_IRQ);
>>> Should be come from platform_get_irq() through platform driver.
>> No. It can be obtained from regmap too.
Kishon,
I think it is very much possible. You can pass the interrupt throough 
IRQ_RESOURCE and populate it from DT. If you provide proper interrupt 
parent and irq number then irq framework take care of every thing.  
already tested this with RTC interrupt of plama and it worked very well.

