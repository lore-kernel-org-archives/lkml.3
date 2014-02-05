Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbaBEOp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 09:45:57 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:56819 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaBEOpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 09:45:55 -0500
MIME-Version: 1.0
In-Reply-To: <1391529538-21685-15-git-send-email-ulf.hansson@linaro.org>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
	<1391529538-21685-15-git-send-email-ulf.hansson@linaro.org>
Date: Wed, 5 Feb 2014 12:45:54 -0200
Message-ID: <CAOMZO5CzUuQrmbk6FpFGR56jHBtW-1d_AGcdgB2xyMG0Nkf+Fw@mail.gmail.com>
Subject: Re: [PATCH 14/17] i2c: nomadik: Fixup deployment of runtime PM
From: Fabio Estevam <festevam@gmail.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        Mark Brown <broonie@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 1:58 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:

> +static int nmk_i2c_runtime_resume(struct device *dev)
> +{
> +       struct amba_device *adev = to_amba_device(dev);,
> +       struct nmk_i2c_dev *nmk_i2c = amba_get_drvdata(adev);
> +
> +       clk_prepare_enable(nmk_i2c->clk);

Previously the code was checking the return value from
clk_prepare_enable(). You should keep the check here.

Regards,

Fabio Estevam
