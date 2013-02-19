Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934621Ab3BSWHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 17:07:46 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:49461 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933538Ab3BSWHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 17:07:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 10/35] mfd: ab8500-core: Rework MFD sub-device initialisation structures
Date: Tue, 19 Feb 2013 22:07:31 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, linus.walleij@stericsson.com
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org> <1360933026-30325-11-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1360933026-30325-11-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302192207.31465.arnd@arndb.de>
X-Provags-ID: V02:K0:Xz4T7KTqZgqL1cybWP9pXsHoIRuqnpfH2pTKU1eKnNE
 miADOUfXMeIi+QJzqnkjruDkjLAp283gMS0LwX3fIR+E5dweeY
 BXcbXS4kcFbLEzHZILmqBq+7iR7CQpgjtFF2PlA923ktoLTj1K
 YZEZu9FG9a9boWRtG3ZuGTAmX4/5uBJRmI2gDZBvM7OvRodjGn
 zMTUQ1KO9jIs0r+4mIejJe9+EhLlrCHe/+gvX0q1D3zR2ABII/
 0nTtJKaVkv4vzG74NL3SBQ+wKQEaUyMNji0q7ka/QAyWtpm3W+
 IsDk5/Ry0LrJiP2dAO7L5XEhCL5zGYnRkY9XRjuBvMd/tBmtoy
 OJ6kalMjx6dKb3lrr3HI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 February 2013, Lee Jones wrote:
> +       {
> +               .name = "ab8500-charger",
> +               .of_compatible = "stericsson,ab8500-charger",
> +               .num_resources = ARRAY_SIZE(ab8500_charger_resources),
> +               .resources = ab8500_charger_resources,
> +#ifndef CONFIG_OF
> +               .platform_data = &ab8500_bm_data,
> +               .pdata_size = sizeof(ab8500_bm_data),
> +#endif
> +       },

Is this #ifdef correct? I would have expected "#ifdef CONFIG_ATAGS" here.

	Arnd
