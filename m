Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283AbaJGXmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:42:33 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:65359 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526AbaJGXma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:42:30 -0400
Date: Tue, 7 Oct 2014 16:42:24 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Kiran Padwal <kiran.padwal@smartplayin.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "Cavin, Courtney" <Courtney.Cavin@sonymobile.com>
Subject: Re: [PATCH 1/2] input: Add Qualcomm PM8941 power key driver
Message-ID: <20141007234224.GL16469@dtor-ws>
References: <1412644321-27683-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1412644321-27683-2-git-send-email-bjorn.andersson@sonymobile.com>
 <5433B843.5060200@smartplayin.com>
 <20141007233045.GD31125@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007233045.GD31125@sonymobile.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 04:30:46PM -0700, Bjorn Andersson wrote:
> On Tue 07 Oct 02:54 PDT 2014, Kiran Padwal wrote:
> 
> > On Tuesday 07 October 2014 06:42 AM, Bjorn Andersson wrote:
> > > From: Courtney Cavin <courtney.cavin@sonymobile.com>
> > > 
> > > Signed-off-by: Courtney Cavin <courtney.cavin@sonymobile.com>
> > > Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> > > ---
> > >  drivers/input/misc/Kconfig         |   12 +++
> > >  drivers/input/misc/Makefile        |    1 +
> > >  drivers/input/misc/pm8941-pwrkey.c |  196 ++++++++++++++++++++++++++++++++++++
> > 
> > <snip>
> > 
> > > +
> > > +	platform_set_drvdata(pdev, pwrkey);
> > > +	device_init_wakeup(&pdev->dev, 1);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int pm8941_pwrkey_remove(struct platform_device *pdev)
> > > +{
> > > +	device_init_wakeup(&pdev->dev, 0);
> > 
> > Shouldn't we unregister input device?
> > 
> 
> It's allocated with devm_input_allocate_device() so I assumed that it goes away
> upon the device being removed. Looking at input_register_device() seems to
> confirm that.

Yes, devices allocated with devm_input_allocate_device() will be
unregistered and freed automatically.

Thanks.

-- 
Dmitry
