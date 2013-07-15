Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab3GOLdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 07:33:13 -0400
Received: from smtp-out-191.synserver.de ([212.40.185.191]:1080 "EHLO
	smtp-out-191.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837Ab3GOLdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 07:33:11 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 9496
Message-ID: <51E3DE21.9060105@metafoo.de>
Date: Mon, 15 Jul 2013 13:33:53 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: "Kozaruk, Oleksandr" <oleksandr.kozaruk@ti.com>
CC: "tony@atomide.com" <tony@atomide.com>,
        "benoit.cousson@linaro.org" <benoit.cousson@linaro.org>,
        "Nayak, Rajendra" <rnayak@ti.com>,
        "Ujfalusi, Peter" <peter.ujfalusi@ti.com>,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "ch.naveen@samsung.com" <ch.naveen@samsung.com>,
        "poeschel@lemonage.de" <poeschel@lemonage.de>,
        "Kim, Milo" <Milo.Kim@ti.com>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] iio: twl6030-gpadc: TWL6030, TWL6032 GPADC driver
References: <1373613482-28390-1-git-send-email-oleksandr.kozaruk@ti.com> <1373613482-28390-3-git-send-email-oleksandr.kozaruk@ti.com>,<51E05F6C.1060506@metafoo.de> <2A7ABDFCE21540479A5AEB0244A684D5E3D067@DNCE04.ent.ti.com>
In-Reply-To: <2A7ABDFCE21540479A5AEB0244A684D5E3D067@DNCE04.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 01:09 PM, Kozaruk, Oleksandr wrote:
[...]
> 
>>> +     ret = devm_request_threaded_irq(dev, irq, NULL,
>>> +                                     twl6030_gpadc_irq_handler,
>>> +                                     IRQF_ONESHOT, "twl6030_gpadc", gpadc);
>>
>> You access memory in the interrupt handler which is freed before the interrupt
>> handler is freed.
> Thanks for pointing this. devm_* will free memory for irq after the driver
> is removed and memory for the device is freed. I took me awhile to understand
> this. Is there going to be something like devm_iio_device_alloc? whould it be helpfull?
> 

Yes, I think it certainly makes sense to add a devm_iio_device_alloc(), care
to send a patch?
