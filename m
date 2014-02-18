Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbaBRKna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:43:30 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42229 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622AbaBRKn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:43:27 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-9b-5303394c3018
Message-id: <5303394B.2020004@samsung.com>
Date: Tue, 18 Feb 2014 11:43:23 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robherring2@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from
 drivers/media/v4l2-core to drivers/of
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de>
 <CAL_Jsq+U9zU1i+STLHMBjY5BeEP6djYnJVE5X1ix-D2q_zWztQ@mail.gmail.com>
 <20140217181451.7EB7FC4044D@trevor.secretlab.ca>
In-reply-to: <20140217181451.7EB7FC4044D@trevor.secretlab.ca>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t/xK7o+lszBBuePGVrMP3KO1eLAnx2M
	Fmeb3rBbdE5cwm5xedccNoueDVtZLW5f5rW4uE7e4u69EywWW+edY7Ro3XuE3eL7t29sFuvn
	32Jz4PVoae5h89g56y67x+yOmawem1Z1snncubaHzaP/r4FH35ZVjB7Hb2xn8vi8SS6AM4rL
	JiU1J7MstUjfLoEr4+z5C4wFTVIV7xceYWlgXCfaxcjJISFgIrFx1TEmCFtM4sK99WxdjFwc
	QgJLGSWmPvzLBOF8YpToujqDHaSKV0BL4sm128wgNouAqkTb5lNgNpuAoUTv0T5GEFtUIELi
	1dmJLBD1ghI/Jt8Ds0VAeud8BtvALHCRRaJl9j6wBmGBVIm1h2+zQmw7wCgxff9pVpAEp4Ct
	xMbdy8C6mQV0JPa3TmODsOUlNq95yzyBUWAWkiWzkJTNQlK2gJF5FaNoamlyQXFSeq6hXnFi
	bnFpXrpecn7uJkZIJH3Zwbj4mNUhRgEORiUe3g/KTMFCrIllxZW5hxglOJiVRHj9zJiDhXhT
	EiurUovy44tKc1KLDzEycXBKNTD6HngUzpLQf+FJCcOzZxM53omb2llbfHfWbTSQU5dJD7G/
	ob8wmUf6punVb9yvU1X9wyOVXT/PKMkMfvmkL5otO3iKsn248v5Ys/g7LFaCFsxH5P747rv1
	v/dW4KzfdacdLR5kVE7Rfyzg5njNM+Egp0fghk9FOz++WPfija9w5HHWg5sq/JVYijMSDbWY
	i4oTARaA3OSCAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/02/14 19:14, Grant Likely wrote:
> On Tue, 11 Feb 2014 07:56:33 -0600, Rob Herring <robherring2@gmail.com> wrote:
>> > On Tue, Feb 11, 2014 at 5:45 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
>>> > > From: Philipp Zabel <philipp.zabel@gmail.com>
>>> > >
>>> > > This patch moves the parsing helpers used to parse connected graphs
>>> > > in the device tree, like the video interface bindings documented in
>>> > > Documentation/devicetree/bindings/media/video-interfaces.txt, from
>>> > > drivers/media/v4l2-core to drivers/of.
>> > 
>> > This is the opposite direction things have been moving...
>> > 
>>> > > This allows to reuse the same parser code from outside the V4L2 framework,
>>> > > most importantly from display drivers. There have been patches that duplicate
>>> > > the code (and I am going to send one of my own), such as
>>> > > http://lists.freedesktop.org/archives/dri-devel/2013-August/043308.html
>>> > > and others that parse the same binding in a different way:
>>> > > https://www.mail-archive.com/linux-omap@vger.kernel.org/msg100761.html
>>> > >
>>> > > I think that all common video interface parsing helpers should be moved to a
>>> > > single place, outside of the specific subsystems, so that it can be reused
>>> > > by all drivers.
>> > 
>> > Perhaps that should be done rather than moving to drivers/of now and
>> > then again to somewhere else.
>
> This is just parsing helpers though, isn't it? I have no problem pulling
> helper functions into drivers/of if they are usable by multiple
> subsystems. I don't really understand the model being used though. I
> would appreciate a description of the usage model for these functions
> for poor folks like me who can't keep track of what is going on in
> subsystems.

Yes, this is (mostly) just parsing helpers to walk graph of connected (sub-)
devices. Originally I though about adding this code to drivers/of/of_video.c, 
nevertheless it ended up in drivers/media/vl2-core/v4l2-of.c. However those
helpers, likely only after some improvements/enhancements, could be used 
in other subsystems like drivers/video or drivers/gpu/drm, wherever a whole
device consists of multiple connected sub-devices. 

These helpers are supposed to be used (generically) to walk a graph of 
sub-devices, e.g. to find a remote sub-device (e.g. a data transmitter) 
to some sub-device (e.g. a data receiver) in order to configure it for 
data transmission.

This parsing helpers code could be somehow related to rmk's componentized 
device handling [1], in a sense it is supposed to be similarly generic.

I think having those helpers in a common location and shared by subsystems
could be useful in terms of consistent DT bindings for same devices (e.g.
displays) handled currently by multiple kernel subsystems, e.g. DRM, FB, 
V4L2.

Of course there might be still some work needed so these helpers are usable
for all (e.g. simplifying corresponding DT binding to have less bloated
description for very simple devices - this has been on my todo list), but 
it would be really nice to first agree to the common location. 


[1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/base/component.c?id=2a41e6070dd7ef539d0f3b1652b4839d04378e11
 
--
Thanks,
Sylwester
