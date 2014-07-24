Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaGXEQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 00:16:42 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:46935 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbaGXEQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 00:16:41 -0400
X-Auth-Info: OQYtUkTyv085KSalzub2sO8Ip2tvgILAHCDZUPZjmPI=
From: Marek Vasut <marex@denx.de>
To: Yao Yuan <yao.yuan@freescale.com>
Subject: Re: [PATCH v5 0/2] i2c: add DMA support for freescale i2c driver
Date: Thu, 24 Jul 2014 06:16:40 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
References: <1406103883-3572-1-git-send-email-yao.yuan@freescale.com> <201407231428.01278.marex@denx.de> <e5547e015bf6447e9b4fc18e82ddce74@BL2PR03MB338.namprd03.prod.outlook.com>
In-Reply-To: <e5547e015bf6447e9b4fc18e82ddce74@BL2PR03MB338.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201407240616.40858.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 24, 2014 at 05:36:34 AM, Yao Yuan wrote:
> Hi,
> 
> Marek Vasut wrote:
> > On Wednesday, July 23, 2014 at 10:24:41 AM, Yuan Yao wrote:
> > > Changed in v5:
> > > - add "*chan_dev = dma->chan_using->device->dev" for reduce the call
> > > time.
> > 
> > Did you check if the compiler generates different code ?
> 
> Sorry, I didn't compare the assembly code. It's a subtle change.
> As you mentioned the "noodle" before.
> 
> Old:
> dma_map_single(dma->chan_using->device->dev, ...);
> dma_mapping_error(dma->chan_using->device->dev, ...);
> dma_unmap_single(dma->chan_using->device->dev, ...);
> 
> New:
> struct device *chan_dev = dma->chan_using->device->dev;
> dma_map_single(chan_dev, ...);
> dma_mapping_error(chan_dev, ...);
> dma_unmap_single(chan_dev, ...);

You should not use optimization and code cleanup interchangably. Thanks for 
clarifying what this is.

Best regards,
Marek Vasut
