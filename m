Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584Ab3GQQkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:40:00 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:22300 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756503Ab3GQQj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:39:58 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-ed-51e6c8d94fbd
Message-id: <51E6C8D8.4010303@samsung.com>
Date: Wed, 17 Jul 2013 18:39:52 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, devicetree-discuss@lists.ozlabs.org,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3] media: i2c: tvp7002: add OF support
References: <1374078016-17122-1-git-send-email-prabhakar.csengg@gmail.com>
In-reply-to: <1374078016-17122-1-git-send-email-prabhakar.csengg@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t/xy7o3TzwLNNi7Vtfi3K0GVosDsx+y
	WixsW8JicXnXHDaLng1bWS1e3l/B7MDmsXPWXXaPOdOaWDzOz1jI6PF5k1wASxSXTUpqTmZZ
	apG+XQJXxt2T+5kKFghXvDh4jLmB8SZ/FyMnh4SAicSle5dYIGwxiQv31rN1MXJxCAksZZRY
	2LMWyvnEKDF39lomkCpeAS2JZ8cXM4LYLAKqEo1HF4DZbAKGEr1H+8BsUYEAicVLzrFD1AtK
	/Jh8D2yDiICexJIFx5hBbGaBY4wSO7dFgdjCAtYSTXcfsIHYQgJeEv2HnoHN4RTwlph38wIr
	RL2OxP7WaWwQtrzE5jVvmScwCsxCsmIWkrJZSMoWMDKvYhRNLU0uKE5KzzXUK07MLS7NS9dL
	zs/dxAgJ6S87GBcfszrEKMDBqMTDOzHsaaAQa2JZcWXuIUYJDmYlEd6DS54FCvGmJFZWpRbl
	xxeV5qQWH2Jk4uCUamDcyDyLzzv9U5j78vUSrz94TxV9/FlBPHxFwc4dggyhJw9JpU+car9Z
	SnJLnGl6Zifzu+i9QqdOzL6WEPrkhrXpr4Artn8mz7xjY7pLdsu3rOBvwod/hd++EDTxmtSW
	Z5tmPXIUFOhxlXQ6Xz3786XXZuW91QIHZdf7fEp5/KtEubibedvBK1PWKbEUZyQaajEXFScC
	AEAEUiZHAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 06:20 PM, Prabhakar Lad wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> add OF support for the tvp7002 driver.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  This patch depends on https://patchwork.kernel.org/patch/2828800/
>  
>  Changes for v3:
>  1: Fixed review comments pointed by Sylwester.
>  
>  .../devicetree/bindings/media/i2c/tvp7002.txt      |   43 +++++++++++++
>  drivers/media/i2c/tvp7002.c                        |   67 ++++++++++++++++++--
>  2 files changed, 103 insertions(+), 7 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp7002.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/tvp7002.txt b/Documentation/devicetree/bindings/media/i2c/tvp7002.txt
> new file mode 100644
> index 0000000..744125f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/tvp7002.txt
> @@ -0,0 +1,43 @@
> +* Texas Instruments TV7002 video decoder
> +
> +The TVP7002 device supports digitizing of video and graphics signal in RGB and
> +YPbPr color space.
> +
> +Required Properties :
> +- compatible : Must be "ti,tvp7002"
> +
> +- hsync-active: HSYNC Polarity configuration for endpoint.
> +
> +- vsync-active: VSYNC Polarity configuration for endpoint.

I woudn't refer to "endpoint" here, perhaps to the specific hardware
bus instead ? So it is clear what part of the device it refers to ?

> +- pclk-sample: Clock polarity of the endpoint.

This description is not very useful, my feeling is that this property
is better described in video-interfaces.txt.

> +- sync-on-green-active: Active state of Sync-on-green signal property of the
> +  endpoint, 0/1 for normal/inverted operation respectively.
> +
> +- field-even-active: Active-high Field ID polarity of the endpoint.

I find it hard to understand what this property is about exactly.
Not sure if you need to repeat detailed description of the signal
polarity properties. Perhaps its sufficient to list which properties
are relevant for this device, but I'm not opposed to having
supplementary description here. I would just make it more specific
to the TVP7002 chip.
Also please note that only 'compatible' property is required, all
other are optional. And it probably makes sense to specify what are
default values for each property when it is not specified.

Otherwise the patch looks good.

--
Thanks,
Sylwester
