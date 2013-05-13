Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab3EMGHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 02:07:25 -0400
Received: from sauhun.de ([89.238.76.85]:59543 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab3EMGHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 02:07:24 -0400
Date: Mon, 13 May 2013 08:08:46 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Dan Williams <djbw@fb.com>, linux-tegra@vger.kernel.org
Subject: Re: [RFC 04/42] drivers/dma: don't check resource with
 devm_ioremap_resource
Message-ID: <20130513060842.GA2947@katana>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
 <1368173847-5661-5-git-send-email-wsa@the-dreams.de>
 <518D21D4.6000609@wwwdotorg.org>
 <20130510175739.GA2912@katana>
 <518D49B0.4050901@wwwdotorg.org>
 <20130512160440.GA27639@intel.com>
 <20130512182802.GA2922@katana>
 <20130513021000.GB27639@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130513021000.GB27639@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > > >>> devm_ioremap_resource does sanity checks on the given resource. No need to
> > > > >>> duplicate this in the driver.
> > > > >>
> > > > >>> diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
> > > > >>
> > > > >>>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > > > >>> -	if (!res) {
> > > > >>> -		dev_err(&pdev->dev, "No mem resource for DMA\n");
> > > > >>> -		return -EINVAL;
> > > > >>> -	}
> > > > >>> -
> > > > >>>  	tdma->base_addr = devm_ioremap_resource(&pdev->dev, res);
> > > > >>
> > > > >> One issue here is that it's not obvious just from reading the code
> > > > >> that's left behind that the "missing" error-checking of the
> > > > >> platform_get_resource() return value is OK because
> > > > >> devm_ioremap_resource() will check it "for us". Everyone now has to
> > > > >> mentally maintain a list of exceptions where it's OK not to error-check.
> > > > > 
> > > > > My goal is to make not-checking the standard case with devm.
> > > > 
> > > > OK, if no parameters passed to any devm function every need to be
> > > > error-checked, that'll certainly be a bit easier to remember.
> > > Okay to remove the log message and move to devm_ but I dont agree with this
> > > patch not returning error above. We shouldnt supress the error..
> > 
> > The error will be reported because devm_ioremap_resource will return an
> > ERR_PTR.
> And this patch removed the check on 'res' pointer, so on failure we continue...

I don't get it. What is the difference between a manual check of res and
the directly following devm_ioremap_resource returning ERR_PTR(-EINVAL)
if res is NULL?

