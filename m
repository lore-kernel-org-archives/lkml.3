Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbaIQPXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 11:23:24 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:53087 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900AbaIQPXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 11:23:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: Re: [PATCH v3] mfd: syscon: Decouple syscon interface from platform devices
Date: Wed, 17 Sep 2014 17:23:04 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, lee.jones@linaro.org,
        tomasz.figa@gmail.com, linux@arm.linux.org.uk,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        thomas.ab@samsung.com, chow.kim@samsung.com, kgene.kim@samsung.com
References: <1410935510-1567-1-git-send-email-pankaj.dubey@samsung.com>
In-Reply-To: <1410935510-1567-1-git-send-email-pankaj.dubey@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201409171723.04549.arnd@arndb.de>
X-Provags-ID: V02:K0:4kMP9wXPLQkAjQVrIjRFkYWfUlwxxL+pzxDAPWd1Ys2
 jt9IpsKAgIYYR+gIgI2aYQfMgNle9uDpyio2KeCa/WK7GYEPPf
 siiz327po7aWLQi2XWioZvWVNGkjkaSuU6Etof8iabdBdD67U0
 imXKCJ78MMBvZIMIpt2mqndO3j8cCEzVkpZ4FlkbW7qMbQ4/mj
 sS8ya0OzveSeZzOGemb5YKMKOHipiv5f58oqCjeKMlK3u3tlFk
 rWZ5Ijb1hnlSykqGA2BRGswzYRn9m5kld+4tlNK5gbq1YD7aK/
 YjaHPIvTe98IJbhYvI10JFagZ/4fHkBMvf+0ikD7UfWJNTyukX
 OE95sgygycBmAyOTV6x6OO8PNos+TAL0TsHmQWRDd
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 September 2014, Pankaj Dubey wrote:
> ---
> V2 of this patchset and related discussion can be found here [1].
> 
> Changes since v2:
>  - Added back platform device support from syscon, with one change that
>    syscon will not be probed for DT based platform.
>  - Added back syscon_regmap_lookup_by_pdevname API so that non-DT base
>    users of syscon will not be broken.
>  - Removed unwanted change in syscon.h.
>  - Modified Signed-off-by list, added Suggested-by of Tomasz Figa and
>    Arnd Bergmann.
>  - Added Tested-by of Vivek Gautam for testing on Exynos platform.

Looks fine. Provided you can figure out the problem that Dong Aisheng
reported, please add my

Acked-by: Arnd Bergmann <arnd@arndb.de>

> -}
> +static struct syscon *of_syscon_register(struct device_node *np);
>

One  minor comment: please avoid doing forward declarations of
local functions. It took me a while to understand what is going on
because I expect all functions to be ordered such that they only get
called by functions below, and don't need this.

Just move of_syscon_register() here directly.

	Arnd
