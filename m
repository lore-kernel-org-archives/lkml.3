Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbaHFM4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 08:56:38 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:62663 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065AbaHFM4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 08:56:35 -0400
MIME-Version: 1.0
In-Reply-To: <b85e230a058340a58fd3091e2be9b25d@BN1PR0301MB0628.namprd03.prod.outlook.com>
References: <1407302256-26726-1-git-send-email-b20788@freescale.com>
	<53E1D29D.1010009@gmail.com>
	<b85e230a058340a58fd3091e2be9b25d@BN1PR0301MB0628.namprd03.prod.outlook.com>
Date: Wed, 6 Aug 2014 08:56:33 -0400
Message-ID: <CAC-25o_z-pJ_3HX-wfnWB2uVSCRodXYzqOe2U-yac2kAY2ShYQ@mail.gmail.com>
Subject: Re: [PATCH V2] Thermal: imx: add i.mx6sx thermal support
From: "edubezval@gmail.com" <edubezval@gmail.com>
To: "Anson.Huang@freescale.com" <Anson.Huang@freescale.com>
Cc: Varka Bhadram <varkabhadram@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Anson,

On Wed, Aug 6, 2014 at 3:05 AM, Anson.Huang@freescale.com
<Anson.Huang@freescale.com> wrote:
> Sorry for leaving such warnings, I thought we did NOT care about the long
> line issue now, will fix them in V3 patch.
>

Lines over 80 columns are not an error of style. We simply suggest to
keep this. By now, I think it really depends on which subsystem you
are working with. I would prefer you keep this rule, as most of the
code inside the thermal framework follows it.

>
>
> Thanks Varka.
>
>
>
> Best regards!
>
> Anson Huang
>
>
>
> From: Varka Bhadram [mailto:varkabhadram@gmail.com]
> Sent: 2014-08-06 3:01 PM
> To: Huang Yongcai-B20788; edubezval@gmail.com; shawn.guo@linaro.org;
> rui.zhang@intel.com
> Cc: linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org;
> devicetree@vger.kernel.org
> Subject: Re: [PATCH V2] Thermal: imx: add i.mx6sx thermal support
>
>
>
> On 08/06/2014 10:47 AM, Anson Huang wrote:
>
> i.MX6SX has some new features of thermal interrupt function,
>
> there are LOW, HIGH and PANIC irq for thermal sensor, so add
>
> platform data to separate different thermal version;
>
>
>
> The reset value of LOW ALARM is 0 which means the highest
>
> temp, so the LOW ALARM will be triggered once irq is enabled,
>
> so we need to correct it before enabling thermal irq;
>
>
>
> Enable PANIC ALARM as critical trip point, it will trigger
>
> system reset via SRC module once PANIC IRQ is triggered, it
>
> is pure hardware function, so use it instead of software
>
> reset by cooling device.
>
>
>
> Signed-off-by: Anson Huang <b20788@freescale.com>
>
> ---
>
>  .../devicetree/bindings/thermal/imx-thermal.txt    |    5 +-
>
>  drivers/thermal/imx_thermal.c                      |   89
> +++++++++++++++++---
>
>  2 files changed, 80 insertions(+), 14 deletions(-)
>
>
>
> ./scripts/checkpatch.pl --show-types
> V2-Thermal-imx-add-i.mx6sx-thermal-support.patch
>
> WARNING:LONG_LINE: line over 80 characters
>
> #109: FILE: drivers/thermal/imx_thermal.c:185:
>
> +    /* Update alarm value to next higher trip point, only TEMPMON_IMX6Q
> needs it */
>
>
>
> WARNING:LONG_LINE: line over 80 characters
>
> #111: FILE: drivers/thermal/imx_thermal.c:187:
>
> +        if (data->alarm_temp == data->temp_passive && *temp >=
> data->temp_passive)
>
>
>
> WARNING:LONG_LINE: line over 80 characters
>
> #113: FILE: drivers/thermal/imx_thermal.c:189:
>
> +        if (data->alarm_temp == data->temp_critical && *temp <
> data->temp_passive) {
>
>
>
> --
>
> Regards,
>
> Varka Bhadram.



-- 
Eduardo Bezerra Valentin
