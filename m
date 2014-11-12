Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbaKLAHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 19:07:17 -0500
Received: from gloria.sntech.de ([95.129.55.99]:44609 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbaKLAHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 19:07:15 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Kevin Hilman <khilman@kernel.org>
Cc: Caesar Wang <caesar.wang@rock-chips.com>, linus.walleij@linaro.org,
        linux-arm-kernel@lists.infradead.org,
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
        cf@rock-chips.com, Jack Dai <jack.dai@rock-chips.com>,
        "jinkun.hong" <jinkun.hong@rock-chips.com>
Subject: Re: [PATCH v10 2/3] power-domain: rockchip: add power doamin driver
Date: Wed, 12 Nov 2014 01:10:28 +0100
Message-ID: <11419951.x8p1Z4vKjh@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <7h7fz1of0m.fsf@deeprootsystems.com>
References: <1415690392-9278-1-git-send-email-caesar.wang@rock-chips.com> <1415690392-9278-3-git-send-email-caesar.wang@rock-chips.com> <7h7fz1of0m.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 11. November 2014, 08:53:13 schrieb Kevin Hilman:
> Caesar Wang <caesar.wang@rock-chips.com> writes:
> > In order to meet high performance and low power requirements, a power
> > management unit is designed or saving power when RK3288 in low power mode.
> > The RK3288 PMU is dedicated for managing the power ot the whole chip.
> > 
> > Signed-off-by: Jack Dai <jack.dai@rock-chips.com>
> > Signed-off-by: jinkun.hong <jinkun.hong@rock-chips.com>
> > Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
> > 
> > ---
> > 
> > Changes in v10:
> >     - this switches over domain infos to use masks instead of recomputing
> >     
> >       them each time and also gets rid of custom domain translator and
> >       uses standard onecell on.
> > 
> > Changes in v9:
> >     - fix v8 changes as follows:
> >     - This reconciles the v2 and v7 code so that we power domain have
> >     
> >       lists of clocks they toggle on and off during power transitions and
> >       independently from power domains clocks we attach clocks to devices
> >       comprising power domain and prepare them so they are turn on and off
> >       by runtime PM.
> 
> I still don't like having lists of clocks in the power-domain DT.
> 
> DT is supposed to describe the hardware, and clocks are properties of
> devices, not power-domains, so the DT description should follow from that.

on the policy side one could argue that if the clock needs to be enabled to 
achieve sucessful domain state-changes, that it is also a property of the 
domain itself in addition to the device.

And on the pratical side we don't have drivers nor bindings for a big part of 
the domain users - and this will probably be true for quite some time. This of 
course makes it very impractical (or impossible) to collect the clocks for 
parts like the gpu (mali), hevc, vcodec (video encoder/decoder), rga (2d 
stuff), iep, isp.


Heiko
