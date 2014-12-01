Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbaLAPDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 10:03:20 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:42028 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbaLAPDT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 10:03:19 -0500
MIME-Version: 1.0
In-Reply-To: <1454366.cVgT9MeyeC@diego>
References: <1416217842-4716-1-git-send-email-caesar.wang@rock-chips.com> <1454366.cVgT9MeyeC@diego>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 1 Dec 2014 23:57:01 +0900
Message-ID: <CAAFQd5BvNKsuRmMkh7C9hYPQCwiDFXUuN2SwcxtfLu5KmHdymA@mail.gmail.com>
Subject: Re: [PATCH v12 0/3] ARM: rk3288: Add PM Domain support
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: Caesar Wang <caesar.wang@rock-chips.com>, khilman@kernel.org,
        linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, dianders@chromium.org,
        linux-rockchip@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, fzf@rock-chips.com,
        cf@rock-chips.com, chris.zhong@rock-chips.com, xxm@rock-chips.com,
        chm@rock-chips.com, djkurtz@chromium.org,
        "jinkun.hong" <jinkun.hong@rock-chips.com>,
        Jack Dai <jack.dai@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 6:57 PM, Heiko Stübner <heiko@sntech.de> wrote:
>
> Am Montag, 17. November 2014, 17:50:38 schrieb Caesar Wang:
> >     Add power domain drivers based on generic power domain for
> >     Rockchip platform, and support RK3288.
> >
> >     https://chromium-review.googlesource.com/#/c/220253/9
> >     This is the GPU driver, add the following information in DT,
> >     and it can support the PMDOMAIN
>
> I'm not sure what to do with this series. Kevin had concerns about the clocks
> being part of the power-domains and I don't see them actually addressed and/or
> Kevin being satisfied - actually he isn't even on the recipients list of this
> version of the series.
>
>
> @Ceasar: you should include people being part of important previous
> conversations in new versions of patchsets - especially when they have voiced
> concerns.
>
>
> I've added Tomasz whom I remember having previous experience on the Exynos
> Powerdomains, so maybe he can add some other perspective - new ideas.
>

Thanks Heiko for adding me to this thread.

>
> @Tomasz: this is the part of Kevin's concerns from v10 of the powerdomain
> series:
>
> Am Donnerstag, 13. November 2014, 12:24:47 schrieben Kevin Hilman:
> > Heiko Stübner <heiko@sntech.de> writes:
> > > Am Dienstag, 11. November 2014, 08:53:13 schrieb Kevin Hilman:
> > >> I still don't like having lists of clocks in the power-domain DT.
> > >>
> > >> DT is supposed to describe the hardware, and clocks are properties of
> > >> devices, not power-domains, so the DT description should follow from
> > >> that.
> > >
> > > on the policy side one could argue that if the clock needs to be enabled
> > > to
> > > achieve sucessful domain state-changes, that it is also a property of the
> > > domain itself in addition to the device.
> >
> > You could, but from a hardware perspective, the clock is a property of
> > the device.
> >

Well, the system controller which control the power domains is also a
device. In DT we do not represent the domains alone, but rather the
system controller, which acts as a power domain provider. If it need
certain clocks to do its work, then I believe it should have them
listed in its node. However the dependencies between clocks and power
domains are not clear to me either, so I don't have any strong opinion
on whether this would be the best solution.

> > > And on the pratical side we don't have drivers nor bindings for a big part
> > > of the domain users - and this will probably be true for quite some time.
> > > This of course makes it very impractical (or impossible) to collect the
> > > clocks for parts like the gpu (mali), hevc, vcodec (video
> > > encoder/decoder), rga (2d stuff), iep, isp.
> >
> > This doesn't sound impossible at all.
> >
> > You have to collect the clocks anyways.  The only debate is whether to
> > list them in the device node or the power-domain node.
> >
> > Even for devices without drivers, you just need a minimal node in the DT if
> > which lists the clocks and has a phandle to the parent power domain.
> >
> > Sounds rather simple to me, and since the DT is supposed to describe the
> > hardware, doing it this way makes looking at the DT actually help
> > understand the hardware.
>

If the dependency between clocks and power domain is kind of "all
clocks of all devices in this domain should be enabled when performing
operation on the domain" then IMHO it should be more reasonable to put
the clocks only in nodes of respective devices and then follow the
links from the domain to devices inside of it and retrieve the clocks
from there, so that they don't have to be duplicated. AFAIK, we don't
like redundancy in DT.

Best regards,
Tomasz
