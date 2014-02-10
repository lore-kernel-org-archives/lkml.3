Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbaBJKQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:16:57 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:36531 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbaBJKQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:16:54 -0500
MIME-Version: 1.0
In-Reply-To: <CAOMZO5CzUuQrmbk6FpFGR56jHBtW-1d_AGcdgB2xyMG0Nkf+Fw@mail.gmail.com>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
	<1391529538-21685-15-git-send-email-ulf.hansson@linaro.org>
	<CAOMZO5CzUuQrmbk6FpFGR56jHBtW-1d_AGcdgB2xyMG0Nkf+Fw@mail.gmail.com>
Date: Mon, 10 Feb 2014 11:16:53 +0100
Message-ID: <CAPDyKFphK8Zo1i7=w-n-VbGWpmLvUZs_U2Ekq0NCeqVxZ7VKvw@mail.gmail.com>
Subject: Re: [PATCH 14/17] i2c: nomadik: Fixup deployment of runtime PM
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 February 2014 15:45, Fabio Estevam <festevam@gmail.com> wrote:
> On Tue, Feb 4, 2014 at 1:58 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>
>> +static int nmk_i2c_runtime_resume(struct device *dev)
>> +{
>> +       struct amba_device *adev = to_amba_device(dev);,
>> +       struct nmk_i2c_dev *nmk_i2c = amba_get_drvdata(adev);
>> +
>> +       clk_prepare_enable(nmk_i2c->clk);
>
> Previously the code was checking the return value from
> clk_prepare_enable(). You should keep the check here.

Will fix in v2! Thanks for reviewing!

Kind regards
Ulf Hansson

>
> Regards,
>
> Fabio Estevam
