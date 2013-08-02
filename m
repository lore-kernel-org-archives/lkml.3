Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab3HBT2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:28:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65413 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab3HBT2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:28:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, vinod.koul@intel.com, djbw@fb.com,
        linux@arm.linux.org.uk
Subject: Re: [PATCH v4] dmaengine: Add MOXA ART DMA engine driver
Date: Fri, 02 Aug 2013 21:28:48 +0200
Message-ID: <1957393.zQhGBaWaVi@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.10.95; x86_64; ; )
In-Reply-To: <CACmBeS1vT6HyhN=Q4Y9izR0F1Es818iU0fQ5-U8LxijRKe=+8w@mail.gmail.com>
References: <1374055584-15746-1-git-send-email-jonas.jensen@gmail.com> <201307291835.21151.arnd@arndb.de> <CACmBeS1vT6HyhN=Q4Y9izR0F1Es818iU0fQ5-U8LxijRKe=+8w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:TAcnKZgBPJeLNjQp3T4jhQ3rOXwuVyr978WfG9Nr/xE
 fe9iqhVHHz2jHsL+dUZvef7iYLW62+v1frfNei/ZKPO/1QI8m8
 7prkBX2VjSjAARbsQJKxxCm9N/dABIJdfmC2euTeOmo4ZELF3y
 Y4GQIuHodDNiMNr15SdgVvXUmMDxsUYPH+9bBUpr1cJC4XYus+
 GzXa0uVSVqaJ34+YOk87bY5/JSYYkzK5uqZhS76HuNLu9MC1gS
 fpMGzIWrPpgN6kzTi9mahT/bJA6Qt2xVNQiLJ9pUfrDEP5MImA
 BvqNnUFj1OBUsEWeSAvmodXzMkzvsCOahggOzaamAZBY+QtsWv
 WKFfQkKrLttgEJMgI4Gs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 August 2013 14:28:28 Jonas Jensen wrote:
> 
> On 29 July 2013 18:35, Arnd Bergmann <arnd@arndb.de> wrote:
> > You must not override the "dest_req_no" and "dest_req_no" in moxart_slave_config
> > since they are already set by the ->xlate() function and the driver calling
> > slave_config generally has no knowledge of what the slave id is.
> 
> MMC now has a device tree node:
> 
> mmc: mmc@98e00000 {
> compatible = "moxa,moxart-mmc";
> reg = <0x98e00000 0x5C>;
> interrupts = <5 0>;
> clocks = <&coreclk>;
> dmas = <&dma 0>,
>             <&dma 1>;
> dma-names = "tx", "rx";
> };
> 
> .. where the driver requests channel 0-1 and sets cfg.slave_id =
> APB_DMA_SD_REQ_NO for both.
> 
> Perhaps this is not how slave_id is intended to be used?
> 
> Maybe it would be more appropriate to have two DMA cells?
> 
> APB_DMA_SD_REQ_NO can then be moved from driver code to DT.

In most drivers, you can use any channel with any request line number
and let the dmaengine driver pick a channel while you pass just the
request line (slave id) in a single cell in DT. If this does not
work, using two cells is the best approach here.

Removing APB_DMA_SD_REQ_NO from the driver code is definitely the
right approach, since that number is not something specific to the
device, but to the way it is connected to the DMA engine, which
belongs into DT.

	Arnd
