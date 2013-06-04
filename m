Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab3FDKVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 06:21:21 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:23147 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab3FDKVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 06:21:19 -0400
X-AuditID: cbfec7f5-b7f376d000001ec6-2c-51adbf9d46ab
Message-id: <51ADBF9B.5060403@samsung.com>
Date: Tue, 04 Jun 2013 12:21:15 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: grant.likely@linaro.org, tony@atomide.com, balbi@ti.com, arnd@arndb.de,
        swarren@nvidia.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, rob.herring@calxeda.com, rob@landley.net,
        b-cousson@ti.com, linux@arm.linux.org.uk, gregkh@linuxfoundation.org,
        benoit.cousson@linaro.org, mchehab@redhat.com,
        akpm@linux-foundation.org, cesarb@cesarb.net, davem@davemloft.net,
        rnayak@ti.com, shawn.guo@linaro.org, santosh.shilimkar@ti.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        nsekhar@ti.com
Subject: Re: [PATCH v6 1/9] drivers: phy: add generic PHY framework
References: <1367229812-30574-1-git-send-email-kishon@ti.com>
 <1367229812-30574-2-git-send-email-kishon@ti.com>
In-reply-to: <1367229812-30574-2-git-send-email-kishon@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0iTYRTHefa+e/c6HLytGQ9iRqO+SGl2fZCyqMRHI3RBCILU0uEs52VL
	S0OU1BKvpZk6HWibYm66mFJWq11MrQQ1p8OpKBIamploinkj5/rgt9855/c/58uhCX4v6UnH
	JdyVyBPE8UKKS/ZsdQ8dVZmaRcea/vqjGr2OQpulXRy0MmogkGUiE1UtOiiktF9DNX05JDJX
	T7KReaMdoGy1nkL9U4UUMny3s1HdIw2JbO9qKFStKSHRi4ZcAo3aeMjY2cFBpqJXLDRdYgSo
	o9HMQi0zFST6Wawj0FSLhkDDFTlsZBoMveCJc7ILKby+VgrwynIpiWuXBjn402glgdteOlh4
	VlvFxmN2I4U/V66T2KTScXCrJhP3VdYBXJQ9T+HfH4co3D38hoWXDN7hTCT3bIwkPi5VIvcL
	vMmVFqzJkgoP3h/p1rOzwDTMB240ZE7CvBUV28X7YP+4nsoHXJrP1AOot+qBq1gE8P1DNcdp
	8RgfWGtr3GGSOQwtWuVOmmL8YVFnMXCyBxMO1Zre//4euFo2TjpZsJ3tebtKOJcSzAgJHQNz
	LOdgL3MJWsd+7DCfSYYzOtu2RNNuTCBcXkh2tgnmCDTlPqdcfAC26n4RTwCj3HVCuUtT7tJq
	AdEEPCQp0UmKW7Gy474KsUyRkhDrG50oMwDXDyy3g/quACtgaCB056W91on4bHGqIk1mBZAm
	hALeB22ziM+LEaelS+SJN+Qp8RKFFbBoN88sMBApKHc87dl6EOArurfxtUba4m1+vH8cr03I
	vf5c9oky9KXNxX45H5IZZHHfjA5SR12hhFrLmcQN35iIZ/a2dD+vYOmJLlWde+dsWHnZ7Qzj
	6YJDWnZke6Qq4FtocN2phuuTxQt3REv1goirA3BQdDF35Nw8EZYxtWgX5oWgdCGpkIr9fQi5
	QvwPZzENAuECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2013 12:03 PM, Kishon Vijay Abraham I wrote:
