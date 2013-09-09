Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab3IIUHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 16:07:00 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:59023 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483Ab3IIUGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 16:06:45 -0400
MIME-Version: 1.0
X-Originating-IP: [85.250.18.220]
In-Reply-To: <20130909125745.GD22197@ulmo>
References: <5220F099.1020002@nvidia.com> <CAK=WgbZ2JgtAonvdyeDZazYBGdKpPAieJtjzi7MM6nwqhVfs7g@mail.gmail.com>
 <20130909125745.GD22197@ulmo>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 9 Sep 2013 22:06:24 +0200
Message-ID: <CAK=Wgbbxp5pfQm1mvCZ2phigXe_e2_J_Zkrof9tx2jggi8EMjQ@mail.gmail.com>
Subject: Re: permission to move definition of struct rpmsg_channel_info
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Arjun Gopalan <agopalan@nvidia.com>, Brian Swetland <swetland@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Paul Walmsley <pwalmsley@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 9, 2013 at 2:57 PM, Thierry Reding <thierry.reding@gmail.com> wrote:
> If I understand correctly, the way that the services should be announced
> is via RSC_VDEV entries in the resource table?

Yes.

> Looking at the remoteproc core and ELF loader, it seems like the way to
> pass in the resource table is either via an extra ELF section or driver
> specific. TI drivers seem to use ELF, but the STE modem driver seems to
> employ some custom format.
>
> From what I understand this resource table can also be processed by the
> host to provide some of the resources such as carveout memory. So that
> the normal way for this to work would be something like:
>
>         - load firmware image
>           - obtain pointer to resource table
>         - process resource table
>           - allocate resources
>           - update table
>         - upload firmware to remote processor
>
> Upon which the remote processor probably needs to parse the resource
> table to set itself up. Does that sound about right?

Yeah, it generally does.

> > The way we were planning to add static channels functionality (I
> > should still have preliminary patches doing this somewhere but the
> > entire work was put on hold since TI changed its focus) is by
> > statically publishing them in the resource table, which is coupled
> > with a specific remote image.
>
> While I see that the format of all this is pretty well documented, are
> there any standard tools that can be used to embed the resource table
> into an ELF binary?

I'm not aware of any.

> I have a pretty good idea on how it could be done,
> but I wonder if it might make sense to provide some kind of a standard
> set of headers to make things easier so that not everyone has to
> reinvent the wheel.
>
> Looking at the remoteproc core, it seems that there's no direct way to
> change the firmware running on a remoteproc at runtime.

One way is to unload and load the driver, but you can also use the
bind/unbind sysfs files of your driver (echo -n device-name >
/sys/..../{un}bind).

Does that help?

Best,
Ohad.
