Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab3JAIWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 04:22:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43705 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751716Ab3JAIWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 04:22:39 -0400
Date: Tue, 1 Oct 2013 09:22:36 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: myungjoo.ham@samsung.com, broonie@kernel.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] extcon: arizona: Get pdata from arizona structure not
	device
Message-ID: <20131001082236.GZ3635@opensource.wolfsonmicro.com>
References: <1380378897-7164-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <5248B9BA.9020003@samsung.com> <20130930095202.GY3635@opensource.wolfsonmicro.com> <524A0369.1080101@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524A0369.1080101@samsung.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 08:04:09AM +0900, Chanwoo Choi wrote:
> On 09/30/2013 06:52 PM, Charles Keepax wrote:
> > On Mon, Sep 30, 2013 at 08:37:30AM +0900, Chanwoo Choi wrote:
> >> No, extcon-arizona driver don't currently support DT to get platform data.
> >> I cannot find some dt function to parse data from dts file.
> >> You have to implement extcon-arizona driver by using DT binding style
> >> to get platform data. I think this patch is not necessary.
> > 
> > Currently the Arizona MFD driver reads the device tree
> > information and populates the pdata structure, this happens in
> > drivers/mfd/arizona-core.c. Then the various drivers just use the
> > pdata as normal.
> > 
> > Admittedly, at the moment we don't parse any data for the extcon
> > driver but without this patch we will attempt to use a NULL
> > pointer on device tree systems.
> > 
> > I would also be happy to implement this as a NULL check on the
> > pdata when we use it if that is preferable? But since we have the
> > cached pdata seems we might as well use it.
> > 
> 
> I find below pdata list for extcon-arizona driver.
> But, drivers/mfd/arizona-core.c don't parse dt data for below pdata list
> of extcon-arizona. Did you test this patch for extcon-arizona operation?

The extcon driver will function using its default settings if
blank pdata is provided, so it has been tested with those
settings. I am presently working on device tree bindings for the
pdata for the extcon driver which I hope to send a new spin of
upstream this week or next, so it has been tested against the
first version of those patches as well.

> +       if (!pdata) {
> +               dev_err(&pdev->dev, "Failed to get platform data\n");
> +               return -EINVAL;
> +       }

I think this would be unecessary churn as I would have to take it
out and replace it with this patch once the bindings are complete.

That said I don't really mind waiting to merge this patch until I
have upstreamed the first of the device tree bindings for the
extcon driver if you feel strongly about it? Or indeed I could
even send the patch as part of that series?

Thanks,
Charles
