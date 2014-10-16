Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750870AbaJPFGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 01:06:16 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35303 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750719AbaJPFGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 01:06:15 -0400
Message-ID: <543F5244.1010408@free-electrons.com>
Date: Thu, 16 Oct 2014 07:06:12 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Andrew Lunn <andrew@lunn.ch>
CC: dwmw2@infradead.org, computersforpeace@gmail.com, jg1.han@samsung.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: orion_nand: fix error code path in probe
References: <1413296198-29486-1-git-send-email-michael.opdenacker@free-electrons.com> <20141014213503.GD5331@lunn.ch>
In-Reply-To: <20141014213503.GD5331@lunn.ch>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2014 11:35 PM, Andrew Lunn wrote:
>
>  
>  	if (pdev->dev.of_node) {
>  		board = devm_kzalloc(&pdev->dev, sizeof(struct orion_nand_data),
>  					GFP_KERNEL);
>  		if (!board) {
> -			ret = -ENOMEM;
> -			goto no_res;
> +			return -ENOMEM;
>  		}
> Doesn't this now break the coding style? No need to have the {} since
> it is a single statement.

Right, I've checked Documentation/CodingStyle, and this is just
recommended, not absolutely required. That could be the reason why
check_patch.pl didn't complain.

My v2 changes this.

Thanks!

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

