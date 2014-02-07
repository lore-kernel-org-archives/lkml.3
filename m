Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbaBGKyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 05:54:09 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30651 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbaBGKyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 05:54:06 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-ee-52f4bb4c28b4
Message-id: <1391770442.12119.4.camel@AMDC1943>
Subject: Re: [PATCH v2 08/15] mfd: max77836: Add max77836 support to max14577
 driver
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Fri, 07 Feb 2014 11:54:02 +0100
In-reply-to: <20140207104912.GJ14727@lee--X1>
References: <1391767487-10017-1-git-send-email-k.kozlowski@samsung.com>
 <1391767487-10017-9-git-send-email-k.kozlowski@samsung.com>
 <20140207104912.GJ14727@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t/xK7o+u78EGew7IWexccZ6VoupD5+w
	WVz/8pzV4mzTG3aL+1+PMlpsenyN1eLyrjlsFmuP3GW3uN24gs3idDerA5fHplWdbB53ru1h
	85h3MtBj85J6j74tqxg9Pm+SC2CL4rJJSc3JLEst0rdL4MroefOPsWAOT8WDJ1+YGhjvc3Yx
	cnJICJhIbP/4lAXCFpO4cG89WxcjF4eQwFJGibZfDcwQzmdGiXUz37OCVPEK6Ev0vn7NDmIL
	C4RJTFz/CKybTcBYYvPyJUDdHBwiAioS596Yg/QyC3xjkrg37RZYDYuAqsSfnj9gNqeArsSE
	7V9ZIBasYJSYtnkmI0iCWUBdYtK8RcwQJylJ7G7vZIeIy0tsXvOWGeIIQYkfk++xTGAUmIWk
	ZRaSsllIyhYwMq9iFE0tTS4oTkrPNdIrTswtLs1L10vOz93ECImFrzsYlx6zOsQowMGoxMOr
	uOJzkBBrYllxZe4hRgkOZiURXskNX4KEeFMSK6tSi/Lji0pzUosPMTJxcEo1MCazykxZbH+9
	zeKwcOzaDZVRu7yNjid6SNavNI1s2rN7hW/2N/1Vim83vdt07XOjrUhB89Ov/rULV69b2zBz
	/ynl2GMfrdbFn+J9feTrjaApWZb2+gLaVtyKT65cUAuoblv54/1PnRW/7Tr7J8Yssdy9iXGt
	NoupbM35Xf8Pc174+vOExaQZuguVWIozEg21mIuKEwFjDxkqYwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-07 at 10:49 +0000, Lee Jones wrote:
> > Add Maxim 77836 support to max14577 driver. The chipsets have same MUIC
> > component so the extcon, charger and regulators are almost the same. The
> > max77836 however has also PMIC and Fuel Gauge.
> > 
> > The MAX77836 uses three I2C slave addresses and has additional interrupts
> > (related to PMIC and Fuel Gauge). It has also Interrupt Source register,
> > just like MAX77686 and MAX77693.
> > 
> > The MAX77836 PMIC's TOPSYS and INTSRC interrupts are reported in the
> > PMIC block. The PMIC block has different I2C slave address and uses own
> > regmap so another regmap_irq_chip is needed.
> > 
> > Since we have two regmap_irq_chip, use shared interrupts on MAX77836.
> > 
> > This patch adds additional defines and functions to the max14577 MFD core
> > driver so the driver will handle both chipsets. Also this patch replaces
> > "0x1 << N" with BIT(N) in defines for register masks.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> 
> My Ack is missing from this patch too.
> 
> ... and probably all the others? How will I know which ones I've
> already Acked without reviewing them all again?

I already added your ACK-s to patches which got them. Unfortunately the
numbering of patches changed because 4 of them were applied and 1 was
dropped.

This particular patch (previously: 13/18) haven't got you ACK because
you've pointed some issues to fix.

Best regards,
Krzysztof

