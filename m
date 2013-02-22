Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab3BVHzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 02:55:43 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:65189 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab3BVHzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 02:55:40 -0500
Date: Fri, 22 Feb 2013 07:55:35 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, arnd@arndb.de, linus.walleij@stericsson.com,
        Daniel WILLERUD <daniel.willerud@stericsson.com>
Subject: Re: [PATCH 01/35] mfd: ab8500-gpadc: Implemented suspend/resume
Message-ID: <20130222075535.GH4417@gmail.com>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
 <1360933026-30325-2-git-send-email-lee.jones@linaro.org>
 <20130220131912.GB13049@sirena.org.uk>
 <CAPDyKFo0MpP-d7v8v1zwB42sboR3MWT6nUmG=-L0_nayYRY7FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPDyKFo0MpP-d7v8v1zwB42sboR3MWT6nUmG=-L0_nayYRY7FQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2013, Ulf Hansson wrote:

> On 20 February 2013 14:19, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
> > On Fri, Feb 15, 2013 at 12:56:32PM +0000, Lee Jones wrote:
> >
> >> +static int ab8500_gpadc_suspend(struct device *dev)
> >> +{
> >> +     struct ab8500_gpadc *gpadc = dev_get_drvdata(dev);
> >> +
> >> +     mutex_lock(&gpadc->ab8500_gpadc_lock);
> >> +
> >> +     pm_runtime_get_sync(dev);
> >> +
> >> +     regulator_disable(gpadc->regu);
> >> +     return 0;
> >> +}
> >
> > This doesn't look especially sane...  You're doing a runtime get, taking
> > the lock without releasing it and disabling the regulator.  This is
> > *very* odd, both the changelog and the code need to explain what's going
> > on and why it's safe in a lot more detail here.
> 
> You need to do pm_runtime_get_sync to be able to make sure resources
> (which seems to be only the regulator) are safe to switch off. To my
> understanding this is a generic way to use for being able to switch
> off resources at a device suspend when runtime pm is used in
> conjunction.
> 
> Regarding the mutex, I can't tell the reason behind it. It seems
> strange but not sure.

Daniel, any thoughts?

I'm happy to fixup, once I have the full story.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
