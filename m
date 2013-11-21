Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab3KUMxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 07:53:55 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:62246 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab3KUMxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 07:53:53 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC PATCH 0/2] DT match helpers for initcalls and platform devices
To: Rob Herring <robherring2@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>
In-Reply-To: <CAL_JsqJ3GANeMNi3iXQY_rB-NoovmwZx7EXfbG=rS6MxS=NLvQ@mail.gmail.com>
References: <1383113571-13029-1-git-send-email-robherring2@gmail.com> < 20131030082621.GA22787@ulmo.nvidia.com> < CAL_JsqJ3GANeMNi3iXQY_rB-NoovmwZx7EXfbG=rS6MxS=NLvQ@mail.gmail.com>
Date: Thu, 21 Nov 2013 12:53:49 +0000
Message-Id: <20131121125349.9727DC40A2C@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Oct 2013 15:02:40 -0500, Rob Herring <robherring2@gmail.com> wrote:
> On Wed, Oct 30, 2013 at 3:26 AM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > On Wed, Oct 30, 2013 at 01:12:49AM -0500, Rob Herring wrote:
> >> From: Rob Herring <rob.herring@calxeda.com>
> >>
> >> This series adds a couple of boilerplate helpers to match with DT for
> >> initcalls and platform device creation and probe. The goal here is to
> >> remove more platform code out of arch/arm and eventually the machine
> >> descriptors.
> >
> > I fear that this is a step backwards because it makes it easier for
> > people to do the wrong thing. We've been doing the same with interrupt
> > controllers and clocks. With those there's at least the argument that
> > they need to be available really early and therefore cannot use the
> > regular driver model. But for everything else, shouldn't we enforce
> > proper drivers to be written?
> 
> You think both are a step backwards or just the initcall one? For
> initcalls, there are things which are not drivers, but just one time
> init.  The example on highbank is highbank_pm_init. In some cases like
> cpuidle, they have been converted to platform drivers, but then we
> have platform code to create devices if we are on the relevant
> platform. There is not really a real device node that exists for some
> of these drivers and we need to create the device rather than the
> device getting created by scanning the buses in the DT.
> 
> I think this is less error prone because we've had cases of
> unconditional initcalls which break multi-platform kernels.

In that situation, it would probably be better to simply do what you
need to do at initcall level and not register a struct device at all.

If the situation is you absolutely need to create a device because the
DT does not provide what you need (and the DT cannot be changed) then I
strongly recommend separating the driver code and the registration code
into separate blocks because it enforces separation between device
enumaration and device driver probing.

g.

