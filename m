Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546AbaGXPjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:39:37 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:40256 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759405AbaGXPjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:39:35 -0400
MIME-Version: 1.0
X-Originating-IP: [172.19.1.49]
In-Reply-To: <20140724163329.03002387@canb.auug.org.au>
References: <20140724162811.5e12107a@canb.auug.org.au>
	<20140724163329.03002387@canb.auug.org.au>
Date: Thu, 24 Jul 2014 08:39:30 -0700
Message-ID: <CAOesGMgZHHKLMeyGKq_ZfSxWsRcLL3a=ogbW8s=KTUrjf6L3qA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the usb tree with the arm-soc tree
From: Olof Johansson <olof@lixom.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pratyush Anand <pratyush.anand@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 11:33 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Greg,
>
> On Thu, 24 Jul 2014 16:28:11 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> Today's linux-next merge of the usb tree got a conflict in
>> drivers/phy/Kconfig between commit 64562e99477f ("phy: Add drivers for
>> PCIe and SATA phy on SPEAr13xx") from the arm-soc tree and commit
>> 1de990d8a169 ("phy: qcom: Add driver for QCOM APQ8064 SATA PHY") from
>> the usb tree.
>>
>> I fixed it up (see below) and can carry the fix as necessary (no action
>> is required).
>
> Also drivers/phy/Makefile
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc drivers/phy/Makefile
> index 241c741e6e39,971ad0aac388..000000000000
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@@ -18,8 -21,7 +21,10 @@@ phy-exynos-usb2-y                    += phy-samsung-usb2
>   phy-exynos-usb2-$(CONFIG_PHY_EXYNOS4210_USB2) += phy-exynos4210-usb2.o
>   phy-exynos-usb2-$(CONFIG_PHY_EXYNOS4X12_USB2) += phy-exynos4x12-usb2.o
>   phy-exynos-usb2-$(CONFIG_PHY_EXYNOS5250_USB2) += phy-exynos5250-usb2.o
>  +phy-exynos-usb2-$(CONFIG_PHY_S5PV210_USB2)    += phy-s5pv210-usb2.o
>   obj-$(CONFIG_PHY_EXYNOS5_USBDRD)      += phy-exynos5-usbdrd.o
>   obj-$(CONFIG_PHY_XGENE)                       += phy-xgene.o
>  +obj-$(CONFIG_PHY_ST_SPEAR1310_MIPHY)  += phy-spear1310-miphy.o
>  +obj-$(CONFIG_PHY_ST_SPEAR1340_MIPHY)  += phy-spear1340-miphy.o
> + obj-$(CONFIG_PHY_QCOM_APQ8064_SATA)   += phy-qcom-apq8064-sata.o
> + obj-$(CONFIG_PHY_QCOM_IPQ806X_SATA)   += phy-qcom-ipq806x-sata.o


We've both been sinners here. New entries should be added in
alphabetical order to avoid these conflicts, and neither of us caught
it.

Resolution looks OK though.


-Olof
