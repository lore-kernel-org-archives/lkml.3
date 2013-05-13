Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab3EMCo7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 22:44:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:37726 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703Ab3EMCo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 22:44:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,658,1363158000"; 
   d="scan'208";a="336537351"
Date: Mon, 13 May 2013 07:40:00 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Dan Williams <djbw@fb.com>, linux-tegra@vger.kernel.org
Subject: Re: [RFC 04/42] drivers/dma: don't check resource with
 devm_ioremap_resource
Message-ID: <20130513021000.GB27639@intel.com>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
 <1368173847-5661-5-git-send-email-wsa@the-dreams.de>
 <518D21D4.6000609@wwwdotorg.org>
 <20130510175739.GA2912@katana>
 <518D49B0.4050901@wwwdotorg.org>
 <20130512160440.GA27639@intel.com>
 <20130512182802.GA2922@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130512182802.GA2922@katana>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 12, 2013 at 08:28:07PM +0200, Wolfram Sang wrote:
> On Sun, May 12, 2013 at 09:34:40PM +0530, Vinod Koul wrote:
> > On Fri, May 10, 2013 at 01:25:36PM -0600, Stephen Warren wrote:
> > > On 05/10/2013 11:57 AM, Wolfram Sang wrote:
> > > > On Fri, May 10, 2013 at 10:35:32AM -0600, Stephen Warren wrote:
> > > >> On 05/10/2013 02:16 AM, Wolfram Sang wrote:
> > > >>> devm_ioremap_resource does sanity checks on the given resource. No need to
> > > >>> duplicate this in the driver.
> > > >>
> > > >>> diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
> > > >>
> > > >>>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > > >>> -	if (!res) {
> > > >>> -		dev_err(&pdev->dev, "No mem resource for DMA\n");
> > > >>> -		return -EINVAL;
> > > >>> -	}
> > > >>> -
> > > >>>  	tdma->base_addr = devm_ioremap_resource(&pdev->dev, res);
> > > >>
> > > >> One issue here is that it's not obvious just from reading the code
> > > >> that's left behind that the "missing" error-checking of the
> > > >> platform_get_resource() return value is OK because
> > > >> devm_ioremap_resource() will check it "for us". Everyone now has to
> > > >> mentally maintain a list of exceptions where it's OK not to error-check.
> > > > 
> > > > My goal is to make not-checking the standard case with devm.
> > > 
> > > OK, if no parameters passed to any devm function every need to be
> > > error-checked, that'll certainly be a bit easier to remember.
> > Okay to remove the log message and move to devm_ but I dont agree with this
> > patch not returning error above. We shouldnt supress the error..
> 
> The error will be reported because devm_ioremap_resource will return an
> ERR_PTR.
And this patch removed the check on 'res' pointer, so on failure we continue...

--
~Vinod
> 
