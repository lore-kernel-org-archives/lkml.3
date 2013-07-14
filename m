Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab3GNT67 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 15:58:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50358 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab3GNT66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 15:58:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Jensen <jonas.jensen@gmail.com>
Subject: Re: [PATCH v2] rtc: Add MOXA ART RTC driver
Date: Sun, 14 Jul 2013 21:58:43 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: rtc-linux@googlegroups.com, a.zummo@towertech.it,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, broonie@kernel.org
References: <1373464848-28146-1-git-send-email-jonas.jensen@gmail.com> <1373550711-18828-1-git-send-email-jonas.jensen@gmail.com>
In-Reply-To: <1373550711-18828-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201307142158.44027.arnd@arndb.de>
X-Provags-ID: V02:K0:eqEcej3rPiIfElY9pAsA3TUckvb5WiqOEp62i3pY7ON
 BG/9DteQLPfGVE2tkWU4iuuwiTWR/F+XXrWNHsHA/YY0dK2Frv
 6OcDj+cQ+B4lSC/k6sIorOSilyvfYVEalgK3ZLJK7VfCA7jMzg
 9wDgLoy3Zu6TjZH8UcDsabS7ZNy8+zodRG29lCY3GwlVF5BHpb
 sEj8YabPisJAJsGpM/Zve/wWrIzM8Onk7cFikMFfcT9JOQ2yEo
 WDH4cn1AhJCZGa1jjloam8mOQR5Qke9YyHr93PR38zDcF6FhAU
 /AWhhnON8/AdnosaIq9WP+Whwy7H49CKY2U9oCge3M8ZjD729O
 iStKphMIBLBXfWTTHOgw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 July 2013, Jonas Jensen wrote:
> Add RTC driver for MOXA ART SoCs.
> +
> +#define GPIO_EM1240_OUTPUT			1
> +#define GPIO_EM1240_INPUT			0
> +
> +#define GPIO_RTC_SCLK				(5)
> +#define GPIO_RTC_DATA				(6)
> +#define GPIO_RTC_RESET				(7)

Since this is a DT-only platform, you should not really have hardcoded GPIO
numbers.

> +	devm_gpio_request(&pdev->dev, GPIO_RTC_DATA, "rtc_data");
> +	devm_gpio_request(&pdev->dev, GPIO_RTC_SCLK, "rtc_sclk");
> +	devm_gpio_request(&pdev->dev, GPIO_RTC_RESET, "rtc_reset");

Instead, you should use of_get_named_gpio() here, and add a binding document
that describes the names.

	Arnd
