Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbaFKMwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 08:52:05 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:58754 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaFKMwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 08:52:03 -0400
MIME-Version: 1.0
In-Reply-To: <1401700204-11876-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1401699818-11329-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1401700204-11876-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Wed, 11 Jun 2014 14:52:02 +0200
Message-ID: <CACRpkdZ-gjoJxnAWNHFzkaRWGvrC0nePBQyBhZ41oWYv1tRxAw@mail.gmail.com>
Subject: Re: [PATCH v6 11/12] mmc: mmci: Add Qcom specific rx_fifocnt logic.
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

On Mon, Jun 2, 2014 at 11:10 AM,  <srinivas.kandagatla@linaro.org> wrote:

> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> MCIFIFOCNT register behaviour on Qcom chips is very different than the other
> pl180 integrations. MCIFIFOCNT register contains the number of
> words that are still waiting to be transferred through the FIFO. It keeps
> decrementing once the host CPU reads the MCIFIFO. With the existing logic and
> the MCIFIFOCNT behaviour, mmci_pio_read will loop forever, as the FIFOCNT
> register will always return transfer size before reading the FIFO.
>
> Also the data sheet states that "This register is only useful for debug
> purposes and should not be used for normal operation since it does not reflect
> data which may or may not be in the pipeline".
>
> This patch implements a qcom specific get_rx_fifocnt function which is
> implemented based on status register flags. Based on qcom_fifo flag in
> variant data structure, the corresponding get_rx_fifocnt function is selected.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
