Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbaILP4O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 11:56:14 -0400
Received: from s250.sam-solutions.net ([217.21.49.219]:58218 "EHLO
	s250.sam-solutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbaILP4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 11:56:12 -0400
Message-ID: <54131782.2000204@sam-solutions.net>
Date: Fri, 12 Sep 2014 18:55:46 +0300
From: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.net>
Organization: SaM Solutions
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <shawn.guo@freescale.com>, <kernel@pengutronix.de>,
        <linux@arm.linux.org.uk>, <perex@perex.cz>, <tiwai@suse.de>,
        <timur@tabi.org>, <nicoleotsuka@gmail.com>, <Li.Xiubo@freescale.com>,
        <grant.likely@linaro.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <alsa-devel@alsa-project.org>
Subject: Re: [PATCH 1/5] ARM: dts: pbab01: move i2c pins and frequency configuration
 into pfla02
References: <1410356809-26179-1-git-send-email-d.lavnikevich@sam-solutions.com>	 <1410356809-26179-2-git-send-email-d.lavnikevich@sam-solutions.com> <1410425238.4011.18.camel@paszta.hi.pengutronix.de>
In-Reply-To: <1410425238.4011.18.camel@paszta.hi.pengutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.117.165]
X-ClientProxiedBy: S326.sam-solutions.net (217.21.35.11) To
 S326.sam-solutions.net (217.21.35.11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/14 11:47, Philipp Zabel wrote:
> Am Mittwoch, den 10.09.2014, 16:46 +0300 schrieb Dmitry Lavnikevich:
>> Since pins and frequency are specific to module (pfla02), not base board
>> (pbab02), it is better to be initialized in corresponding dts file.
>>
>> Signed-off-by: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
> I have seen boards use the GPIO_3/6 pads instead of EIM_D17/D18 for
> I2C3, but the EIM_D17/D18 are indeed documented as "I2C1" pins at the
> pfla02 connector level.
>
> regards
> Philipp
>
Yes, that is why I thought about moving it into pfla02. But apart from
it, i2c2grp i2c3grp nodes was wrongly placed under iomuxc node while
it should be grouped inside of it, like in imx6q-phytec-pfla02 to
which it was moved with this patch.
Because of this specified i2c wasn't working correctly and caused
messages:

imx6q-pinctrl 20e0000.iomuxc: no groups defined in 
/soc/aips-bus@02000000/iomuxc@020e0000/i2c2grp
imx6q-pinctrl 20e0000.iomuxc: no groups defined in 
/soc/aips-bus@02000000/iomuxc@020e0000/i2c3grp
imx6q-pinctrl 20e0000.iomuxc: unable to find group for node i2c2grp
imx6q-pinctrl 20e0000.iomuxc: unable to find group for node i2c3grp

Added this into commit message with new patchset.

Best regards,
Lavnikevich Dmitry