> The PHY framework provides a set of APIs for the PHY drivers to
> create/destroy a PHY and APIs for the PHY users to obtain a reference to the
> PHY with or without using phandle. For dt-boot, the PHY drivers should
> also register *PHY provider* with the framework.
> 
> PHY drivers should create the PHY by passing id and ops like init, exit,
> power_on and power_off. This framework is also pm runtime enabled.
> 
> The documentation for the generic PHY framework is added in
> Documentation/phy.txt and the documentation for dt binding can be found at
> Documentation/devicetree/bindings/phy/phy-bindings.txt
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  .../devicetree/bindings/phy/phy-bindings.txt       |   66 +++
>  Documentation/phy.txt                              |  123 +++++
>  MAINTAINERS                                        |    7 +
>  drivers/Kconfig                                    |    2 +
>  drivers/Makefile                                   |    2 +
>  drivers/phy/Kconfig                                |   13 +
>  drivers/phy/Makefile                               |    5 +
>  drivers/phy/phy-core.c                             |  539 ++++++++++++++++++++
>  include/linux/phy/phy.h                            |  248 +++++++++
>  9 files changed, 1005 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/phy-bindings.txt
>  create mode 100644 Documentation/phy.txt
>  create mode 100644 drivers/phy/Kconfig
>  create mode 100644 drivers/phy/Makefile
>  create mode 100644 drivers/phy/phy-core.c
>  create mode 100644 include/linux/phy/phy.h
 
> +static inline int phy_init(struct phy *phy)
> +{
> +	pm_runtime_get_sync(&phy->dev);

Hmm, no need to check return value here ? Also it looks a bit unexpected to 
possibly have runtime_resume callback of a PHY device called before ops->init()
call ? It seems a bit unclear what the purpose of init() callback is.

> +	if (phy->ops->init)
> +		return phy->ops->init(phy);
> +
> +	return -EINVAL;
> +}
> +
> +static inline int phy_exit(struct phy *phy)
> +{
> +	int ret = -EINVAL;
> +
> +	if (phy->ops->exit)
> +		ret = phy->ops->exit(phy);
> +
> +	pm_runtime_put_sync(&phy->dev);
> +
> +	return ret;
> +}

Do phy_init/phy_exit need to be mandatory ? What if there is really 
nothing to do in those callbacks ? Perhaps -ENOIOCTLCMD should be 
returned if a callback is not implemented, so PHY users can recognize 
such situation and proceed ?

> +static inline int phy_power_on(struct phy *phy)
> +{
> +	if (phy->ops->power_on)
> +		return phy->ops->power_on(phy);
> +
> +	return -EINVAL;
> +}
> +
> +static inline int phy_power_off(struct phy *phy)
> +{
> +	if (phy->ops->power_off)
> +		return phy->ops->power_off(phy);
> +
> +	return -EINVAL;
> +}
> +
> +static inline int phy_pm_runtime_get(struct phy *phy)
> +{
> +	if (WARN(IS_ERR(phy), "Invalid PHY reference\n"))
> +		return -EINVAL;
> +
> +	return pm_runtime_get(&phy->dev);
> +}
> +
> +static inline int phy_pm_runtime_get_sync(struct phy *phy)
> +{
> +	if (WARN(IS_ERR(phy), "Invalid PHY reference\n"))
> +		return -EINVAL;
> +
> +	return pm_runtime_get_sync(&phy->dev);
> +}
> +
> +static inline int phy_pm_runtime_put(struct phy *phy)
> +{
> +	if (WARN(IS_ERR(phy), "Invalid PHY reference\n"))
> +		return -EINVAL;
> +
> +	return pm_runtime_put(&phy->dev);
> +}
> +
> +static inline int phy_pm_runtime_put_sync(struct phy *phy)
> +{
> +	if (WARN(IS_ERR(phy), "Invalid PHY reference\n"))
> +		return -EINVAL;
> +
> +	return pm_runtime_put_sync(&phy->dev);
> +}
> +
> +static inline void phy_pm_runtime_allow(struct phy *phy)
> +{
> +	if (WARN(IS_ERR(phy), "Invalid PHY reference\n"))
> +		return;
> +
> +	pm_runtime_allow(&phy->dev);
> +}
> +
> +static inline void phy_pm_runtime_forbid(struct phy *phy)
> +{
> +	if (WARN(IS_ERR(phy), "Invalid PHY reference\n"))
> +		return;
> +
> +	pm_runtime_forbid(&phy->dev);
> +}

Do we need to have all these runtime PM wrappers ? I guess you 
intended to avoid referencing phy->dev from the PHY consumers ?


Thanks,
Sylwester
