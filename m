Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935396Ab3FTAAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 20:00:20 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46355 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934375Ab3FTAAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 20:00:19 -0400
Date: Wed, 19 Jun 2013 17:00:18 -0700 (PDT)
Message-Id: <20130619.170018.1690166635385887009.davem@davemloft.net>
To: linux@roeck-us.net
Cc: netdev@vger.kernel.org, festevam@gmail.com, linux-kernel@vger.kernel.org,
        Frank.Li@freescale.com, jim_baxter@mentor.com
Subject: Re: [PATCH v3] net: fec: Fix build for MCF5272
From: David Miller <davem@davemloft.net>
In-Reply-To: <1371575099-2962-1-git-send-email-linux@roeck-us.net>
References: <1371575099-2962-1-git-send-email-linux@roeck-us.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>
Date: Tue, 18 Jun 2013 10:04:59 -0700

> Commits 4c09eed9 (net: fec: Enable imx6 enet checksum acceleration) and
> baa70a5c (net: fec: enable pause frame to improve rx prefomance for 1G
> network) introduced functionality into the FEC driver which is not
> supported on MCF5272. The registers used to implement this functionality
> do not exist on MCF5272. Since register defines for MCF5272 are separate
> from register defines for other chips, building images for MCF5272 fails
> as follows.
> 
> fec_main.c: In function 'fec_restart':
> fec_main.c:520:8: error: 'FEC_RACC' undeclared (first use in this function)
> fec_main.c:585:3: error: 'FEC_R_FIFO_RSEM' undeclared (first use in this function)
> fec_main.c:586:3: error: 'FEC_R_FIFO_RSFL' undeclared (first use in this function)
> fec_main.c:587:3: error: 'FEC_R_FIFO_RAEM' undeclared (first use in this function)
> fec_main.c:588:3: error: 'FEC_R_FIFO_RAFL' undeclared (first use in this function)
> fec_main.c:591:3: error: 'FEC_OPD' undeclared (first use in this function)
> 
> Adding the missing register defines is not an option, since the registers
> do not exist on MCF5272. Disable the added functionality for MCF5272 builds.
> 
> Cc: Frank Li <Frank.Li@freescale.com>
> Cc: Jim Baxter <jim_baxter@mentor.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Applied, thanks.

> This problem exists in 3.9 as well, though only due to commit baa70a5c. The
> patch does therefore not cleanly apply to 3.9. Options I can see are to ignore
> the build error in 3.9, to back-port the patch manually, or to split it into
> two separate patches. David, let me know which approach you prefer. 

You can feel free to send me a backport for v3.9-stable, thanks.
