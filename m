Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbaKGB5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 20:57:35 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:53583 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaKGB5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 20:57:33 -0500
Date: Thu, 6 Nov 2014 17:57:28 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Caesar Wang <caesar.wang@rock-chips.com>, heiko@sntech.de,
        rui.zhang@intel.com, zyf@rock-chips.com, dianders@chromium.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        cf@rock-chips.com, dbasehore@chromium.org, huangtao@rock-chips.com,
        cjf@rock-chips.com, zhengsq@rock-chips.com, fzf@rock-chips.com
Subject: Re: [PATCH v17 1/5] thermal: rockchip: add driver for thermal
Message-ID: <20141107015728.GF34214@dtor-ws>
References: <1414809873-32227-1-git-send-email-caesar.wang@rock-chips.com>
 <1414809873-32227-2-git-send-email-caesar.wang@rock-chips.com>
 <20141107013017.GA10180@developer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107013017.GA10180@developer>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

On Thu, Nov 06, 2014 at 09:30:20PM -0400, Eduardo Valentin wrote:
> Hello Caesar,
> 
> On Sat, Nov 01, 2014 at 10:44:29AM +0800, Caesar Wang wrote:
> > Thermal is TS-ADC Controller module supports
> > user-defined mode and automatic mode.
> > 
> > User-defined mode refers,TSADC all the control signals entirely by
> > software writing to register for direct control.
> > 
> > Automaic mode refers to the module automatically poll TSADC output,
> > and the results were checked.If you find that the temperature High
> > in a period of time,an interrupt is generated to the processor
> > down-measures taken;If the temperature over a period of time High,
> > the resulting TSHUT gave CRU module,let it reset the entire chip,
> > or via GPIO give PMIC.
> > 
> 
> First thing, very good progress in this driver! 
> 
> > Signed-off-by: zhaoyifeng <zyf@rock-chips.com>
> > Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
> > Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> Just for the sake of code / documentation history, this patch, which
> adds the driver, should come after patch 2, which adds dt documentation.
> 
> > ---
> >  drivers/thermal/Kconfig            |   9 +
> >  drivers/thermal/Makefile           |   1 +
> >  drivers/thermal/rockchip_thermal.c | 711 +++++++++++++++++++++++++++++++++++++
> >  3 files changed, 721 insertions(+)
> >  create mode 100644 drivers/thermal/rockchip_thermal.c
> 
> <big cut>
> 
> > +static int
> > +rockchip_thermal_register_sensor(struct platform_device *pdev,
> > +				 struct rockchip_thermal_data *thermal,
> > +				 struct rockchip_thermal_sensor *sensor,
> > +				 enum sensor_id id)
> > +{
> > +	const struct rockchip_tsadc_chip *tsadc = thermal->chip;
> > +	int error;
> > +
> > +	tsadc->set_tshut_mode(id, thermal->regs, thermal->tshut_mode);
> > +	tsadc->set_tshut_temp(id, thermal->regs, thermal->tshut_temp);
> > +
> > +	sensor->thermal = thermal;
> > +	sensor->id = id;
> > +	sensor->tzd = thermal_zone_of_sensor_register(&pdev->dev, id, sensor,
> > +						rockchip_thermal_get_temp,
> > +						NULL,
> > +						rockchip_thermal_set_trips);
> 
> So, did I miss something here? Looks like you have extended the of
> thermal, and I haven't seen the patch.
>   CC [M]  drivers/thermal/rockchip_thermal.o
>   drivers/thermal/rockchip_thermal.c: In function
>   `rockchip_thermal_register_sensor':
>   drivers/thermal/rockchip_thermal.c:482:7: error: too many arguments to
>   function `thermal_zone_of_sensor_register'
>          rockchip_thermal_set_trips);

Yes, it relies on patch by Mikko Perttunen adding support for
hardware-supported trip points. It allows us to reduce polling frequency
while still being able to react when we cross the tripping point.

See https://lkml.org/lkml/2014/6/27/76

Thanks.

-- 
Dmitry
