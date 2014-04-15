Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbaDOVAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 17:00:10 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33924 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaDOVAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 17:00:07 -0400
Message-ID: <534D9DD1.2070004@wwwdotorg.org>
Date: Tue, 15 Apr 2014 15:00:01 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Chen-Yu Tsai <wens@csie.org>, Linus Walleij <linus.walleij@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-sunxi@googlegroups.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 5/7] net: rfkill: gpio: add device tree support
References: <1397544101-18135-1-git-send-email-wens@csie.org> <1397544101-18135-6-git-send-email-wens@csie.org>
In-Reply-To: <1397544101-18135-6-git-send-email-wens@csie.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 12:41 AM, Chen-Yu Tsai wrote:

Patch description?

> diff --git a/Documentation/devicetree/bindings/rfkill/rfkill-gpio.txt b/Documentation/devicetree/bindings/rfkill/rfkill-gpio.txt

> +Required properties:

> +- gpios		: At most two GPIO phandles
> +- gpio-names	: Shall be "reset" or "shutdown", matching gpios.
> +		  If both are provided, the "reset" GPIO is toggled first.

As Maxime mentioned, this is an unusual way of defining GPIOs. If this
new way is acceptable, then I'd suggest more precise wording, e.g.:

- gpios: Must contain an entry for each entry in gpio-names.
  See ../gpio/gpio.txt for details.
- gpio-names: May contain any or all of the following entries:
  - reset
  - shutdown

> +- rfkill-type	: Type of RFKILL device: 1 for WiFi, 2 for BlueTooth, etc.
> +		  See include/uapi/linux/rfkill.h for all valid values

It would be nice if include/dt-bindings/rfkill-gpio.h existed and
contained e.g.:

#define RFKILL_TYPE_BLUETOOTH 2

So that:

> +Example:
> +
> +	rfkill_bt {
...
> +		rfkill-type = <2>;

Could be written as:

		rfkill-type = <RFKILL_TYPE_BLUETOOTH>;

