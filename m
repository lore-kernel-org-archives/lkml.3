Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbbALDQL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 22:16:11 -0500
Received: from smtp1s1.overthewire.com.au ([203.18.94.100]:48298 "EHLO
	smtp1s1.overthewire.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751011AbbALDQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 22:16:09 -0500
From: Ken Wilson <ken.wilson@opengear.com>
To: thomas.petazzoni@free-electrons.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        broonie@kernel.org, ezequiel.garcia@free-electrons.com,
        gerg@uclinux.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Ken Wilson <ken.wilson@opengear.com>
Subject: [PATCHv2 0/2] spi: orion: Add multiple chip select support to spi-orion
Date: Mon, 12 Jan 2015 13:13:58 +1000
Message-Id: <1421032440-15335-1-git-send-email-ken.wilson@opengear.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,      

This patch series adds multiple chip select support for the spi-orion driver.
The first patch moves spi-orion to use the spi setup/set_cs/transfer_one         
function pointers, which reduces duplicated code, and simplifies the chip 
select support implementation.

The second patch adds support for multiple chip selects. Currently
there is no additional support for gpio chip selects, as I do not 
have a board to test that with. 

These patches have been tested on an Armada 375 with 2 SPI-NOR chips.

Thanks,
Ken

Ken Wilson (2):
  spi: orion: Change spi-orion to use transfer_one() semantics for SPI
    transfers
  spi: orion: Add multiple chip select support to spi-orion

 .../devicetree/bindings/spi/spi-orion.txt          |  3 +
 drivers/spi/spi-orion.c                            | 90 +++++++++-------------
 2 files changed, 41 insertions(+), 52 deletions(-)

-- 
2.0.0

