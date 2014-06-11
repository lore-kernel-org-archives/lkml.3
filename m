Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160AbaFKMqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 08:46:13 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:40952 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbaFKMqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 08:46:11 -0400
MIME-Version: 1.0
In-Reply-To: <1401700137-11547-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1401699818-11329-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1401700137-11547-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Wed, 11 Jun 2014 14:46:10 +0200
Message-ID: <CACRpkdb2=nhsaGksvArSJf8o0-CJH9uUXz7x53cJBCi_G7N-FA@mail.gmail.com>
Subject: Re: [PATCH v6 03/12] mmc: mmci: Add enough delay between writes to
 CMD register.
From: Linus Walleij <linus.walleij@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2014 at 11:08 AM,  <srinivas.kandagatla@linaro.org> wrote:

> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> On Qcom SD Card controller POWER, CLKCTRL, DATACTRL and COMMAND registers
> should be updated in MCLK domain, and writes to these registers must be
> separated by three MCLK cycles. This resitriction is not applicable for
> other registers. Any subsequent writes to these register will be ignored
> until 3 MCLK have passed.
>
> One usec delay between two CMD register writes is not sufficient in the
> card identification phase where the CCLK is very low. This patch replaces
> a static 1 usec delay to use mmci_reg_delay function which can provide
> correct delay depending on the cclk frequency.
>
> Without this patch the card is not detected.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
