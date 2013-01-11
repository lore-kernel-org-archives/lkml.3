Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab3AKUNb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 15:13:31 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62546 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab3AKUN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 15:13:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Matt Porter <mporter@ti.com>
Subject: Re: [PATCH v4 00/14] DMA Engine support for AM33XX
Date: Fri, 11 Jan 2013 20:12:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Dan Williams <djbw@fb.com>, Rob Herring <rob.herring@calxeda.com>
References: <1357883330-5364-1-git-send-email-mporter@ti.com> <201301111140.41584.arnd@arndb.de> <20130111183349.GA14660@beef>
In-Reply-To: <20130111183349.GA14660@beef>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301112012.45981.arnd@arndb.de>
X-Provags-ID: V02:K0:HSKsK2T889o+Vm9S00NCQ7mmaDU9G5fAV0ZqnFheqOr
 8GnaRe4L2UmQBD4LuPxYDHtTy1YULRxtYK11cn4WxD9VvSJQNu
 JC1uqEF+LsCT9nHqo2HW0gVEU/ltBqBq4SAF3boaFAF0ApZ8o8
 Dri7CRA3F4U3uxDwuvOvPJT7b1sUVwun4kSS3XkbCxnEYZ59Gx
 WfuccCNbVPFh3yfeP/chRuGVqR7E79WgujjCj30t5lTD9A0Fd6
 4nEJPDYCxMp+eqz80XjIv1dMQz8WBvRSicF5UGLuBsbiZnMEou
 Qv4ncxjhx5THmpTOEVj17V/20bOdhduuQg+ib04TC/g3fx8EJ2
 SYTPbWkNc8SNHUpGda40=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 January 2013, Matt Porter wrote:
> We have tightly coupled the link-time dependency for
> omap_dma_filter_fn by going down the path of using
> dma_request_slave_channel_compat() as Tony suggested to avoid extra
> ifdefry.
> 
> That dependency will go away naturally if all the "legacy" OMAP platforms
> were required to only boot from DT...just as a newly added SoCs are.
> 
> Are you suggesting unwinding the _compat() approach?

No, I was thinking we could define omap_dma_filter_fn to NULL
for the DT-only case.

	Arnd
