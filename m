Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbaJ0WuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 18:50:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49346 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbaJ0WuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 18:50:17 -0400
Message-ID: <544ECAB2.3060706@wwwdotorg.org>
Date: Mon, 27 Oct 2014 16:44:02 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Matthias Klein <matthias.klein@linux.com>,
        linux-rpi-kernel@lists.infradead.org, linus.walleij@linaro.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] pinctrl: bcm2835: Start GPIO numeration at zero
References: <1414447799-1284-1-git-send-email-matthias.klein@linux.com>
In-Reply-To: <1414447799-1284-1-git-send-email-matthias.klein@linux.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 04:09 PM, Matthias Klein wrote:
> Numerate the GPIOs from 0..53 instead of 202..255.

What's the motivation for this? The GPIO IDs should all come from DT, 
which encodes everything as an ID relative to a particular controllers, 
and hence the actual value of the base address should be irrelevant.

> diff --git a/drivers/pinctrl/pinctrl-bcm2835.c b/drivers/pinctrl/pinctrl-bcm2835.c

> @@ -382,7 +382,7 @@ static struct gpio_chip bcm2835_gpio_chip = {

> -	.base = -1,
> +	.base = 0,

