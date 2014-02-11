Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbaBKTHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:07:01 -0500
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:27176
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753644AbaBKTG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:06:57 -0500
Message-ID: <52FA7147.20607@caviumnetworks.com>
Date: Tue, 11 Feb 2014 10:51:51 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>
CC: David Daney <ddaney.cavm@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] of/gpio: Define OF_GPIO_OPEN_DRAIN flag for Open Drain
 outputs.
References: <1392069908-22017-1-git-send-email-ddaney.cavm@gmail.com> <CAAVeFu+_WKzLdhWcB_km3iDj419OhtMXEKzz_yWoL3WUm+7kQQ@mail.gmail.com>
In-Reply-To: <CAAVeFu+_WKzLdhWcB_km3iDj419OhtMXEKzz_yWoL3WUm+7kQQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-Forefront-PRVS: 0119DC3B5E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019001)(6009001)(377454003)(51704005)(199002)(189002)(24454002)(51914003)(479174003)(76482001)(64126003)(74502001)(53806001)(47446002)(81542001)(46102001)(23676002)(69226001)(1411001)(94946001)(51856001)(92726001)(94316002)(31966008)(54356001)(81342001)(54316002)(56776001)(92566001)(76786001)(95416001)(74662001)(83072002)(85852003)(83322001)(19580405001)(80976001)(19580395003)(33656001)(85306002)(93516002)(90146001)(83506001)(81686001)(81816001)(56816005)(93136001)(74876001)(74706001)(50466002)(77982001)(76796001)(77096001)(74366001)(59766001)(53416003)(4396001)(63696002)(87266001)(65956001)(47976001)(47736001)(50986001)(49866001)(36756003)(65806001)(80022001)(66066001)(79102001)(87936001)(47776003)(95666001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO2PR07MB619;H:BLUPRD0711HT001.namprd07.prod.outlook.com;CLIP:64.2.3.195;FPR:FEF8FABC.9ED29FE9.DBCB32BA.4CEDC060.2023F;InfoNoRecordsA:1;MX:1;LANG:en;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2014 08:31 PM, Alexandre Courbot wrote:
> On Tue, Feb 11, 2014 at 7:05 AM, David Daney <ddaney.cavm@gmail.com> wrote:
>> From: David Daney <david.daney@cavium.com>
>>
>> When we have a GPIO pin connected to an open-drain network, we want a
>> standard way of specifying this in the device tree.  So we choose bit
>> 1 of the flag field to indicate open drain.
>>
>> A typical use case would be something like:
>>
>>          enum of_gpio_flags f;
>>          .
>>          .
>>          .
>>          reset_gpio = of_get_named_gpio_flags(node, "reset", 0, &f);
>>          .
>>          .
>>          .
>>          ret = gpio_request_one(reset_gpio,
>>                  (f & OF_GPIO_OPEN_DRAIN) ? GPIOF_OPEN_DRAIN : 0,
>>                   "reset");
>>          .
>>          .
>>          .
>>          gpio_direction_output(reset_gpio, 1);
>>          gpio_set_value(reset_gpio, 0);
>>          msleep(20);
>>          gpio_set_value(reset_gpio, 1);
>
> This is also useful for gpiod_get(). However, while you are at it,
> could you also add a flag for the OF_GPIO_OPEN_SOURCE property? My joy
> would be complete if you could also take the time to update
> of_find_gpio() to pass these new flags back to the caller as it
> already does for OF_GPIO_ACTIVE_LOW.
>
> Then you could even switch your use-case to the gpiod interface and
> not bother with passing these flags by yourself anymore. Just sayin'.
> ;)

Thanks for the suggestion.  I will send a revised patch set for your 
consideration.

David Daney

