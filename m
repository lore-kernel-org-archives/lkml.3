Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151Ab3K1QiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 11:38:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:49214 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab3K1QiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 11:38:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Jensen <jonas.jensen@gmail.com>
Subject: Re: [PATCH v6] gpio: Add MOXA ART GPIO driver
Date: Thu, 28 Nov 2013 17:37:32 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-gpio@vger.kernel.org, grant.likely@linaro.org,
        linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org
References: <1381503190-5733-1-git-send-email-jonas.jensen@gmail.com> <1385651945-22355-1-git-send-email-jonas.jensen@gmail.com>
In-Reply-To: <1385651945-22355-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201311281737.32696.arnd@arndb.de>
X-Provags-ID: V02:K0:ddoi8ebNB/aeX1lYj2kxjAqlfwxL7y18oU/iWSjhY7a
 DDj46D2Hl1KwhwUGUpqrOYpK4EzcQiBissoFGf6I3gbGEVIAJE
 DON29v8VYe62nmMl87FD7KCfVKqHyZ7K/EsugL9vk5JwlVjNZj
 GZmQ/ulf1fgng8L620rMBKcrBstb5SbBEBzn6rIL15D7zWeBAz
 xFO4P1xh79AEYoISzLQL5WcFKfFCkgvLcEGqZ92HiS9uTgiHF3
 GyaTkMOj/eBRAX0h7vpBZay2ZRQwhvvi/fsjVSx53Z7W35F2ln
 Id0x64+jBlau++svGTEl+AeqnU5wah7rjdh9Mv4tkrEyND5xIq
 7zGzL6Jb0VNw8InW/158=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 November 2013, Jonas Jensen wrote:
> +static void __iomem *moxart_gpio_base;

Just one comment: the usual way to do such a driver is to have
a derived data structure like

struct moxart_gpio_chip {
	struct gpio_chip chip;
	void __iomem *moxart_gpio_base;
};

and dynamically allocate that from probe(), using container_of() to
get from the gpio_chip pointer to your own structure.

You obviously rely on the fact that there is only one gpio_chip
in a moxart soc, which is a safe assumption, the only real disadvantage
of your approach is that it makes your driver less suitable as an
example for others to look at when they are not dealing with
just a single instance, so decide for yourself whether you want
to change it or not.

	Arnd
