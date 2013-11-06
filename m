Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab3KFX30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 18:29:26 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35033 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab3KFX3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 18:29:24 -0500
Message-ID: <527AD0CD.8020001@gmail.com>
Date: Thu, 07 Nov 2013 00:29:17 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
To: delicious quinoa <delicious.quinoa@gmail.com>,
        Fabio Estevam <festevam@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-gpio@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jamie Iles <jamie@jamieiles.com>, Heiko Stuebner <heiko@sntech.de>,
        Alan Tull <atull@altera.com>, Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Subject: Re: [PATCH 1/1] gpio: add a driver for the Synopsys DesignWare APB
 GPIO block
References: <1383778182-16941-1-git-send-email-delicious.quinoa@gmail.com> <1383778182-16941-2-git-send-email-delicious.quinoa@gmail.com> <CAOMZO5BarpUGOExmDR8c2e0YOL41MmNkMii2ZU+jKrmEVtcmig@mail.gmail.com> <CANk1AXTys8B-jW0bATu19pOauVqe=aMc7v=SxXPm7npWb2y7eA@mail.gmail.com>
In-Reply-To: <CANk1AXTys8B-jW0bATu19pOauVqe=aMc7v=SxXPm7npWb2y7eA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2013 12:18 AM, delicious quinoa wrote:
> On Wed, Nov 6, 2013 at 5:09 PM, Fabio Estevam <festevam@gmail.com> wrote:
>> On Wed, Nov 6, 2013 at 8:49 PM, Alan Tull <delicious.quinoa@gmail.com> wrote:
>>
>>> +
>>> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>> +       gpio->regs = devm_ioremap_resource(&pdev->dev, res);
>>> +       if (!gpio->regs) {
>>> +               err = -ENOMEM;
>>> +               goto out_free_ports;
>>
>> The correct way to handle the error here would be:
>>
>> if (IS_ERR(gpio->regs) {
>>       err = PTR_ERR(gpio->regs)
>>       goto out_free_ports;
>>
>>
>>> +out_unregister:
>>> +       dwapb_gpio_unregister(gpio);
>>> +
>>> +       if (gpio->domain) {
>>> +               irq_dispose_mapping(gpio->hwirq);
>>> +               irq_domain_remove(gpio->domain);
>>> +       }
>>> +
>>> +out_free_ports:
>>> +       devm_kfree(&pdev->dev, gpio->ports);
>>
>> No need to call devm_kfree
>>
>>> +
>>> +out_err:
>>> +       devm_kfree(&pdev->dev, gpio);
>>
>> Same here.
>>
>>> +       return err;
>>> +}
>>> +
>>> +static int dwapb_gpio_remove(struct platform_device *pdev)
>>> +{
>>> +       struct dwapb_gpio *gpio = platform_get_drvdata(pdev);
>>> +
>>> +       dwapb_gpio_unregister(gpio);
>>> +       if (gpio->domain) {
>>> +               irq_dispose_mapping(gpio->hwirq);
>>> +               irq_domain_remove(gpio->domain);
>>> +       }
>>> +       devm_kfree(&pdev->dev, gpio->ports);
>>> +       devm_kfree(&pdev->dev, gpio);
>>
>> No need to call devm_kfree
>>
>> Regards,
>>
>> Fabio Estevam
>
> Cool, I agree.  I will fix in v7.

Alan, will review tomorrow. Please do not send v7 too quickly,
but let it idle for some more days. Especially, DT maintainers
have so many reviews to do - so be patient.

Also, for v7, you should use
'git format-patch --subject-prefix "PATCH v7" ...' to reflect
the patch version in email subject line.

Sebastian

