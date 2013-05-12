Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab3ELQjo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 12:39:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:3087 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293Ab3ELQjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 12:39:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,657,1363158000"; 
   d="scan'208";a="332875451"
Date: Sun, 12 May 2013 21:34:40 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org,
        Dan Williams <djbw@fb.com>, linux-tegra@vger.kernel.org
Subject: Re: [RFC 04/42] drivers/dma: don't check resource with
 devm_ioremap_resource
Message-ID: <20130512160440.GA27639@intel.com>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
 <1368173847-5661-5-git-send-email-wsa@the-dreams.de>
 <518D21D4.6000609@wwwdotorg.org>
 <20130510175739.GA2912@katana>
 <518D49B0.4050901@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518D49B0.4050901@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 01:25:36PM -0600, Stephen Warren wrote:
> On 05/10/2013 11:57 AM, Wolfram Sang wrote:
> > On Fri, May 10, 2013 at 10:35:32AM -0600, Stephen Warren wrote:
> >> On 05/10/2013 02:16 AM, Wolfram Sang wrote:
> >>> devm_ioremap_resource does sanity checks on the given resource. No need to
> >>> duplicate this in the driver.
> >>
> >>> diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
> >>
> >>>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >>> -	if (!res) {
> >>> -		dev_err(&pdev->dev, "No mem resource for DMA\n");
> >>> -		return -EINVAL;
> >>> -	}
> >>> -
> >>>  	tdma->base_addr = devm_ioremap_resource(&pdev->dev, res);
> >>
> >> One issue here is that it's not obvious just from reading the code
> >> that's left behind that the "missing" error-checking of the
> >> platform_get_resource() return value is OK because
> >> devm_ioremap_resource() will check it "for us". Everyone now has to
> >> mentally maintain a list of exceptions where it's OK not to error-check.
> > 
> > My goal is to make not-checking the standard case with devm.
> 
> OK, if no parameters passed to any devm function every need to be
> error-checked, that'll certainly be a bit easier to remember.
Okay to remove the log message and move to devm_ but I dont agree with this
patch not returning error above. We shouldnt supress the error..

--
~Vinod
