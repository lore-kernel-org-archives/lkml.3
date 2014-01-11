Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbaAKSfa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 13:35:30 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:36709 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbaAKSf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 13:35:27 -0500
Message-ID: <52D18EE9.5030305@gmail.com>
Date: Sat, 11 Jan 2014 19:35:21 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jean-Francois Moine <moinejf@free.fr>
CC: dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>, Dave Airlie <airlied@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 13/28] drm/i2c: tda998x: use irq for connection status
 and EDID read
References: <20140109120412.7697d23c@armhf> <20140111181432.GB15937@n2100.arm.linux.org.uk>
In-Reply-To: <20140111181432.GB15937@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2014 07:14 PM, Russell King - ARM Linux wrote:
> On Thu, Jan 09, 2014 at 12:04:12PM +0100, Jean-Francois Moine wrote:
>> @@ -1250,6 +1311,39 @@ tda998x_encoder_init(struct i2c_client *client,
>>   		priv->vip_cntrl_2 = video;
>>   	}
>>
>> +	/* install the optional HDMI connect IRQ */
>> +	priv->int_irq = irq_of_parse_and_map(np, 0);
>> +	if (priv->int_irq < 0)
>> +		priv->int_irq = NO_IRQ;
>> +	if (priv->int_irq != NO_IRQ) {
>
> NAK.  Do not use NO_IRQ.  Use <= 0 instead, or just test against zero for
> no IRQ.  It would also be nice to offer this facility to non-DT platforms
> via client->irq.  Not every arch in the Linux kernel uses DT.

At least for the DT part, I'd suggest to not ask for interrupt directly
but use a proper gpios property. The can of course be converted to
priv->int_irq in some tda998x_dt_probe.

Sebastian
