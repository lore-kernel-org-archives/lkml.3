Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272AbaDRIvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 04:51:10 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:39577 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750857AbaDRIvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 04:51:06 -0400
Date: Fri, 18 Apr 2014 09:50:19 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Joel Fernandes <joelf@ti.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] [FIX] dmaengine: virt-dma: Free descriptor after
	callback
Message-ID: <20140418085019.GN27282@n2100.arm.linux.org.uk>
References: <1397782610-7370-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397782610-7370-1-git-send-email-joelf@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 07:56:50PM -0500, Joel Fernandes wrote:
> Free the vd (virt descriptor) after the callback is called.  In EDMA driver
> atleast which uses virt-dma, we make use of the desc during the callback and if
> its dangerously freed before the callback is called. I also noticed this in
> omap-dma dmaengine driver.

You've missed the vital bit of information: why do you make use of the
descriptor afterwards?  You shouldn't.  omap-dma doesn't either.

Once clients submit their request to DMA engine, they must not hold any
kind of reference to the descriptor other than the cookie.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
