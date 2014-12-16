Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393AbaLPQlq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:41:46 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:9896 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaLPQlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:41:44 -0500
Message-ID: <549060B9.6060506@imgtec.com>
Date: Tue, 16 Dec 2014 16:41:29 +0000
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: <davem@davemloft.net>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <paul.burton@imgtec.com>
Subject: Re: [PATCH] dm9000: Add regulator and reset support to dm9000
References: <1418747624-2682-1-git-send-email-Zubair.Kakakhel@imgtec.com>
In-Reply-To: <1418747624-2682-1-git-send-email-Zubair.Kakakhel@imgtec.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 16/12/14 16:33, Zubair Lutfullah Kakakhel wrote:
...

> +
> +	power = devm_regulator_get(dev, "vcc");
> +	if (IS_ERR(power)) {
> +		dev_dbg(dev, "no regulator provided\n");
> +	} else if (!regulator_is_enabled(power)) {
> +		ret = regulator_enable(power);
> +		dev_dgb(dev, "regulator enabled\n");
		^dev_dbg

Apologies. This fix wasn't squashed in. I'll resend.

> +	}
> +
> +	reset_gpio = of_get_named_gpio_flags(dev->of_node, "reset-gpio", 0,
> +					     &flags);

ZubairLK
