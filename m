Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab3HGQiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:38:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43462 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757082Ab3HGQiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:38:06 -0400
Date: Wed, 7 Aug 2013 17:38:04 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "kishon@ti.com" <kishon@ti.com>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "broonie@kernel.org" <broonie@kernel.org>
Subject: Re: [PATCH V4] drivers/rtc/rtc-palmas.c: support for backup
 battery charging
Message-ID: <20130807163804.GL28558@e106331-lin.cambridge.arm.com>
References: <1375871392-871-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375871392-871-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 11:29:52AM +0100, Laxman Dewangan wrote:
> Palmas series device like TPS65913, TPS80036 supports the backup battery
> for powering the RTC when no other energy source is available.
> 
> The backup battery is optional, connected to the VBACKUP pin, and can be
> nonrechargeable or rechargeable. The rechargeable battery can be charged
> from the system supply using the backup battery charger.
> 
> Add support for enabling charging of this backup battery.  Also add the DT
> binding document and the new properties to have this support.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Reviewed-by: Stephen Warren <swarren@nvidia.com>
> Reviewed-by: Felipe Balbi <balbi@ti.com>
> ---
> Changes from V1:
> - Converted DT property to boolean.
> - cleanups as use "...".
> Changes from V2:
> - Correct the property name.
> Changes from V3:
> - Nit cleanups: properly capatilise the palmas to make it Palmas.
> - Added reviewed by of Felipe and Stephen.
> 
>  .../devicetree/bindings/rtc/rtc-palmas.txt         |   29 ++++++++++++++++
>  drivers/rtc/rtc-palmas.c                           |   35 ++++++++++++++++++++
>  2 files changed, 64 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/rtc/rtc-palmas.txt
> 
> diff --git a/Documentation/devicetree/bindings/rtc/rtc-palmas.txt b/Documentation/devicetree/bindings/rtc/rtc-palmas.txt
> new file mode 100644
> index 0000000..41bb445
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rtc/rtc-palmas.txt
> @@ -0,0 +1,29 @@
> +Palmas RTC controller bindings
> +
> +Required properties:
> +- compatible:
> +  - "ti,palmas-rtc" for Palmas series of the RTC controller
> +- interrupt-parent: Parent interrupt device, must be handle of Palmas node.
> +- interrupts: Interrupt number of RTC submodule on device.
> +
> +Optional properties:
> +- ti,back-battery-charge-enable: The Palmas series device like TPS65913 or
> +	TPS80036 supports the battery backup for powering the RTC when main
> +	battery is removed or in very low power state. This flag will enable
> +	the backup battery charging.

I don't like the wording here as it implies that an OS *must* charge the
device, rather than that it *can* charge the device. How about:

 - ti,backup-battery-chargeable: There is a chargeable backup battery
                                 present.

> +- ti,back-battery-charge-low-current: Configure lower charging current. Device
> +	supports the charging current as < 100mA or >100mA. Low current will
> +	set as <100mA.

This is somewhat unclear as it reads as a runtime configuration choice,
rather than some instances of the device only support being changed at
low currents (as I assume is the case?). How about:

  - ti,backup-battery-low-current: The backup battery is only chargeable
                                   at currents below 100mA.

What happens if we charge at the wrong current?

Thanks,
Mark.
