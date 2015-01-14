Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbbANVrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:47:37 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:45658 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbbANVrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:47:35 -0500
Date: Wed, 14 Jan 2015 16:47:32 -0500 (EST)
Message-Id: <20150114.164732.1058665183210615359.davem@davemloft.net>
To: Zubair.Kakakhel@imgtec.com
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, s.hauer@pengutronix.de,
        sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH_V4] dm9000: Add regulator and reset support to dm9000
From: David Miller <davem@davemloft.net>
In-Reply-To: <1421231777-12589-1-git-send-email-Zubair.Kakakhel@imgtec.com>
References: <1421231777-12589-1-git-send-email-Zubair.Kakakhel@imgtec.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 14 Jan 2015 13:47:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
Date: Wed, 14 Jan 2015 10:36:17 +0000

> +	power = devm_regulator_get(dev, "vcc");
> +	if (PTR_ERR(power) == -EPROBE_DEFER)
> +		return -EPROBE_DEFER;
> +	if (IS_ERR(power)) {
> +		dev_dbg(dev, "no regulator provided\n");

I know it may seem silly, but to me it is more logical to always
guard PTR_ERR() uses with IS_ERR().

Therefore could you please restructure this as:

	if (IS_ERR(power)) {
		if (PTR_ERR(power) == -EPROBE_DEFER)
			return -EPROBE_DEFER;
		else
			dev_dbg(dev, "no regulator provided\n");
	} else {

Thanks.
