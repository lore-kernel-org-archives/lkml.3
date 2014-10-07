Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbaJGLLB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 07:11:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53787 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbaJGLK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 07:10:59 -0400
Date: Tue, 7 Oct 2014 13:10:54 +0200
From: Pavel Machek <pavel@denx.de>
To: atull@opensource.altera.com
Cc: dinguyen@opensource.altera.com, linux@arm.linux.org.uk,
        yvanderv@opensource.altera.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, delicious.quinoa@gmail.com
Subject: Re: [PATCH v2 1/2] socfpga: hotplug: put cpu1 in wfi
Message-ID: <20141007111052.GA6904@amd>
References: <1412192304-1209-1-git-send-email-atull@opensource.altera.com>
 <1412192304-1209-2-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412192304-1209-2-git-send-email-atull@opensource.altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-10-01 14:38:23, atull@opensource.altera.com wrote:
> From: Alan Tull <atull@opensource.altera.com>
> 
> Use WFI when putting CPU1 to sleep.  Don't hold CPU1 in reset
> since that results in increased power consumption.
> 
> Reset CPU1 briefly during CPU1 bootup.
> 
> This has been tested for hotplug and suspend/resume and results
> in no increased power consumption.
> 
> Signed-off-by: Alan Tull <atull@opensource.altera.com>

It is nice to Cc people who commented ont the patch before.

>  	if (cpu1start_addr) {
> +		/* This will put CPU #1 into reset. */
> +		__raw_writel(RSTMGR_MPUMODRST_CPU1,
> +			     rst_manager_base_addr + SOCFPGA_RSTMGR_MODMPURST);
> +

I thought conclusion was to use writel (not __raw variant) here?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
