Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab3CTWg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 18:36:27 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:42762 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab3CTWgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 18:36:25 -0400
Message-ID: <514A39E3.6090501@gmail.com>
Date: Wed, 20 Mar 2013 23:36:19 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: balbi@ti.com, gregkh@linuxfoundation.org, arnd@arndb.de,
        akpm@linux-foundation.org, rob@landley.net,
        broonie@opensource.wolfsonmicro.com, linux@arm.linux.org.uk,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, eballetbo@gmail.com, santosh.shilimkar@ti.com,
        linux-arm-kernel@lists.infradead.org, swarren@nvidia.com,
        javier@dowhile0.org, linux-omap@vger.kernel.org, davem@davemloft.net,
        cesarb@cesarb.net, mchehab@redhat.com
Subject: Re: [PATCH v3 1/6] drivers: phy: add generic PHY framework
References: <1363770725-13717-1-git-send-email-kishon@ti.com> <1363770725-13717-2-git-send-email-kishon@ti.com>
In-Reply-To: <1363770725-13717-2-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On 03/20/2013 10:12 AM, Kishon Vijay Abraham I wrote:
> The PHY framework provides a set of APIs for the PHY drivers to
> create/destroy a PHY and APIs for the PHY users to obtain a reference to the
> PHY with or without using phandle. To obtain a reference to the PHY without
> using phandle, the platform specfic intialization code (say from board file)
> should have already called phy_bind with the binding information. The binding
> information consists of phy's device name, phy user device name and an index.
> The index is used when the same phy user binds to mulitple phys.
>
> PHY drivers should create the PHY by passing phy_descriptor that has
> describes the PHY (label, type etc..) and ops like init, exit, suspend, resume,
> poweron, shutdown.
>
> The documentation for the generic PHY framework is added in
> Documentation/phy.txt and the documentation for the sysfs entry is added
> in Documentation/ABI/testing/sysfs-class-phy.
>
> Signed-off-by: Kishon Vijay Abraham I<kishon@ti.com>
> ---
[...]
> +static inline struct phy *phy_get(struct device *dev, int index)
> +{
> +	return ERR_PTR(-EOPNOTSUPP);

Shouldn't these be -ENOSYS ? EOPNOTSUPP is defined by POSIX as
"Operation not supported on socket". And EOPNOTSUPP appears to be
mostly used in the network code in the kernel.

> +}
> +
> +static inline struct phy *devm_phy_get(struct device *dev, int index)
> +{
> +	return ERR_PTR(-EOPNOTSUPP);
> +}
> +
> +static inline struct phy *of_phy_get(struct device *dev, int index)
> +{
> +	return ERR_PTR(-EOPNOTSUPP);
> +}
> +
> +static inline struct phy *devm_of_phy_get(struct device *dev, int index)
> +{
> +	return ERR_PTR(-EOPNOTSUPP);
> +}
> +
> +static inline struct phy *of_phy_get_byname(struct device *dev,
> +	const char *string)
> +{
> +	return ERR_PTR(-EOPNOTSUPP);
> +}
> +
> +static inline struct phy *devm_of_phy_get_byname(struct device *dev,
> +	const char *string)
> +{
> +	return ERR_PTR(-EOPNOTSUPP);
> +}

Thanks,
Sylwester
