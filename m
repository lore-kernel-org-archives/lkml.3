Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab3LZOu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 09:50:56 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:39958 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab3LZOuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 09:50:54 -0500
X-Auth-Info: M/u0KpdXYisrUH8CXwEi9D/UCDON+v/3f9fcUKIDGLs=
Date: Thu, 26 Dec 2013 15:50:52 +0100
From: Gerhard Sittig <gsi@denx.de>
To: Alex Elder <alex.elder@linaro.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clk: support hardware-specific debugfs entries
Message-ID: <20131226145052.GM8064@book.gsilab.sittig.org>
Mail-Followup-To: Alex Elder <alex.elder@linaro.org>,
	Mike Turquette <mturquette@linaro.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
References: <52BC3CA1.7000701@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52BC3CA1.7000701@linaro.org>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 26, 2013 at 08:26 -0600, Alex Elder wrote:
> 
> @@ -140,6 +147,9 @@ struct clk_ops {
>  	int		(*set_rate)(struct clk_hw *hw, unsigned long,
>  				    unsigned long);
>  	void		(*init)(struct clk_hw *hw);
> +#ifdef CONFIG_COMMON_CLK_DEBUG
> +	int		(*debug_init)(struct clk_hw *hw, struct dentry *dentry);
> +#endif
>  };

Please note that this CONFIG_COMMON_CLK_DEBUG switch may go away
(or get replaced) soon.  Mike plans to effectively enable common
clock debugging as soon as debugfs is in effect (which I welcome
very much).

So you should monitor current development and adjust your patch,
or be prepared for breakage and fixing afterwards.  I'd suggest
to just declare the .debug_init member unconditionally now.
Since Mike's patch very likely gets accepted, and nothing will
break when yours gets added later (regardless of the number of
review iterations it will see).


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
