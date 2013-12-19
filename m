Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab3LSR7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:59:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44281 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab3LSR73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:59:29 -0500
Date: Thu, 19 Dec 2013 09:59:31 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Danny Huang <dahuang@nvidia.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/6] misc: fuse: Add efuse driver for Tegra
Message-ID: <20131219175931.GA18004@kroah.com>
References: <1387468474-26521-1-git-send-email-pdeschrijver@nvidia.com>
 <1387468474-26521-3-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387468474-26521-3-git-send-email-pdeschrijver@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 05:54:30PM +0200, Peter De Schrijver wrote:
> +int tegra_fuse_sysfs(struct device *dev, int size,
> +		     u32 (*readl)(const unsigned int offset),
> +		     struct tegra_sku_info *sku_info)

Odd function name, there's no "verb" in it to give a hint as to what it
does.

> +{
> +	int err;
> +
> +	if (fuse_size)
> +		return -ENODEV;
> +
> +	fuse_bin_attr.size = size;
> +	fuse_bin_attr.read = fuse_read;
> +
> +	fuse_size = size;
> +	fuse_readl = readl;
> +
> +	err = device_create_bin_file(dev, &fuse_bin_attr);
> +	if (err)
> +		return err;
> +
> +	pr_info("Tegra Revision: %s SKU: %d CPU Process: %d Core Process: %d\n",
> +		tegra_revision_name[sku_info->revision],
> +		sku_info->sku_id, sku_info->cpu_process_id,
> +		sku_info->core_process_id);

Why pollute the kernel log with this type of thing?  Who really needs
it?

And if you really need it, please use dev_info() to properly identify
the device you are referring to.

Also, you forgot to document your new sysfs file that you created in
Documentation/ABI/ :(

thanks,

greg k-h
