Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277AbaJVMM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 08:12:28 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:60646 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932865AbaJVMM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 08:12:26 -0400
Date: Wed, 22 Oct 2014 13:12:19 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, arnd@arndb.de, b29396@freescale.com,
        boris.brezillon@free-electrons.com, tomasz.figa@gmail.com,
        linux@arm.linux.org.uk, vikas.sajjan@samsung.com, naushad@samsung.com,
        thomas.ab@samsung.com, kgene.kim@samsung.com, Li.Xiubo@freescale.com,
        geert+renesas@glider.be, swarren@nvidia.com
Subject: Re: [PATCH v7] mfd: syscon: Decouple syscon interface from platform
 devices
Message-ID: <20141022121219.GM4939@x1>
References: <1412066127-27063-1-git-send-email-pankaj.dubey@samsung.com>
 <20141007090923.GI25331@lee--X1>
 <001901cfede8$5554cc50$fffe64f0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <001901cfede8$5554cc50$fffe64f0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2014, Pankaj Dubey wrote:

> Hello Lee,
> 
> On Tuesday, October 07, 2014 2:39 PM, Lee Jones wrote,
> > On Tue, 30 Sep 2014, Pankaj Dubey wrote:
> > 
> > > Currently a syscon entity can be only registered directly through a
> > > platform device that binds to a dedicated syscon driver. However in
> > > certain use cases it is desirable to make a device used with another
> > > driver a syscon interface provider.
> > >
> > > For example, certain SoCs (e.g. Exynos) contain system controller
> > > blocks which perform various functions such as power domain control,
> > > CPU power management, low power mode control, but in addition contain
> > > certain IP integration glue, such as various signal masks, coprocessor
> > > power control, etc. In such case, there is a need to have a dedicated
> > > driver for such system controller but also share registers with other
> > > drivers. The latter is where the syscon interface is helpful.
> > >
> > > In case of DT based platforms, this patch decouples syscon object from
> > > syscon platform driver, and allows to create syscon objects first time
> > > when it is required by calling of syscon_regmap_lookup_by APIs and
> > > keep a list of such syscon objects along with syscon provider
> > > device_nodes and regmap handles.
> > >
> > > For non-DT based platforms, this patch keeps syscon platform driver
> > > structure so that syscon can be probed and such non-DT based drivers
> > > can use syscon_regmap_lookup_by_pdev API and access regmap handles.
> > > Once all users of "syscon_regmap_lookup_by_pdev" migrated to DT based,
> > > we can completely remove platform driver of syscon, and keep only
> > > helper functions to get regmap handles.
> > >
> > > Suggested-by: Arnd Bergmann <arnd@arndb.de>
> > > Suggested-by: Tomasz Figa <tomasz.figa@gmail.com>
> > > Tested-by: Vivek Gautam <gautam.vivek@samsung.com>
> > > Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> > > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > > Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> > > Tested-by: Heiko Stuebner <heiko@sntech.de>
> > > Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> > 
> > Applied for v3.19.
> 
> I can't see this in 3.18-rc1, as this patch is one of dependency for many of Exynos PMU related patches,
> will you please queue this patch for 3.18-rc2, so that already ready to be in patches having this patch as
> dependency can be taken in.

As my message implies, this isn't going to make it into v3.18 but it
is queued for v3.19.  It was sent far too late in the cycle (rc7 of 7)
to make it into the v3.18 merge-window.

In the meantime, please give this patch through testing whilst it's in
-next, to help mitigate any issues when it's applied into v3.19.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
