Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbaIXPXE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:23:04 -0400
Received: from mail.kernel.org ([198.145.19.201]:44644 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbaIXPXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:23:02 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: arm@kernel.org, agross@codeaurora.org, galak@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] soc: qcom: do not disable the iface clock in probe
References: <1411500054-13600-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Wed, 24 Sep 2014 08:22:58 -0700
In-Reply-To: <1411500054-13600-1-git-send-email-srinivas.kandagatla@linaro.org>
	(Srinivas Kandagatla's message of "Tue, 23 Sep 2014 20:20:54 +0100")
Message-ID: <7hbnq5m4a5.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srinivas Kandagatla <srinivas.kandagatla@linaro.org> writes:

> since commit 31964ffebbb9 ("tty: serial: msm: Remove direct access to GSBI")'
> serial hangs if earlyprintk are enabled.
>
> This hang is noticed only when the GSBI driver is probed and all the
> earlyprintks before gsbi probe are seen on the console.
> The reason why it hangs is because GSBI driver disables hclk in its
> probe function without realizing that the serial IP might be in use by
> a bootconsole. As gsbi driver disables the clock in probe the
> bootconsole locks up.

> Turning off hclk's could be dangerous if there are system components
> like earlyprintk using the hclk.

This seems rather fragile.  Isn't the right fix for these other
components to use the clk api to ensure the clock does not get enabled?

Kevin
