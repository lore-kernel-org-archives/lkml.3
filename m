Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaFYEjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 00:39:05 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:43244 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbaFYEjD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 00:39:03 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Rob Herring <robherring2@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, "Paul Bolle" <pebolle@tiscali.nl>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "Francois.Bedard@synopsys.com" <Francois.Bedard@synopsys.com>
Subject: Re: [PATCH v2 REBASED 06/10] serial/arc: remove last remanants of
 platform data
Thread-Topic: [PATCH v2 REBASED 06/10] serial/arc: remove last remanants of
 platform data
Thread-Index: AQHPj++Gcc9+mmWx/kaDjDml3GRYSg==
Date: Wed, 25 Jun 2014 04:38:44 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230751A6B9CE5@IN01WEMBXA.internal.synopsys.com>
References: <1403598315-1429-1-git-send-email-vgupta@synopsys.com>
 <1403598315-1429-7-git-send-email-vgupta@synopsys.com>
 <CAL_JsqLpLKs0+u2a0VvgYW_0bGDpQCOEJSqKDqpYTO=KuO6uhg@mail.gmail.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.196.93]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 June 2014 02:31 AM, Rob Herring wrote:
> On Tue, Jun 24, 2014 at 3:25 AM, Vineet Gupta
> <Vineet.Gupta1@synopsys.com> wrote:
>> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
>> ---
>>  drivers/tty/serial/arc_uart.c | 22 ++++++----------------
>>  1 file changed, 6 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/tty/serial/arc_uart.c b/drivers/tty/serial/arc_uart.c
>> index 2ffaf099691a..dc3d5db37dc4 100644
>> --- a/drivers/tty/serial/arc_uart.c
>> +++ b/drivers/tty/serial/arc_uart.c
>
>> @@ -518,21 +516,13 @@ arc_uart_init_one(struct platform_device *pdev, int dev_id)
>>         }
>>         uart->baud = val;
>>
>> -       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> -       if (!res)
>> -               return -ENODEV;
>> -
>> -       res2 = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>> -       if (!res2)
>> -               return -ENODEV;
>> -
>> -       port->mapbase = res->start;
>> -       port->membase = ioremap_nocache(res->start, resource_size(res));
>> +       port->membase = of_iomap(np, 0);
> ioremap is preferred over of_iomap as it is not OF specific.

I could, but much of the driver assumes OF to be selected already (of_property...)

>  Perhaps
> use devm_request_and_ioremap instead.

devm_request_and_ioremap has been flag day removed in favour of
devm_ioremap_resource().
However even then it would require me to retain the prior platform_get_resource()
call.
IMHO, of_iomap is must more concise.

>
>>         if (!port->membase)
>>                 /* No point of dev_err since UART itself is hosed here */
>>                 return -ENXIO;
>>
>> -       port->irq = res2->start;
>> +       port->irq = irq_of_parse_and_map(np, 0);
>> +
> platform_get_irq should be used here.

And this again is for reducing OF dependency or is it something else.

Thx,
-Vineet

>
>>         port->dev = &pdev->dev;
>>         port->iotype = UPIO_MEM;
>>         port->flags = UPF_BOOT_AUTOCONF;
>> --
>> 1.8.3.2
>>

