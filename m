Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbaA0OLC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 09:11:02 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:34770 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbaA0OK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 09:10:59 -0500
MIME-Version: 1.0
In-Reply-To: <1390795167-6677-4-git-send-email-jcmvbkbc@gmail.com>
References: <1390795167-6677-1-git-send-email-jcmvbkbc@gmail.com>
	<1390795167-6677-4-git-send-email-jcmvbkbc@gmail.com>
Date: Mon, 27 Jan 2014 08:10:58 -0600
Message-ID: <CAL_JsqLjn4FXrNGLGHs639TEqmQKPx_kk9JbAd-hn7mexzAjNg@mail.gmail.com>
Subject: Re: [PATCH 3/3] net: ethoc: document OF bindings
From: Rob Herring <robherring2@gmail.com>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-xtensa@linux-xtensa.org, netdev <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        "David S. Miller" <davem@davemloft.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 26, 2014 at 9:59 PM, Max Filippov <jcmvbkbc@gmail.com> wrote:
> Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
> ---
>  .../devicetree/bindings/net/opencores-ethoc.txt    | 25 ++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/opencores-ethoc.txt
>
> diff --git a/Documentation/devicetree/bindings/net/opencores-ethoc.txt b/Documentation/devicetree/bindings/net/opencores-ethoc.txt
> new file mode 100644
> index 0000000..f7c6c94
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/opencores-ethoc.txt
> @@ -0,0 +1,25 @@
> +* OpenCores MAC 10/100 Mbps
> +
> +Required properties:
> +- compatible: Should be "opencores,ethoc".

There are not different versions of IP or is the version probeable?

> +- reg: Address and length of the register set for the device and of its
> +  descriptor memory.
> +- interrupts: Should contain ethoc interrupt.
> +
> +Optional properties:
> +- local-mac-address: 6 bytes, mac address

There's a patch in progress to move all the standard network
properties to a common location, so you can remove this.

> +- clock-frequency: basic MAC frequency.
> +- mii-mgmt-clock-frequency: frequency of MII management bus. Together
> +  with clock-frequency determines the value programmed into the CLKDIV
> +  field of MIIMODER register.
> +
> +Examples:
> +
> +       enet0: ethoc@fd030000 {
> +               compatible = "opencores,ethoc";
> +               reg = <0xfd030000 0x4000 0xfd800000 0x4000>;
> +               interrupts = <1>;
> +               local-mac-address = [00 50 c2 13 6f 00];
> +               clock-frequency = <50000000>;
> +               mii-mgmt-clock-frequency = <5000000>;
> +        };
> --
> 1.8.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
