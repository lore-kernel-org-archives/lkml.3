Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbaLVDCW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 22:02:22 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:34211 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948AbaLVDCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 22:02:20 -0500
Date: Sun, 21 Dec 2014 19:02:15 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: randconfig build error with next-20141219, in
 drivers/input/misc/regulator-haptic.c
Message-ID: <20141222030215.GD30082@dtor-ws>
References: <CA+r1Zhh3u_JMnvvYaXD81ew--H_t9exuX-xvuNw8n=OPA-PWNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+r1Zhh3u_JMnvvYaXD81ew--H_t9exuX-xvuNw8n=OPA-PWNA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 09:13:02AM -0700, Jim Davis wrote:
> Building with the attached random configuration file,
> 
> drivers/input/misc/regulator-haptic.c: In function ‘regulator_haptic_probe’:
> drivers/input/misc/regulator-haptic.c:184:2: error: implicit
> declaration of function ‘devm_regulator_get_exclusive’
> [-Werror=implicit-function-declaration]
>   haptic->regulator = devm_regulator_get_exclusive(&pdev->dev, "haptic");
>   ^
> drivers/input/misc/regulator-haptic.c:184:20: warning: assignment makes pointer
> from integer without a cast [enabled by default]
>   haptic->regulator = devm_regulator_get_exclusive(&pdev->dev, "haptic");
>                     ^
> cc1: some warnings being treated as errors
> make[3]: *** [drivers/input/misc/regulator-haptic.o] Error 1

Thanks, I'll add the missing dependency on CONFIG_REGULATOR.

-- 
Dmitry
