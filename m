Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077AbaAHQIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 11:08:43 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:60931 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850AbaAHQIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 11:08:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH v3 1/2] Documentation: Add GPIO reset binding to reset binding documentation
Date: Wed, 8 Jan 2014 17:08:26 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Roger Quadros <rogerq@ti.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Stephen Warren <swarren@wwwdotorg.org>
References: <1389179464-11963-1-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1389179464-11963-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201401081708.26679.arnd@arndb.de>
X-Provags-ID: V02:K0:LpsOs4q1VRQ7WEzBrZIcrF+Bq4eErkASjgSNHNalZPd
 +Uj5zjx3/MT//DRKnMsoMEHMemA32fb8PZ5CNOc1tYqkYUfKA9
 l9A82beGo4iDLBDTDtoG1clK0KPkde7xN4NDdhkyPOi5tXm54F
 rzRVGhVBo6K/mn4Xm+pN6XN6p0IsyVFbdmpB4KeS9bdP8o9lC/
 3WDTo6Jl/tM8DAoVMhTvEweLWWiZtT9aZMpfu9EM8AwOKKhTuL
 SogavFzloKBVyrLaQmdvNATg8Yse9SJmJHyUWiUhKKAs6nw9Xg
 SOTKm2AXJiBj6fzTikDoMkcjpWZOiHgazzw4DuTwU8ER4s3Jwt
 0TpDsAIF0gtiL1t3OhaM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 January 2014, Philipp Zabel wrote:
> += GPIO Reset consumers =
> +
> +For the common case of reset lines controlled by GPIOs, the GPIO binding
> +documented in devicetree/bindings/gpio/gpio.txt should be used:
> +
> +Required properties:
> +reset-gpios or         Reset GPIO using standard GPIO bindings,
> +<name>-reset-gpios:    optionally named to specify the reset line
> +
> +Optional properties:
> +reset-boot-asserted or         Boolean. If set, the corresponding reset is
> +<name>-reset-boot-asserted:    initially asserted and should be kept that way
> +                               until released by the driver.

I don't get this one. Why would you use a different reset binding for the case
where the reset line is connected to the gpio controller rather than a
specialized reset controller?

I was expecting to see the definition of a generic reset controller that
in turn uses gpio lines, like


	reset {	
		compatible = "gpio-reset";
		/* provides three reset lines through these GPIOs */
		gpios = <&gpioA 1 &gpioB 7 <gpioD 17>;
		#reset-cells = <1>;
	};

	foo {
		...
		resets = <&reset 0>; /* uses first reset line of the gpio-reset controller */
	};

I realize it would be a little more verbose, but it also seems more
regular and wouldn't stand out from the rest of the reset interfaces.

	Arnd
