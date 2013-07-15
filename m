Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab3GOMek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 08:34:40 -0400
Received: from smtp-out-191.synserver.de ([212.40.185.191]:1128 "EHLO
	smtp-out-191.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210Ab3GOMej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 08:34:39 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 10894
Message-ID: <51E3EC8B.3090601@metafoo.de>
Date: Mon, 15 Jul 2013 14:35:23 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
CC: Oleksandr Kravchenko <x0199363@ti.com>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        grant.likely@linaro.org, rob.herring@calxeda.com, rob@landley.net,
        jic23@cam.ac.uk, pmeerw@pmeerw.net, holler@ahsoftware.de,
        srinivas.pandruvada@intel.com, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] iio: add APDS9300 ambilent light sensor driver
References: <1373461729-11261-1-git-send-email-x0199363@ti.com> <51E03720.1010806@metafoo.de> <CAGH3drqEPxW=QwadCLj=ZOQe0gp_c7mdSiNQnq1_-BMKL9CgJw@mail.gmail.com>
In-Reply-To: <CAGH3drqEPxW=QwadCLj=ZOQe0gp_c7mdSiNQnq1_-BMKL9CgJw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 02:27 PM, Oleksandr Kravchenko wrote:
> Thank you for review! But I don't completely understand one of your comment:
> 
>>> +static int als_probe(struct i2c_client *client, const struct i2c_device_id *id)
> [...]
>>> +     if (client->irq) {
>>> +             ret = devm_request_threaded_irq(&client->dev, client->irq,
>>> +                             NULL, als_interrupt_handler,
>>> +                             IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
>>> +                             ALS_IRQ_NAME, indio_dev);
>>
>> This is a bit racy, you access memory in the irq handler that is freed
>> before the irq is freed.
> 
> Do you mean than that indio_dev may be used in interrupt handler after
> iio_device_free(indio_dev) called in als_remove() function?
> 
> If so, can I use disable_irq() in als_remove() before iio_device_free()
> to avoid this problem?
> 

Just add a devm_iio_device_alloc() and use that, instead of trying to bodch
around the issue.

