Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936383AbaH1ItB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 04:49:01 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:52101 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932699AbaH1Is6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 04:48:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com,
        grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, huangtao@rock-chips.com, cf@rock-chips.com,
        dianders@chromium.org, dtor@chromium.org, zyw@rock-chips.com,
        addy.ke@rock-chips.com, dmitry.torokhov@gmail.com,
        zhaoyifeng <zyf@rock-chips.com>, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH v3 1/4] thermal: rockchip: add driver for thermal
Date: Thu, 28 Aug 2014 10:48:23 +0200
Message-ID: <2852853.mfRZfFVSev@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1409187562-12370-2-git-send-email-caesar.wang@rock-chips.com>
References: <1409187562-12370-1-git-send-email-caesar.wang@rock-chips.com> <1409187562-12370-2-git-send-email-caesar.wang@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:114g1xWRauj3fShisMsuWPPa4A7XDDIaEgn3lmV3bQ8
 KOof6Ksk3JDcqTWFlMqy1CHVvZbzp43dyo00fY+NtN0DbjoUhZ
 LwZ5PygQYV7V8Ya0hfKa5pj+ecaXbnWTqgRzzsYGdPzz7Pz09S
 G2ELZFzf9Ynyfmbd1vsLhZvMPb/vAFQyvL+4R/LMBLN9/No1sO
 l63bPSKIsjQDitKhh2D4i9S1Tp47/JeWYN4c8kSil43c3/6CtZ
 Dx34nFQMjMpHDTcsWhfDXz+3G1bkeao+k71uVyWqZSwI7Sw+q/
 QzCJb1NGhNu1cnWdJdpwPSP2UavefWCN7IEl5CHRa+seTb7w9n
 sHFcg5kbPl4+L4974evE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 August 2014 08:59:19 Caesar Wang wrote:
> Thermal is TS-ADC Controller module supports user-defined mode and automatic mode.
> 
> User-defined mode refers,TSADC all the control signals entirely by software
> writing to register for direct control.
> 
> Automaic mode refers to the module automatically poll TSADC output,and the results
> Were checked.
> 
> If you find that the temperature High in a period of time, an interrupt is generated
> to the processor down-measures taken;if the temperature over a period of time High,
> the resulting TSHUT gave CRU module,let it reset the entire chip, or via GPIO give PMIC.
> 
> Signed-off-by: zhaoyifeng <zyf@rock-chips.com>
> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>

Hi Caesar,

After looking at the driver (last time I only received the patch for
the binding), I have a more general comment:

This looks like a general-purpose ADC device, not an IP block that is
specific to thermal management. The binding looks ok for that purpose
but should probably be moved into Documentation/devicetree/bindings/iio/adc/
as a minor change.

On the driver side, I believe the correct way to deal with this setup
is to split your driver into a generic drivers/iio/adc/rockchips-tsadc.c
file, and a smaller thermal driver that uses the iio in-kernel interfaces,
ideally one that is independent of the underlying hardware and can
work on any ADC implementation.

I've put the IIO maintainer on Cc in this mail, maybe Jonathan or someone
else on the linux-iio mailing list has some extra insight.

	Arnd
