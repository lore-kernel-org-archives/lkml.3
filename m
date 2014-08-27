Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965585AbaH0Xdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 19:33:47 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41807 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964814AbaH0Xdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 19:33:44 -0400
Date: Wed, 27 Aug 2014 16:33:43 -0700 (PDT)
Message-Id: <20140827.163343.715764078341662382.davem@davemloft.net>
To: lftan@altera.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lftan.linux@gmail.com, peppe.cavallaro@st.com, vbridger@altera.com
Subject: Re: [PATCH] net: stmmac: fix warning from Sparse for socfpga
From: David Miller <davem@davemloft.net>
In-Reply-To: <1409037076-14775-1-git-send-email-lftan@altera.com>
References: <1409037076-14775-1-git-send-email-lftan@altera.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 Aug 2014 16:33:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ley Foon Tan <lftan@altera.com>
Date: Tue, 26 Aug 2014 15:11:16 +0800

> @@ -119,7 +119,8 @@ static int socfpga_dwmac_parse_data(struct socfpga_dwmac *dwmac, struct device *
>  			return -EINVAL;
>  		}
>  
> -		dwmac->splitter_base = (void *)devm_ioremap_resource(dev,
> +		dwmac->splitter_base =
> +			(void __iomem *)devm_ioremap_resource(dev,
>  			&res_splitter);

Please either put this entire call on one line (it'll only be slightly
over 80 columns, which is fine), or indent it properly.

And by properly I meant that the second and subsequent lines of a function
call must be indented precisely to the first column after the openning
parenthesis of the function call on the first line.  You must use the
appropriate number of TAB and SPACE characters necessary to do so.

If it is indented using only TAB characters, it is very likely that you
are doing it wrong.

Thanks.
