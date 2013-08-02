Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab3HBM2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 08:28:30 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:57094 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab3HBM23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 08:28:29 -0400
MIME-Version: 1.0
In-Reply-To: <201307291835.21151.arnd@arndb.de>
References: <1374055584-15746-1-git-send-email-jonas.jensen@gmail.com>
	<1375105442-14827-1-git-send-email-jonas.jensen@gmail.com>
	<201307291835.21151.arnd@arndb.de>
Date: Fri, 2 Aug 2013 14:28:28 +0200
Message-ID: <CACmBeS1vT6HyhN=Q4Y9izR0F1Es818iU0fQ5-U8LxijRKe=+8w@mail.gmail.com>
Subject: Re: [PATCH v4] dmaengine: Add MOXA ART DMA engine driver
From: Jonas Jensen <jonas.jensen@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, vinod.koul@intel.com, djbw@fb.com,
        linux@arm.linux.org.uk
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Thanks for the replies. I think what you mention should now be fixed.

Except one thing where I still have questions:

On 29 July 2013 18:35, Arnd Bergmann <arnd@arndb.de> wrote:
> You must not override the "dest_req_no" and "dest_req_no" in moxart_slave_config
> since they are already set by the ->xlate() function and the driver calling
> slave_config generally has no knowledge of what the slave id is.

MMC now has a device tree node:

mmc: mmc@98e00000 {
compatible = "moxa,moxart-mmc";
reg = <0x98e00000 0x5C>;
interrupts = <5 0>;
clocks = <&coreclk>;
dmas = <&dma 0>,
            <&dma 1>;
dma-names = "tx", "rx";
};

.. where the driver requests channel 0-1 and sets cfg.slave_id =
APB_DMA_SD_REQ_NO for both.

Perhaps this is not how slave_id is intended to be used?

Maybe it would be more appropriate to have two DMA cells?

APB_DMA_SD_REQ_NO can then be moved from driver code to DT.

Best regards,
Jonas
