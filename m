Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955AbaFYNdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 09:33:04 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:49541 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382AbaFYNdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 09:33:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: zhangfei <zhangfei.gao@linaro.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, mark.rutland@arm.com,
        haifeng.yan@linaro.org, jchxue@gmail.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Jiancheng Xue <xuejiancheng@huawei.com>
Subject: Re: [PATCH v2 1/2] Documentation: Document Hisilicon hix5hd2 sata PHY
Date: Wed, 25 Jun 2014 15:32:13 +0200
Message-ID: <20300092.1dHGFVKfHm@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53AAC376.7050705@linaro.org>
References: <1403687648-29082-1-git-send-email-zhangfei.gao@linaro.org> <201406251416.49561.arnd@arndb.de> <53AAC376.7050705@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Qz98hb4/qAfm7ZqWEnZuLB8ToESyLl/5hKbMO9F5rNl
 ZhDAJmv4pYnFARraPzJYVpkMmxUAaW+qUSs5UsuZaqGOZFTxJw
 mPeM2rHq8HGtewGUA7xDR6LRyWR+zkMdXmVywtaXGb/iMDEMr5
 6aSyYgZe0ygunvMOhH8J81sS39zaG86duGWVi5KzQ5FLcQBWlV
 MUQIT/aR91twBwKlgHmBiwfOmy05qQ+8lJAiVXJvXCg86pkaTg
 cBU+dWQRJd/nPOF0vH7yPnlk/K7qkLs24K9u8ti6P2RFGnnFJY
 kAu2hjygXlKnW9lsNOsNzEcxIGip3AhmrTLiXKmaUqs9q5vhP+
 KXygBfLjC1XI1LBSCvxo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 June 2014 20:41:26 zhangfei wrote:
> On 06/25/2014 08:16 PM, Arnd Bergmann wrote:
> > On Wednesday 25 June 2014, Zhangfei Gao wrote:
> >> From: Jiancheng Xue <xuejiancheng@huawei.com>
> >>
> >> Add necessary binding documentation SATA PHY on Hisilicon hix5hd2 soc.
> >>
> >> Signed-off-by: Jiancheng Xue <xuejiancheng@huawei.com>
> >> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
> >
> > We have had a couple of PHY drivers that were initially meant to be
> > single-purpose but then turned out to be for hardware that could
> > be put into multiple modes (SATA, gbit ethernet, PCIe, ...). Are
> > you sure that this particular device is SATA-only?
> >
> 
> Yes, double confimed.
> Hix5hd2 phy diver only support sata phy, in fact, current soc only 
> support synposis phy, since some internal physical link.
> And hix5hd2 ethernet phy is already in hix5hd2_gmac.c.
> No pcie support on hix5hd2 platfrom.

Sorry if I my question was unclear, I did not mean the implementation
of this phy in hix5hd2, but the Synopsys phy itself. I was mainly
asking because of the "compatible" string, which should otherwise
not include "sata" but be more generic.

Since you mention that this is a synopsys part, it may however be
good to also define a compatible string for the generic device,
to allow other SoCs to share this driver, and to make it easier
for people to find out that we already have one so they don't have
to write another driver for the same hardware.

Can you find out what the Synopsys/Designware product designation for
this PHY is? It would be good to rename the driver and binding
if possible. I would still recommend leaving the
"hisilicon,hix5hd2-sata-phy" string and the "hisilicon,peripheral-syscon"
property in place, since that indicates a minor variation of the
generic part.

	Arnd
