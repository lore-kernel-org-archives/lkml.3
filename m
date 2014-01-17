Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaAQQs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 11:48:29 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:55748 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaAQQs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 11:48:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC 4/6] net: rfkill: gpio: add device tree support
Date: Fri, 17 Jan 2014 17:47:45 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Chen-Yu Tsai" <wens@csie.org>, Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-sunxi@googlegroups.com, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
References: <1389941251-32692-1-git-send-email-wens@csie.org> <1389941251-32692-5-git-send-email-wens@csie.org>
In-Reply-To: <1389941251-32692-5-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401171747.46332.arnd@arndb.de>
X-Provags-ID: V02:K0:TaXRmxm6C4k1Q9+d831jz41rjZct7hdfV5ET1PSp07l
 C8Yh30T5+m8XFzjO3/M9XFFIQFloJMhJQQ8s4azU3dphMZzqLB
 GybCyG6MoBMCny6NjVOOvKYbx55stXzClDLk49Xc2R3Ho5jxcH
 Vg8/ly3AHU8H1sYiwTqMs3kOrMlsHDoOhROXZ0fpOMC7eAL9A2
 xPTGWdnN3QGE1hk0hRjjTikDK67lHdL5sE432vae1aYXIfOmxp
 HKuaZeEcmyu13sPqM+7I8Z5nEnZ+kkvfdDUlu31QcPkjFQqH0/
 wEIhLunpYX4HClHkbNWc1gzppbleEmgL26Yyx/JVTl64ES6/u6
 9MRgY4VQ4b/WiSO0m82U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 January 2014, Chen-Yu Tsai wrote:
> diff --git a/Documentation/devicetree/bindings/rfkill/rfkill-gpio.txt b/Documentation/devicetree/bindings/rfkill/rfkill-gpio.txt
> new file mode 100644
> index 0000000..8a07ea4
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rfkill/rfkill-gpio.txt
> @@ -0,0 +1,26 @@
> +GPIO controlled RFKILL devices
> +
> +Required properties:
> +- compatible   : Must be "rfkill-gpio".
> +- rfkill-name  : Name of RFKILL device
> +- rfkill-type  : Type of RFKILL device: 1 for WiFi, 2 for BlueTooth
> +- NAME_shutdown-gpios  : GPIO phandle to shutdown control
> +                         (phandle must be the second)
> +- NAME_reset-gpios     : GPIO phandle to reset control
> +
> +NAME must match the rfkill-name property. NAME_shutdown-gpios or
> +NAME_reset-gpios, or both, must be defined.
> +

I don't understand this part. Why do you include the name in the
gpios property, rather than just hardcoding the property strings
to "shutdown-gpios" and "reset-gpios"?

The description of hte "rfkill-name" property seems to suggest
that you can only have one logical RFKILL device per device node,
so he names would not be ambiguous.

	Arnd
