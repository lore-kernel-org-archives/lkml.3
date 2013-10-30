Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab3J3Vkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 17:40:41 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:51997 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab3J3Vkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 17:40:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAL_JsqJ3GANeMNi3iXQY_rB-NoovmwZx7EXfbG=rS6MxS=NLvQ@mail.gmail.com>
References: <1383113571-13029-1-git-send-email-robherring2@gmail.com>
	<20131030082621.GA22787@ulmo.nvidia.com>
	<CAL_JsqJ3GANeMNi3iXQY_rB-NoovmwZx7EXfbG=rS6MxS=NLvQ@mail.gmail.com>
Date: Wed, 30 Oct 2013 16:40:38 -0500
Message-ID: <CAL_JsqKna00oyhSd0qTYfLVFeE6d-gbekmV9tg7raPxmCTsYHQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] DT match helpers for initcalls and platform devices
From: Rob Herring <robherring2@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 3:02 PM, Rob Herring <robherring2@gmail.com> wrote:
> On Wed, Oct 30, 2013 at 3:26 AM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
>> On Wed, Oct 30, 2013 at 01:12:49AM -0500, Rob Herring wrote:
>>> From: Rob Herring <rob.herring@calxeda.com>
>>>
>>> This series adds a couple of boilerplate helpers to match with DT for
>>> initcalls and platform device creation and probe. The goal here is to
>>> remove more platform code out of arch/arm and eventually the machine
>>> descriptors.
>>
>> I fear that this is a step backwards because it makes it easier for
>> people to do the wrong thing. We've been doing the same with interrupt
>> controllers and clocks. With those there's at least the argument that
>> they need to be available really early and therefore cannot use the
>> regular driver model. But for everything else, shouldn't we enforce
>> proper drivers to be written?
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
>
>> Perhaps if you can point me to some examples I could get more context
>> why and where this would be useful.
>
> I'll push out a WIP branch later which has the above examples and
> removes the machine_desc struct for highbank. This all is more for
> arm64 which doesn't have or want to have a machine_desc.

Here is a branch with example users:

git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git
highbank-rm-mach-desc

Rob
