Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab3KUXMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 18:12:10 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55236 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab3KUXMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 18:12:08 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC PATCH 1/2] driver core: introduce module_platform_driver_match_and_probe
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>
In-Reply-To: <CAL_JsqLK_ivSphWq3xLpQqUjF1nEvPjf2WQ4hJ+hThcTFae-Kg@mail.gmail.com>
References: <1383113571-13029-1-git-send-email-robherring2@gmail.com> < 1383113571-13029-2-git-send-email-robherring2@gmail.com> <20131121124736. 6EBEBC40A2C@trevor.secretlab.ca> < CAL_JsqLK_ivSphWq3xLpQqUjF1nEvPjf2WQ4hJ+hThcTFae-Kg@mail.gmail.com>
Date: Thu, 21 Nov 2013 23:11:59 +0000
Message-Id: <20131121231159.9CB1BC40753@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Nov 2013 16:33:13 -0600, Rob Herring <robherring2@gmail.com> wrote:
> On Thu, Nov 21, 2013 at 6:47 AM, Grant Likely <grant.likely@linaro.org> wrote:
> > On Wed, 30 Oct 2013 01:12:50 -0500, Rob Herring <robherring2@gmail.com> wrote:
> >> From: Rob Herring <rob.herring@calxeda.com>
> >>
> >> Introduce a helper to match, create and probe a platform device. This
> >> is for drivers such as cpuidle or cpufreq that typically don't have a
> >> bus device node and need to match on a system-level compatible property.
> >>
> >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> Cc: Grant Likely <grant.likely@linaro.org>
> >> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> >
> > Oh, ick. Please no. If a platform_device isn't getting created for a
> > device tree node, then we should be asking why it isn't getting created
> > and fix the core logic rather than trying to bodge it in the driver init
> > code.
> >
> > We should never be creating and registering devices in module init code.
> > We've spent the last 4 years trying to get away from that.
> 
> This is for devices that have no DT device node to be associated with
> and therefore will never have a device created by the core DT code.
> Instead the devices are created based off of the root compatible
> property. cpuidle drivers are one such example [1]. We already do this
> today by putting the platform device creation in the
> machine_desc.init_machine function which is a conditional initcall.
> The motivation for changing this is how to support drivers like this
> on arm64 which doesn't want any platform code or machine_desc. At
> least historically, we didn't want DT nodes of Linux specific devices
> in the DT. So, how would you propose to solve this problem?

Honestly? With a machine_desc.  :-)

Actually, I'm totally serious here. That is why machine_desc is still a
good idea. There are always going to be a few per-platform bits that
need to be present, although the hope is the per-platform will be at the
SoC family level instead of the board level.

g.

