Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbaCTM1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 08:27:35 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:46838 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757872AbaCTM1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 08:27:33 -0400
Message-ID: <532ADFD8.80301@gmail.com>
Date: Thu, 20 Mar 2014 13:32:24 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: Jean-Francois Moine <moinejf@free.fr>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org
CC: dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: tda998x: Fix lack of required reg in DT documentation
References: <20140320092639.48F68A6279@smtp3-g21.free.fr>
In-Reply-To: <20140320092639.48F68A6279@smtp3-g21.free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 09:58 AM, Jean-Francois Moine wrote:
> The I2C address (reg) is required for the TDA998x driver to be loaded
> and initialized.
>
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
> This patch applies to linux-next.
> ---
>   Documentation/devicetree/bindings/drm/i2c/tda998x.txt | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
> index d7df01c..fc7effa 100644
> --- a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
> +++ b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
> @@ -3,6 +3,8 @@ Device-Tree bindings for the NXP TDA998x HDMI transmitter
>   Required properties;
>     - compatible: must be "nxp,tda998x"
>
> +  - reg: I2C address - must be <0x70>

TDA9983b datasheet says:

"Bits A0 and A1 of the I2C-bus device address are externally selected
by pins A0 and A1."

Therefore, 0x70, 0x71, 0x72, and 0x73 are valid i2c addresses.

Sebastian

>   Optional properties:
>     - interrupts: interrupt number and trigger type
>   	default: polling
>

