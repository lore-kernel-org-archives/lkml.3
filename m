Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab3CMKQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 06:16:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34157 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506Ab3CMKQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 06:16:15 -0400
Date: Wed, 13 Mar 2013 10:09:49 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Danny Huang <dahuang@nvidia.com>
Cc: swarren@wwwdotorg.org, ldewangan@nvidia.com, olof@lixom.net,
        hdoyu@nvidia.com, thierry.reding@avionic-design.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v3] ARM: tegra: expose chip ID and revision
Message-ID: <20130313100949.GA4977@n2100.arm.linux.org.uk>
References: <1363168080-12697-1-git-send-email-dahuang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363168080-12697-1-git-send-email-dahuang@nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 05:48:00PM +0800, Danny Huang wrote:
> +	soc_dev = soc_device_register(soc_dev_attr);
> +	if (IS_ERR(soc_dev)) {
> +		kfree(soc_dev_attr->soc_id);
> +		kfree(soc_dev_attr->revision);
> +		kfree(soc_dev_attr->family);
> +		kfree(soc_dev_attr);
> +		goto out;
> +	}
> +
> +	parent = soc_device_to_device(soc_dev);
> +	if (IS_ERR(parent))
> +		parent = NULL;

I know other places have done this kind of thing but what use is it?

struct device *soc_device_to_device(struct soc_device *soc_dev)
{
        return &soc_dev->dev;
}

Now, consider that soc_device_register() returns one of two things:
1. A valid pointer - it must be valid, because soc_device_register()
   already dereferences it.
2. An error pointer, trappable with IS_ERR().

You are trapping it with IS_ERR() - that's good news.  So, by the time
we get to soc_device_to_device(), we know that it _is_ a valid pointer.
So why would soc_device_to_device() return an error pointer?
