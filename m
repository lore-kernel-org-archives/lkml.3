Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698Ab3FUHFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 03:05:53 -0400
Received: from us02smtp1.synopsys.com ([198.182.60.75]:52299 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab3FUHFv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 03:05:51 -0400
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: netdev <netdev@vger.kernel.org>, Francois Romieu <romieu@fr.zoreil.com>,
        Joe Perches <joe@perches.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Florian Fainelli <florian@openwrt.org>
Subject: Re: [PATCH v6] ethernet/arc/arc_emac - Add new driver
Thread-Topic: [PATCH v6] ethernet/arc/arc_emac - Add new driver
Thread-Index: AQHObazEX0ZgxZxFm06ykyIbUaySYQ==
Date: Fri, 21 Jun 2013 07:05:44 +0000
Message-ID: <4881796E12491D4BB15146FE0209CE643F5F4A8F@DE02WEMBXB.internal.synopsys.com>
References: <1371729196-4505-1-git-send-email-abrodkin@synopsys.com>
 <CAHp75Vf8+z0B6PMjGqVNPuEJrVYiR-yMT5dvqqBAs=GA5utLrQ@mail.gmail.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.121.8.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 08:00 PM, Andy Shevchenko wrote:
> On Thu, Jun 20, 2013 at 2:53 PM, Alexey Brodkin
>> +               if ((info & FOR_EMAC) || !txbd->data)
>
> Redundant internal braces. Up to you.

I left them so priorities of operations will be obvious.

>> +#define FRST_OR_LAST_MASK      (FRST_MASK | LAST_MASK)
>
> You may re-use it in *_tx_clean() above.
> Also, please use full English word FIRST. Actually is there any
> conflicts with existing drivers? Should it be with [ARC_]EMAC prefix?

Re-used it in 2 mentioned places. And changed FRST with FIRST.
I don't see defines with the same name anywhere else.

>
>> +               /* Make sure pointer to data buffer is set */
>> +               mb();
>
> I'm not so familiar with memory barriers, but is this somehow differ
> from smp_mb()?
> Which one suits better? And what about the other places in this file?

Since for now driver itself is not SMP-safe so I don't see any reason 
for "smp_" barriers. Later I plan to add SMP compatibility and that this 
point barriers will be replaced as well.

Another thing is I switched to "wmb()" (which is a barrier fror write in 
particular) instead of generic "mb()".

>> +       /* Allocate Tx BD's similar to Rx BD's. All Tx BD's owned by CPU */
>> +       bd = priv->txbd;
>> +       for (i = 0; i < TX_BD_NUM; i++) {
>> +               bd->data = 0;
>> +               bd->info = 0;
>> +               bd++;
>> +       }
>
> Looks like
> memset(priv->txbd, 0, siezeof(*priv->txbd) * TX_BD_NUM);

Correct.

>> +       /* Get "info" of the next BD */
>
>> +       /* Get PHY from device tree */
>> +       phy_node = of_parse_phandle(pdev->dev.of_node, "phy", 0);
>
>> +       /* Get EMAC registers base address from device tree */
>> +       err = of_address_to_resource(pdev->dev.of_node, 0, &res_regs);
>
>> +       /* Get CPU clock frequency from device tree */
>> +       if (of_property_read_u32(pdev->dev.of_node, "clock-frequency",
>> +                                &clock_frequency)) {
>
>> +       /* Get IRQ from device tree */
>> +       err = of_irq_to_resource(pdev->dev.of_node, 0, &res_irq);
>
> So, you don't like the idea to get as much as possible before
> alloc_netdev(), don't you?

Ok, I did this change)))

Regards,
Alexey
