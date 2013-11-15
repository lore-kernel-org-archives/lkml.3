Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529Ab3KOLbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 06:31:32 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50292 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758464Ab3KOLbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 06:31:23 -0500
Date: Fri, 15 Nov 2013 11:31:06 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: Re: [PATCH] rtc: rtc-ds1742: Add devicetree support
Message-ID: <20131115113106.GG1709@e106331-lin.cambridge.arm.com>
References: <1384432362-26102-1-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384432362-26102-1-git-send-email-shc_work@mail.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 12:32:42PM +0000, Alexander Shiyan wrote:
> This patch allows the driver to be enabled with devicetree.
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ---
>  Documentation/devicetree/bindings/rtc/maxim,ds1742.txt | 14 ++++++++++++++
>  drivers/rtc/rtc-ds1742.c                               | 10 +++++++++-
>  2 files changed, 23 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/rtc/maxim,ds1742.txt
> 
> diff --git a/Documentation/devicetree/bindings/rtc/maxim,ds1742.txt b/Documentation/devicetree/bindings/rtc/maxim,ds1742.txt
> new file mode 100644
> index 0000000..d2ddd71
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rtc/maxim,ds1742.txt
> @@ -0,0 +1,14 @@
> +* Maxim (Dallas) DS1742/DS1743 Real Time Clock
> +
> +Register a Maxim DS1742-compatible RTC.

The driver registration has nothing to do with the binding.

Either add a brief description of the device or remove this line
entirely.

> +
> +Required properties:
> +- compatible: Should be "maxim,ds1742".

s/be/contain/

> +- reg: Physical base address of the RTC and length of memory
> +  mapped region.
> +
> +Example:
> +	rtc: rtc@10000000 {
> +		compatible = "maxim,ds1742";
> +		reg = <0x10000000 0x800>;
> +	};

Otherwise this binding looks fine to me, with those changes.

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.
