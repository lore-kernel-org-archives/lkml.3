Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaCALYo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 06:24:44 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50383 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbaCALYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 06:24:41 -0500
MIME-Version: 1.0
In-Reply-To: <20140228165253.GA19872@kroah.com>
References: <1393261707-30565-1-git-send-email-joshc@codeaurora.org>
	<1393261707-30565-4-git-send-email-joshc@codeaurora.org>
	<20140225183336.GH23275@saruman.home>
	<20140227190324.GC4421@kroah.com>
	<20140227234129.GA21032@psi-dev26.jf.intel.com>
	<20140227234425.GA32426@kroah.com>
	<CAPDyKFp3R=w6Vx6zCHZQJXgLgh=u5HdwmUcbgkbsGb=pVah9Mw@mail.gmail.com>
	<20140228165253.GA19872@kroah.com>
Date: Sat, 1 Mar 2014 12:24:40 +0100
Message-ID: <CAPDyKFowEvsJdebu2GmSc7U3uiW3SpG_N54O1=XX5hPr+M9Jwg@mail.gmail.com>
Subject: Re: [PATCH 3/3] usb: phy: msm: use ASSIGN_*_PM_OPS variants
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: David Cohen <david.a.cohen@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 February 2014 17:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Fri, Feb 28, 2014 at 09:48:08AM +0100, Ulf Hansson wrote:
>> On 28 February 2014 00:44, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > On Thu, Feb 27, 2014 at 03:41:31PM -0800, David Cohen wrote:
>> >> On Thu, Feb 27, 2014 at 11:03:24AM -0800, Greg Kroah-Hartman wrote:
>> >> > On Tue, Feb 25, 2014 at 12:33:36PM -0600, Felipe Balbi wrote:
>> >> > > Hi,
>> >> > >
>> >> > > On Mon, Feb 24, 2014 at 11:08:27AM -0600, Josh Cartwright wrote:
>> >> > > > Use ASSIGN_SYSTEM_SLEEP_PM_OPS and ASSIGN_RUNTIME_PM_OPS in the
>> >> > > > initializer for msm_otg_dev_pm_ops.  Doing so allows us to eliminate
>> >> > > > preprocessor conditionals around the specified callbacks.
>> >> > > >
>> >> > > > Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
>> >> > > > ---
>> >> > > >  drivers/usb/phy/phy-msm-usb.c | 13 +++----------
>> >> > > >  1 file changed, 3 insertions(+), 10 deletions(-)
>> >> > > >
>> >> > > > diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
>> >> > > > index 5b37b81..c04f2e3 100644
>> >> > > > --- a/drivers/usb/phy/phy-msm-usb.c
>> >> > > > +++ b/drivers/usb/phy/phy-msm-usb.c
>> >> > > > @@ -414,8 +414,6 @@ static int msm_otg_reset(struct usb_phy *phy)
>> >> > > >  #define PHY_SUSPEND_TIMEOUT_USEC       (500 * 1000)
>> >> > > >  #define PHY_RESUME_TIMEOUT_USEC        (100 * 1000)
>> >> > > >
>> >> > > > -#ifdef CONFIG_PM
>> >> > > > -
>> >> > > >  #define USB_PHY_SUSP_DIG_VOL  500000
>> >> > > >  static int msm_hsusb_config_vddcx(int high)
>> >> > > >  {
>> >> > > > @@ -609,7 +607,6 @@ skip_phy_resume:
>> >> > > >
>> >> > > >         return 0;
>> >> > > >  }
>> >> > > > -#endif
>> >> > > >
>> >> > > >  static void msm_otg_notify_charger(struct msm_otg *motg, unsigned mA)
>> >> > > >  {
>> >> > > > @@ -1664,7 +1661,6 @@ static int msm_otg_remove(struct platform_device *pdev)
>> >> > > >         return 0;
>> >> > > >  }
>> >> > > >
>> >> > > > -#ifdef CONFIG_PM_RUNTIME
>> >> > > >  static int msm_otg_runtime_idle(struct device *dev)
>> >> > > >  {
>> >> > > >         struct msm_otg *motg = dev_get_drvdata(dev);
>> >> > > > @@ -1699,9 +1695,7 @@ static int msm_otg_runtime_resume(struct device *dev)
>> >> > > >         dev_dbg(dev, "OTG runtime resume\n");
>> >> > > >         return msm_otg_resume(motg);
>> >> > > >  }
>> >> > > > -#endif
>> >> > > >
>> >> > > > -#ifdef CONFIG_PM_SLEEP
>> >> > > >  static int msm_otg_pm_suspend(struct device *dev)
>> >> > > >  {
>> >> > > >         struct msm_otg *motg = dev_get_drvdata(dev);
>> >> > > > @@ -1731,12 +1725,11 @@ static int msm_otg_pm_resume(struct device *dev)
>> >> > > >
>> >> > > >         return 0;
>> >> > > >  }
>> >> > > > -#endif
>> >> > > >
>> >> > > >  static const struct dev_pm_ops msm_otg_dev_pm_ops = {
>> >> > > > -       SET_SYSTEM_SLEEP_PM_OPS(msm_otg_pm_suspend, msm_otg_pm_resume)
>> >> > > > -       SET_RUNTIME_PM_OPS(msm_otg_runtime_suspend, msm_otg_runtime_resume,
>> >> > > > -                               msm_otg_runtime_idle)
>> >> > > > +       ASSIGN_SYSTEM_SLEEP_PM_OPS(msm_otg_pm_suspend, msm_otg_pm_resume)
>> >> > > > +       ASSIGN_RUNTIME_PM_OPS(msm_otg_runtime_suspend, msm_otg_runtime_resume,
>> >> > > > +                             msm_otg_runtime_idle)
>> >> > >
>> >> > > if the patch introducing assign_if() gets accepted, I'm ok with this
>> >> > > patch.
>> >> >
>> >> > I can't take that patch at this point in time, it's just too ugly...
>> >> >
>> >> > As are those crazy SET_SYSTEM_SLEEP_PM_OPS() macros, ick, who made those
>> >> > things?
>> >> >
>> >> > What language are we trying to program in here people?
>> >>
>> >> Since we're discussing this topic here, I'd like point my RFC which gets
>> >> rid of same ifdeffery in a different way:
>> >> http://lkml.org/lkml/2013/12/13/4
>> >
>> > Again, why can't we just always define these fields in the structure,
>> > then we don't need any crazy, complicated mess for assigning the
>> > function pointers?
>> >
>> > Again, the odds that this config option is ever disabled in "real"
>> > systems is so low these days, I have half a mind just to rip it out
>> > entirely as the amount of work spent on compiler warnings and the like
>> > in this area has proably offset any power savings the code was supposed
>> > to save on systems :(
>>
>> Your point is certainly valid. I suppose the footprint of the kernel
>> is nothing we should bother about? We have other solutions for that,
>> right?
>
> What does the "footprint of the kernel" have to do with an option that
> everyone enables as they want/need the functionality?  You are only
> talking about saving size for systems that do not exist.  Do you know of
> any commen system that cares about size and yet not power that would be
> affected by this change?

It was more a hypothetical thought. I can't give you any examples of
products and I certainly think your suggestion makes sense.

What I had in mind were my experience from flashloaders and
productiontools. Those often requires a fast boot which don't cares
about PM. One of many things that helps here, is a "small" footprint
of the kernel. But I guess this becomes quite hypothetical and I guess
we shouldn't consider this as a valid argument!?

>
> And exactly how much "size" are we talking about here?  Did the
> available memory size for new chips just increase more in me writing
> this email than the size that this proposed patch would have offset?

I only had the fast boot in mind... :-)

Kind regards
Ulf Hansson

>
> greg k-h
