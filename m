Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbaHGNWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:22:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:42542 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932325AbaHGNWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:22:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,818,1400050800"; 
   d="scan'208";a="584747740"
Message-ID: <1407417714.8334.8.camel@acox1-desk.ger.corp.intel.com>
Subject: Re: [PATCH v2 1/2] tty: serial: 8250: Add Mediatek UART driver
From: Alan Cox <alan@linux.intel.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: linux-kernel@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org,
        gregkh@linuxfoundation.org, jslaby@suse.cz, grant.likely@linaro.org,
        varkabhadram@gmail.com, heiko@sntech.de, yingjoe.chen@gmail.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-serial@vger.kernel.org
Date: Thu, 07 Aug 2014 14:21:54 +0100
In-Reply-To: <1407394292-26317-2-git-send-email-matthias.bgg@gmail.com>
References: <1407394292-26317-1-git-send-email-matthias.bgg@gmail.com>
	 <1407394292-26317-2-git-send-email-matthias.bgg@gmail.com>
Organization: Intel Corporation
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +	 * Some baudrates are not supported by the chip, so we use the next
> +	 * lower rate supported and update termios c_flag.

I don't see the termios updating being done now ?

> +	data->clk = of_clk_get(np, 0);
> +	if (IS_ERR(data->clk)) {
> +		pr_warn("Can't get timer clock");
> +		return PTR_ERR(data->clk);
> +	}
> +
> +	err = clk_prepare_enable(data->clk);
> +	if (err) {
> +		pr_warn("Can't prepare clock");

and these do need a newline on them. They are also not very useful as
they don't indicate what device was involved. If you passed pdev from
mtk8250_probe you'd be able to use dev_warn instead

Otherwise looks great and exactly as 8250_core is intended to be used.

Alan


