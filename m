Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaFDVCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:02:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43537 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbaFDVCP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:02:15 -0400
Date: Wed, 4 Jun 2014 23:02:09 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, wsa@the-dreams.de,
        linus.walleij@linaro.org, paul.gortmaker@windriver.com,
        jg1.han@samsung.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        Jim Davis <jim.epost@gmail.com>
Subject: Re: [PATCH] i2c: pca954x: Fix compilation without CONFIG_GPIOLIB
Message-ID: <20140604230209.21182dd3@endymion.delvare>
In-Reply-To: <1401900992-16581-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <CA+r1Zhi9Qd4aZ2WJ02K4Gv=zg7QvG+r=t2VpiXRKXcYRc1vt=A@mail.gmail.com>
	<1401900992-16581-1-git-send-email-laurent.pinchart@ideasonboard.com>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Jun 2014 18:56:32 +0200, Laurent Pinchart wrote:
> The pca954x driver recently switched to the GPIO descriptor API without
> including the correct <linux/gpio/consumer.h> header. This breaks
> compilation without CONFIG_GPIOLIB.
> 
> drivers/i2c/muxes/i2c-mux-pca954x.c: In function ‘pca954x_probe’:
> drivers/i2c/muxes/i2c-mux-pca954x.c:204:2: error: implicit declaration
> of function ‘devm_gpiod_get’ [-Werror=implicit-function-declaration]
>   gpio = devm_gpiod_get(&client->dev, "reset");
>   ^
> drivers/i2c/muxes/i2c-mux-pca954x.c:204:7: warning: assignment makes
> pointer from integer without a cast [enabled by default]
>   gpio = devm_gpiod_get(&client->dev, "reset");
>        ^
> drivers/i2c/muxes/i2c-mux-pca954x.c:206:3: error: implicit declaration
> of function ‘gpiod_direction_output’
> [-Werror=implicit-function-declaration]
>    gpiod_direction_output(gpio, 0);
>    ^
> cc1: some warnings being treated as errors
> make[3]: *** [drivers/i2c/muxes/i2c-mux-pca954x.o] Error 1
> 
> Fix it by including the right header.
> 
> Reported-by: Jim Davis <jim.epost@gmail.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/i2c/muxes/i2c-mux-pca954x.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> (...)

Acked-by: Jean Delvare <jdelvare@suse.de>

-- 
Jean Delvare
SUSE L3 Support
