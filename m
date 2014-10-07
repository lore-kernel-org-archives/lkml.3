Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbaJGLRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 07:17:18 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54018 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbaJGLRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 07:17:17 -0400
Date: Tue, 7 Oct 2014 13:17:15 +0200
From: Pavel Machek <pavel@denx.de>
To: atull@opensource.altera.com
Cc: dinguyen@opensource.altera.com, linux@arm.linux.org.uk,
        yvanderv@opensource.altera.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, delicious.quinoa@gmail.com
Subject: Re: [PATCH v2 2/2] socfpga: support suspend to ram
Message-ID: <20141007111715.GB6904@amd>
References: <1412192304-1209-1-git-send-email-atull@opensource.altera.com>
 <1412192304-1209-3-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412192304-1209-3-git-send-email-atull@opensource.altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Alan Tull <atull@opensource.altera.com>
> 
> Add code that requests that the sdr controller go into
> self-refresh mode.  This code is run from ocram.
> 
> This patch assumes that u-boot has already configured sdr:
>   sdr.ctrlcfg.lowpwreq.selfrfshmask = 3
>   sdr.ctrlcfg.lowpwrtiming.clkdisablecycles = 8
>   sdr.ctrlcfg.dramtiming4.selfrfshexit = 512
> 
> How to suspend to ram:
>  $ echo enabled > \
> /sys/devices/soc/ffc02000.serial0/tty/ttyS0/power/wakeup
> 
>  $ echo -n mem > /sys/power/state
> 
> Signed-off-by: Alan Tull <atull@opensource.altera.com>

> +static int __init socfpga_pm_init(void)
> +{
> +	if (socfpga_setup_ocram_self_refresh())
> +		return -EFAULT;

It would be nice to propagate the error result here.

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
