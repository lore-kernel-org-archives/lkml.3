Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab3HAHar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 03:30:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41732 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3HAHao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 03:30:44 -0400
Date: Wed, 31 Jul 2013 18:40:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: kyungmin.park@samsung.com, balbi@ti.com, jg1.han@samsung.com,
        s.nawrocki@samsung.com, kgene.kim@samsung.com,
        stern@rowland.harvard.edu, broonie@kernel.org, tomasz.figa@gmail.com,
        arnd@arndb.de, grant.likely@linaro.org, tony@atomide.com,
        swarren@nvidia.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, akpm@linux-foundation.org,
        balajitk@ti.com, george.cherian@ti.com, nsekhar@ti.com,
        linux@arm.linux.org.uk, Tomasz Figa <t.figa@samsung.com>
Subject: Re: [RESEND PATCH v10 1/8] drivers: phy: add generic PHY framework
Message-ID: <20130801014024.GA6941@kroah.com>
References: <1374842963-13545-1-git-send-email-kishon@ti.com>
 <1374842963-13545-2-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374842963-13545-2-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 06:19:16PM +0530, Kishon Vijay Abraham I wrote:
> +static int phy_get_id(void)
> +{
> +	int ret;
> +	int id;
> +
> +	ret = ida_pre_get(&phy_ida, GFP_KERNEL);
> +	if (!ret)
> +		return -ENOMEM;
> +
> +	ret = ida_get_new(&phy_ida, &id);
> +	if (ret < 0)
> +		return ret;
> +
> +	return id;
> +}

ida_simple_get() instead?  And if you do that, you can get rid of this
function entirely.

thanks,

greg k-h
