Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaKEEsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 23:48:17 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:53672 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbaKEEsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 23:48:15 -0500
Message-ID: <5459AC0C.8080703@wwwdotorg.org>
Date: Tue, 04 Nov 2014 21:48:12 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Scott Branden <sbranden@broadcom.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Peter Griffin <peter.griffin@linaro.org>,
        Chris Ball <chris@printf.net>, Piotr Krol <pietrushnic@gmail.com>
CC: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, linux-rpi-kernel@lists.infradead.org,
        Ray Jui <rjui@broadcom.com>, bcm-kernel-feedback-list@broadcom.com
Subject: Re: [PATCHv2 2/5] mmc: sdhci-bcm2835: make shift calculations consistent
References: <Scott Branden <sbranden@broadcom.com> <1414651017-3545-1-git-send-email-sbranden@broadcom.com> <1414651017-3545-3-git-send-email-sbranden@broadcom.com>
In-Reply-To: <1414651017-3545-3-git-send-email-sbranden@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2014 12:36 AM, Scott Branden wrote:
> Make the shift calculations consistent rather than having different
> implementations to calculate the same thing.

> diff --git a/drivers/mmc/host/sdhci-bcm2835.c b/drivers/mmc/host/sdhci-bcm2835.c

> +#define REG_OFFSET_IN_BITS(reg) ((reg) << 3 & 0x18)

This should really be the following so people don't have to memorize
operator precedence:

#define REG_OFFSET_IN_BITS(reg) (((reg) << 3) & 0x18)

(I've been bit by people mis-remembering precedence in very similar code...)
