Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaH1OiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 10:38:01 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:54864 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbaH1Ohr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 10:37:47 -0400
Date: Thu, 28 Aug 2014 10:37:35 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Caesar Wang <caesar.wang@rock-chips.com>, heiko@sntech.de,
        rui.zhang@intel.com, grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, huangtao@rock-chips.com, cf@rock-chips.com,
        dianders@chromium.org, dtor@chromium.org, zyw@rock-chips.com,
        addy.ke@rock-chips.com, dmitry.torokhov@gmail.com,
        zhaoyifeng <zyf@rock-chips.com>, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH v3 1/4] thermal: rockchip: add driver for thermal
Message-ID: <20140828143733.GA18084@developer>
References: <1409187562-12370-1-git-send-email-caesar.wang@rock-chips.com>
 <1409187562-12370-2-git-send-email-caesar.wang@rock-chips.com>
 <2852853.mfRZfFVSev@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2852853.mfRZfFVSev@wuerfel>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ceasar and Arnd,

On Thu, Aug 28, 2014 at 10:48:23AM +0200, Arnd Bergmann wrote:
> On Thursday 28 August 2014 08:59:19 Caesar Wang wrote:
> > Thermal is TS-ADC Controller module supports user-defined mode and automatic mode.
> > 
> > User-defined mode refers,TSADC all the control signals entirely by software
> > writing to register for direct control.
> > 
> > Automaic mode refers to the module automatically poll TSADC output,and the results
> > Were checked.
> > 
> > If you find that the temperature High in a period of time, an interrupt is generated
> > to the processor down-measures taken;if the temperature over a period of time High,
> > the resulting TSHUT gave CRU module,let it reset the entire chip, or via GPIO give PMIC.
> > 
> > Signed-off-by: zhaoyifeng <zyf@rock-chips.com>
> > Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
> 
> Hi Caesar,
> 
> After looking at the driver (last time I only received the patch for
> the binding), I have a more general comment:
> 
> This looks like a general-purpose ADC device, not an IP block that is
> specific to thermal management. The binding looks ok for that purpose
> but should probably be moved into Documentation/devicetree/bindings/iio/adc/
> as a minor change.
> 

I agree with Arnd's point here. It makes sense to me to have this driver
under the IIO umbrella. 

> On the driver side, I believe the correct way to deal with this setup
> is to split your driver into a generic drivers/iio/adc/rockchips-tsadc.c
> file, and a smaller thermal driver that uses the iio in-kernel interfaces,
> ideally one that is independent of the underlying hardware and can
> work on any ADC implementation.
> 

Agreed. If you can write such interface and make your driver to work in
such way, that would be great.

> I've put the IIO maintainer on Cc in this mail, maybe Jonathan or someone
> else on the linux-iio mailing list has some extra insight.
> 
> 	Arnd


Cheers,

Eduardo
