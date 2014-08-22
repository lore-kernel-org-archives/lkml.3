Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbaHVHdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 03:33:52 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:55502 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779AbaHVHdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 03:33:49 -0400
Date: Fri, 22 Aug 2014 00:33:44 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Harini Katakam <harinik@xilinx.com>
Cc: wim@iguana.be, grant.likely@linaro.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        michals@xilinx.com, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, harinikatakamlinux@gmail.com,
        svemula@xilinx.com, anirudh@xilinx.com
Subject: Re: [PATCH v4 1/2] watchdog: Add Cadence WDT driver
Message-ID: <20140822073344.GA23635@roeck-us.net>
References: <1406788855-19074-1-git-send-email-harinik@xilinx.com>
 <20140821185722.GA17481@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140821185722.GA17481@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 11:57:22AM -0700, Guenter Roeck wrote:
> On Thu, Jul 31, 2014 at 12:10:54PM +0530, Harini Katakam wrote:
> > Add Cadence WDT driver. This is used by Xilinx Zynq.
> > 
> > Signed-off-by: Harini Katakam <harinik@xilinx.com>
> 
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Hah, that was too fast. The driver causes build errors for a number or
architectures, including x86_64.

drivers/watchdog/cadence_wdt.c: In function 'cdns_wdt_writereg':
drivers/watchdog/cadence_wdt.c:93:2: error: implicit declaration of function
'writel_relaxed' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[2]: *** [drivers/watchdog/cadence_wdt.o] Error 1
make[1]: *** [drivers/watchdog] Error 2

Please make sure that the driver is only configurable for architectures
supporting writel_relaxed.

Thanks,,
Guenter
