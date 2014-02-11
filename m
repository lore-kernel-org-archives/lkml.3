Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaBKQbC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:31:02 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:56660 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbaBKQa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:30:58 -0500
MIME-Version: 1.0
In-Reply-To: <20140211145248.GI26684@n2100.arm.linux.org.uk>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de>
	<CAL_Jsq+U9zU1i+STLHMBjY5BeEP6djYnJVE5X1ix-D2q_zWztQ@mail.gmail.com>
	<20140211145248.GI26684@n2100.arm.linux.org.uk>
Date: Tue, 11 Feb 2014 10:30:57 -0600
Message-ID: <CAL_Jsq+_81fUgio9mwscv__-4P6rUy-nHesnzCCUmdu+amhYPg@mail.gmail.com>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from
 drivers/media/v4l2-core to drivers/of
From: Rob Herring <robherring2@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 8:52 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Feb 11, 2014 at 07:56:33AM -0600, Rob Herring wrote:
>> On Tue, Feb 11, 2014 at 5:45 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
>> > This allows to reuse the same parser code from outside the V4L2 framework,
>> > most importantly from display drivers. There have been patches that duplicate
>> > the code (and I am going to send one of my own), such as
>> > http://lists.freedesktop.org/archives/dri-devel/2013-August/043308.html
>> > and others that parse the same binding in a different way:
>> > https://www.mail-archive.com/linux-omap@vger.kernel.org/msg100761.html
>> >
>> > I think that all common video interface parsing helpers should be moved to a
>> > single place, outside of the specific subsystems, so that it can be reused
>> > by all drivers.
>>
>> Perhaps that should be done rather than moving to drivers/of now and
>> then again to somewhere else.
>
> Do you have a better suggestion where it should move to?

No.

> drivers/gpu/drm - no, because v4l2 wants to use it
> drivers/media/video - no, because DRM drivers want to use it
> drivers/video - no, because v4l2 and drm drivers want to use it

I don't believe it exists currently, so it would need to be created.
Perhaps adding a layer of directory to combine these. This patch alone
is not enough to really justify that, but if there's a lot more shared
code possible then it would be the right direction.

> Maybe drivers/of-graph/ ?  Or maybe it's just as good a place to move it
> into drivers/of ?

I assume you weren't serious, but no for /of-graph. If a better place
can't be found/made, I'll take it.

Rob
