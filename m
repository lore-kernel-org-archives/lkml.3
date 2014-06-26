Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbaFZUye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:54:34 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:64925 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaFZUyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:54:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: zhangfei <zhangfei.gao@linaro.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, mark.rutland@arm.com,
        haifeng.yan@linaro.org, jchxue@gmail.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Jiancheng Xue <xuejiancheng@huawei.com>
Subject: Re: [PATCH v2 1/2] Documentation: Document Hisilicon hix5hd2 sata PHY
Date: Thu, 26 Jun 2014 22:53:48 +0200
Message-ID: <4989178.vejv39dnj8@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53AC24C6.8000304@linaro.org>
References: <1403687648-29082-1-git-send-email-zhangfei.gao@linaro.org> <20300092.1dHGFVKfHm@wuerfel> <53AC24C6.8000304@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:QKaVH0zdu+vIO4d+S3Tjl0cJJxghEtSUbSTS7aQqO2G
 lYjXq8+T8e2GCZ+vBTRttJ7QwLPsZfWWvMGNm+uHBOV6cT0YLo
 N97eOUI+4sGXFZcZABZYO4u87V4AKnywgmmaWeJCdpgEr8+rjY
 dmVVuf0aOgGnG5moYHdK5s4DNayRskdc2m4rTcfwTPmN7whDXJ
 6ADLlbV2/AKLEZv7IIrLYpz3XtbnzgXp74fpveeKp8fNWt6zVt
 vTS415ahW7iBK7aN7+4JO4tZmx/S0oeFNR6FUPthvOprj7QyNH
 mY+9zAf03ZTV2Nu12yghzgri6DI/XEgScosLXq7MPDk+JmL6jA
 kPpsOee2Xf+kF2rnkT3A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2014 21:48:54 zhangfei wrote:
> 
> On 06/25/2014 09:32 PM, Arnd Bergmann wrote:
> > On Wednesday 25 June 2014 20:41:26 zhangfei wrote:
> >> On 06/25/2014 08:16 PM, Arnd Bergmann wrote:
> >>> On Wednesday 25 June 2014, Zhangfei Gao wrote:
> >>>> From: Jiancheng Xue <xuejiancheng@huawei.com>
> >>>>
> >>>> Add necessary binding documentation SATA PHY on Hisilicon hix5hd2 soc.
> >>>>
> >>>> Signed-off-by: Jiancheng Xue <xuejiancheng@huawei.com>
> >>>> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
> >>>
> >>> We have had a couple of PHY drivers that were initially meant to be
> >>> single-purpose but then turned out to be for hardware that could
> >>> be put into multiple modes (SATA, gbit ethernet, PCIe, ...). Are
> >>> you sure that this particular device is SATA-only?
> >>>
> >>
> >> Yes, double confimed.
> >> Hix5hd2 phy diver only support sata phy, in fact, current soc only
> >> support synposis phy, since some internal physical link.
> >> And hix5hd2 ethernet phy is already in hix5hd2_gmac.c.
> >> No pcie support on hix5hd2 platfrom.
> >
> > Sorry if I my question was unclear, I did not mean the implementation
> > of this phy in hix5hd2, but the Synopsys phy itself. I was mainly
> > asking because of the "compatible" string, which should otherwise
> > not include "sata" but be more generic.
> 
> This phy is specifically for sata.

Ok.

> > Since you mention that this is a synopsys part, it may however be
> > good to also define a compatible string for the generic device,
> > to allow other SoCs to share this driver, and to make it easier
> > for people to find out that we already have one so they don't have
> > to write another driver for the same hardware.
> 
> http://www.synopsys.com/dw/ipdir.php?ds=dwc_sata_phy
> name can be: dwc_sata_phy
> However, not find register from the website, not sure whether the 
> register are totally same, or there is some change.
> Other soc from hisilicon using the same ip can share this driver.

I found a list of versions under "Downloads and Documentation", but
unfortunately the actual downloads are not accessible without a
customer account.

> > Can you find out what the Synopsys/Designware product designation for
> > this PHY is? It would be good to rename the driver and binding
> > if possible. I would still recommend leaving the
> > "hisilicon,hix5hd2-sata-phy" string and the "hisilicon,peripheral-syscon"
> > property in place, since that indicates a minor variation of the
> > generic part.
> 
> "hisilicon,peripheral-syscon" is privide power supply, etc.
> 
> Do you mean change the compatible to "hisilicon,dwc-sata-phy" or 
> multiple compatible?

Multiple compatible strings.

"hisilicon,dwc-sata-phy" would be too generic anyway, it should include the
name of the chip that first implements this, or the exact version of the
IP block, preferably both.

Ideally if you can find out the version that hisilicon uses, it could
look something like

compatible = "hisilicon,hi15hd2-sata-phy", "snps,dwc-sata-phy-2.3a", ""snps,dwc-sata-phy";

Note also the specific version of the hisilicon chip: you must not use
wildcards in compatible strings but should always use a real product number.
("1" instead of "x"). If multiple chips are mutually compatible, they
can all use the number of the first one here.

	Arnd
