Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbaDCTvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 15:51:18 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:64037 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbaDCTvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 15:51:11 -0400
MIME-Version: 1.0
In-Reply-To: <1396547967-19260-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1396547967-19260-1-git-send-email-soren.brinkmann@xilinx.com>
Date: Thu, 3 Apr 2014 14:51:09 -0500
Message-ID: <CAL_Jsq+vOHzca_wT9ADHRxhR9dT8FYGP-iTvd5=zKrRVBZz-cw@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] i2c: cadence: Document device tree bindings
From: Rob Herring <robherring2@gmail.com>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Mike Looijmans <mike.looijmans@topic.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Harini Katakam <harinik@xilinx.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2014 at 12:59 PM, Soren Brinkmann
<soren.brinkmann@xilinx.com> wrote:
> Add device tree binding documentation for the Cadence I2C controller.
>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>
> Changes in v4:
>  - moved adding DT docs into this dedicated patch
>
> Changes in v3: None
> Changes in v2: None
>
> ---
>  .../devicetree/bindings/i2c/i2c-cadence.txt         | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/i2c/i2c-cadence.txt
>
> diff --git a/Documentation/devicetree/bindings/i2c/i2c-cadence.txt b/Documentation/devicetree/bindings/i2c/i2c-cadence.txt
> new file mode 100644
> index 000000000000..685adf513111
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/i2c/i2c-cadence.txt
> @@ -0,0 +1,21 @@
> +Binding for the Cadence I2C controller
> +
> +Required properties:
> +  compatible: Compatibility string. Must be 'cdns,i2c-r1p10'.
> +  clocks: From common clock bindings. Phandle to input clock.
> +
> +Optional properties:
> +  clock-frequency: Desired operating frequency, in Hz, of the bus (actual may
> +                  be lower). Defaults to 400000 if not specified.

Since not all devices support 400kHz, I would prefer that the default
be 100kHz. Also, it would be good if what speed the default is
consistent across i2c drivers.

Rob
