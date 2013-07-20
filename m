Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab3GTQlA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 12:41:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56472 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab3GTQk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 12:40:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Jensen <jonas.jensen@gmail.com>
Subject: Re: [PATCH v4] watchdog: Add MOXA ART watchdog driver
Date: Sat, 20 Jul 2013 18:40:52 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-watchdog@vger.kernel.org, wim@iguana.be,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, linux@roeck-us.net
References: <1374053091-5907-1-git-send-email-jonas.jensen@gmail.com> <1374229402-20432-1-git-send-email-jonas.jensen@gmail.com>
In-Reply-To: <1374229402-20432-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201307201840.52455.arnd@arndb.de>
X-Provags-ID: V02:K0:d7/PxUsW1CisNjY7pPp7CCZDcGKjHn+l7vTpsyWtwRO
 TEmN5fHh0WWuKCCu3Z9oEcpPUlWrehOGwIxHNxIu69tPeSboLc
 5l5eQC0S1PFqQqccRk9TwSEaDJ+cptFfz/+5lU9v9t5xY3VMps
 qFI+7nuL9xhwYqIOi684I1xxV3O4SyrMp8baSKHojuVO2PMyuG
 EFz3mQ8+XAU4uMsGnGDCAESQBJyNWlyjILhG/QlL1iDOn04kdu
 HIE/pjNQ972G7mz1yPwfIEUUWKU0d0usQtm3+Y2mNywwFLDdm1
 2C56Tvv/F2MMSzwMcxqq/8XMJt435NYAoMBytUzkrCa3V2JEp+
 ksFpDx9L5g5s6wExDBC8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 July 2013, Jonas Jensen wrote:
> diff --git a/Documentation/devicetree/bindings/watchdog/moxa,moxart-watchdog.txt b/Documentation/devicetree/bindings/watchdog/moxa,moxart-watchdog.txt
> new file mode 100644
> index 0000000..5507f2b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/watchdog/moxa,moxart-watchdog.txt
> @@ -0,0 +1,15 @@
> +MOXA ART Watchdog timer
> +
> +Required properties:
> +
> +- compatible : Should be "moxa,moxart-watchdog"
> +- reg : Should contain registers location and length
> +- clocks : Should contain phandle for the MOXA ART core clock "coreclk"
> +
> +Example:
> +
> +       watchdog: watchdog@98500000 {
> +               compatible = "moxa,moxart-watchdog";
> +               reg = <0x98500000 0x10>;
> +               clocks = <&coreclk>;
> +       };

I think the property descriptions need to be clarified here:

* I think "should" makes no sense for the "compatible" property since it is
  required here, you probably mean "must", see http://www.ietf.org/rfc/rfc2119.txt. 

* for the clock, make sure that the description is from the point of view of
  the device you are describing, not from the perspective of the clock controller.
  The device should not make any assumptions about who provides a clock, only
  what it is used for, and it sounds like "coreclk" is an SoC-wide identifier,
  not the name of the clock input of the watchdog device. This is not as important
  as you don't define a "clock-names" property here, butsomething to keep in
  mind anyway.

	Arnd
