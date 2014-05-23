Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbaEWJMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:12:34 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60020 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbaEWJMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:12:30 -0400
MIME-Version: 1.0
In-Reply-To: <1400146669-30302-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1400146447-29803-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1400146669-30302-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Fri, 23 May 2014 11:12:29 +0200
Message-ID: <CACRpkdZtHPZpmFA+JfgMn83+SgZZX4CS+MhAcf_sk2cQKqW1Pw@mail.gmail.com>
Subject: Re: [PATCH v2 12/14] mmc: mmci: add support for fbclk to latch data
 and cmd.
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

On Thu, May 15, 2014 at 11:37 AM,  <srinivas.kandagatla@linaro.org> wrote:

> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> This patch adds support to fbclk that is used to latch data and
> cmd on some controllers like SD Card controller in Qcom SOC.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

(...)

Isn't this overkill?

@@ -189,6 +192,7 @@ static struct variant_data variant_qcom = {
         .clkreg                 = MCI_CLK_ENABLE,
-        .clkreg_enable          = MCI_QCOM_CLK_FLOWENA,
+       .clkreg_enable          = MCI_QCOM_CLK_FLOWENA |
MCI_QCOM_CLK_FEEDBACK_CLK,
         .clkreg_8bit_bus_enable = MCI_QCOM_CLK_WIDEBUS_8,

Isn't this achieveing exactly the same thing without the extra fields?
You unconditionally do it at every enable anyway, don't you?

Yours,
Linus Walleij
