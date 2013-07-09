Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab3GIMDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 08:03:16 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:65347 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab3GIMDP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 08:03:15 -0400
MIME-Version: 1.0
In-Reply-To: <51DBC58D.90002@freescale.com>
References: <1373013818-11365-1-git-send-email-b32955@freescale.com>
	<20130709070541.GQ516@pengutronix.de>
	<51DBBFDA.70302@freescale.com>
	<20130709075124.GR516@pengutronix.de>
	<51DBC58D.90002@freescale.com>
Date: Tue, 9 Jul 2013 07:03:14 -0500
Message-ID: <CAL_JsqL4ABJCQXveSAMZKOiHwJi=w8zFYjg3DV7kqEEcCXQJcw@mail.gmail.com>
Subject: Re: [PATCH] of: match the compatible in the order set by the dts file
From: Rob Herring <robherring2@gmail.com>
To: Huang Shijie <b32955@freescale.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 9, 2013 at 3:10 AM, Huang Shijie <b32955@freescale.com> wrote:
> 于 2013年07月09日 15:51, Sascha Hauer 写道:
>
>> On Tue, Jul 09, 2013 at 03:46:34PM +0800, Huang Shijie wrote:
>>>
>>> 于 2013年07月09日 15:05, Sascha Hauer 写道:
>>>>
>>>> Why don't you set the matching order in the driver the way you want it
>>>> to be, i.e.:
>>>>
>>>>         { .compatible = "fsl,imx6q-uart", ... },
>>>>         { .compatible = "fsl,imx21-uart", ... },
>>>>         { .compatible = "fsl,imx1-uart", ... },
>>>>
>>> yes. i can set it like this.
>>>
>>> but this method looks like a ugly workaround.
>>
>> If a driver has different ways of supporting a single device, then
>> putting the preferred or most feature rich on top doesn't look very ugly
>> to me.
>
> this method makes it much _coupled_ between the driver and the dts file.
>
> IMHO, it's an unnecessary _burden_ to the driver programmer:
>    he should puts the most feature compatible on the top.
>
> it's much graceful if we let the driver programmer be transparent about
> this.

The dts requires compatible strings to be most specific to least
specific. There is no reason that driver match tables should not be
the same and that is the assumption. Matching is not just based on
compatible properties and your patch does not handle the other cases.

Rob



>
>
> thanks
> Huang Shijie
>
>
>
>
>
>
>
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
