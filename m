Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbaDKKOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 06:14:12 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57225 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbaDKKOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 06:14:10 -0400
Message-ID: <5347CC75.8040300@ti.com>
Date: Fri, 11 Apr 2014 14:05:25 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>
CC: netdev <netdev@vger.kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        Jonathan Cameron <jic23@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>, <santosh.shilimkar@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH 0/2] introduce devm_mdiobus_alloc/devm_mdiobus_free
References: <1396618825-4241-1-git-send-email-grygorii.strashko@ti.com> <CAGVrzcZ8vXBn4omyR7+ejihhcrspt-Rz_BBh55esxNFO06gHgQ@mail.gmail.com>
In-Reply-To: <CAGVrzcZ8vXBn4omyR7+ejihhcrspt-Rz_BBh55esxNFO06gHgQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,
On 04/11/2014 07:55 AM, Florian Fainelli wrote:
> Hi Grygorii,
> 
> 2014-04-04 6:40 GMT-07:00 Grygorii Strashko <grygorii.strashko@ti.com>:
>> Introduce a resource managed devm_mdiobus_alloc()/devm_mdiobus_free()
>> to automatically clean up MDIO bus alocations made by MDIO drivers,
>> thus leading to simplified MDIO drivers code.
>>
>> Update Davinci MDIO driver ss example of new devm APIs usage.
> 
> This does look good at first glance. net-next is currently closed at
> the moment, so this will have to be merged later.

Thanks. It can wait for 3.16, so I'll update & resend after rc1.
I have few more patches for davinci_mdio.c, so
my intention here was to check if I can base them on top of new API or not :)

> 
> At some point, we might also want to handle the mdio_bus irq array, as
> that one is also usually dynamically allocated. Maybe we could just do
> a static irq[PHY_MAX_ADDR] allocation, 32 times the size of an integer
> might not be worth a potential leak.

It sounds good, but first of all irq field of mii_bus structure has to be made private. 
And drivers have to use getter/setters to access it - then its type can be changes 
simply and safely.

By the way, mdiobus_register() can be handled using DEVM approach too, but it 
will a bit more complex.

[...]
> 

Regards,
- grygorii

