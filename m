Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbaC0Hk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 03:40:27 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:35599 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbaC0HkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 03:40:25 -0400
Date: Thu, 27 Mar 2014 08:40:16 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>, stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: OCTEON: fix EARLY_PRINTK_8250 build failure
Message-ID: <20140327074016.GN17197@linux-mips.org>
References: <1395777525-28910-1-git-send-email-aaro.koskinen@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395777525-28910-1-git-send-email-aaro.koskinen@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 09:58:45PM +0200, Aaro Koskinen wrote:

> Enabling EARLY_PRINTK_8250 breaks OCTEON builds because of multiple
> prom_putchar() implementations. OCTEON provides its own prom_putchar()
> (also used by the watchdog driver), so we should prevent user from
> selecting EARLY_PRINTK_8250 on OCTEON.

There shouldn't be Octeon-specific code in the 8250-driver, not even
the Kconfig bits.  Also other systems - at least Sibyte - affected
by the same issue so I went for a different patch.

  Ralf
