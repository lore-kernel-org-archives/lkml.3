Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbaIKPVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:21:47 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47470 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750827AbaIKPVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:21:46 -0400
Date: Thu, 11 Sep 2014 12:20:30 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mtd: nand: atmel_nand: retrieve NFC clock
Message-ID: <20140911152029.GA16666@arch>
References: <1410446617-29572-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410446617-29572-1-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre,

On 11 Sep 04:43 PM, Alexandre Belloni wrote:
> @@ -2276,6 +2280,16 @@ static int atmel_nand_nfc_probe(struct platform_device *pdev)
>  		}
>  	}
>  
> +	nfc->clk = devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(nfc->clk)) {
> +		dev_warn(&pdev->dev, "NFC clock is missing");
> +		return 0;
> +	}
> +

The binding documentation makes no mention to a clock.

Anyway, with or without the docs I think this patch breaks DT backward
compatibility.

Or am I missing something?
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
