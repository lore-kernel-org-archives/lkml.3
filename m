Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770AbaK1JxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 04:53:22 -0500
Received: from gloria.sntech.de ([95.129.55.99]:35352 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbaK1JxS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 04:53:18 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Caesar Wang <caesar.wang@rock-chips.com>, khilman@kernel.org,
        tfiga@chromium.org
Cc: linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
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
Subject: Re: [PATCH v12 0/3] ARM: rk3288: Add PM Domain support
Date: Fri, 28 Nov 2014 10:57 +0100
Message-ID: <1454366.cVgT9MeyeC@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1416217842-4716-1-git-send-email-caesar.wang@rock-chips.com>
References: <1416217842-4716-1-git-send-email-caesar.wang@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 17. November 2014, 17:50:38 schrieb Caesar Wang:
>     Add power domain drivers based on generic power domain for
>     Rockchip platform, and support RK3288.
> 
>     https://chromium-review.googlesource.com/#/c/220253/9
>     This is the GPU driver, add the following information in DT,
>     and it can support the PMDOMAIN

I'm not sure what to do with this series. Kevin had concerns about the clocks 
being part of the power-domains and I don't see them actually addressed and/or 
Kevin being satisfied - actually he isn't even on the recipients list of this 
version of the series.


@Ceasar: you should include people being part of important previous 
conversations in new versions of patchsets - especially when they have voiced 
concerns.


I've added Tomasz whom I remember having previous experience on the Exynos 
Powerdomains, so maybe he can add some other perspective - new ideas.


@Tomasz: this is the part of Kevin's concerns from v10 of the powerdomain 
series:

Am Donnerstag, 13. November 2014, 12:24:47 schrieben Kevin Hilman:
> Heiko Stübner <heiko@sntech.de> writes:
> > Am Dienstag, 11. November 2014, 08:53:13 schrieb Kevin Hilman:
> >> I still don't like having lists of clocks in the power-domain DT.
> >> 
> >> DT is supposed to describe the hardware, and clocks are properties of
> >> devices, not power-domains, so the DT description should follow from
> >> that.
> > 
> > on the policy side one could argue that if the clock needs to be enabled
> > to
> > achieve sucessful domain state-changes, that it is also a property of the
> > domain itself in addition to the device.
> 
> You could, but from a hardware perspective, the clock is a property of
> the device.
> 
> > And on the pratical side we don't have drivers nor bindings for a big part
> > of the domain users - and this will probably be true for quite some time.
> > This of course makes it very impractical (or impossible) to collect the
> > clocks for parts like the gpu (mali), hevc, vcodec (video
> > encoder/decoder), rga (2d stuff), iep, isp.
> 
> This doesn't sound impossible at all.
> 
> You have to collect the clocks anyways.  The only debate is whether to
> list them in the device node or the power-domain node.
> 
> Even for devices without drivers, you just need a minimal node in the DT if
> which lists the clocks and has a phandle to the parent power domain.
> 
> Sounds rather simple to me, and since the DT is supposed to describe the
> hardware, doing it this way makes looking at the DT actually help
> understand the hardware.

