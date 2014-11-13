Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934298AbaKMUVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 15:21:14 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:56426 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934097AbaKMUUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 15:20:04 -0500
Date: Thu, 13 Nov 2014 12:20:02 -0800 (PST)
X-Google-Original-Date: Thu, 13 Nov 2014 12:20 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Caesar Wang <caesar.wang@rock-chips.com>, linus.walleij@linaro.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "jinkun.hong" <jinkun.hong@rock-chips.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, ZhenFu Fang <fzf@rock-chips.com>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, Eddie Cai <cf@rock-chips.com>,
        Jack Dai <jack.dai@rock-chips.com>
Subject: Re: [PATCH v11 2/3] power-domain: rockchip: add power doamin driver
Message-ID: <2914846.96jvVdAmYN@dtor-glaptop>
User-Agent: KMail/4.13.3 (Linux/3.13.0-39-generic; KDE/4.13.3; x86_64; ; )
In-Reply-To: <CAGS+omCxtvk7VNr7_tJkDCwZpbW-ocFm2VL4ngujxbS5remmVA@mail.gmail.com>
References: <1415829690-20236-1-git-send-email-caesar.wang@rock-chips.com> <1415829690-20236-3-git-send-email-caesar.wang@rock-chips.com> <CAGS+omCxtvk7VNr7_tJkDCwZpbW-ocFm2VL4ngujxbS5remmVA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 14, 2014 03:35:44 AM Daniel Kurtz wrote:
> On Thu, Nov 13, 2014 at 6:01 AM, Caesar Wang <caesar.wang@rock-chips.com> wrote:
> > +
> > +       error = -ENXIO;
> > +
> > +       for_each_available_child_of_node(np, node) {
> > +               error = rockchip_pm_add_one_domain(pmu, node);
> > +               if (error) {
> > +                       dev_err(dev, "failed to handle node %s: %d\n",
> > +                               node->name, error);
> > +                       goto err_out;
> > +               }
> > +       }
> > +
> > +       if (error) {
> > +               dev_dbg(dev, "no power domains defined\n");
> 
> Perhaps dev_err() or dev_warn(), to ensure this message is seen.
> But, not have defined power domains doesn't seem like a fatal error.
> Perhaps just return 0?

As far as the driver concerned it is a fatal error - the driver can't do
anything when no domain is defined.

Thanks.

-- 
Dmitry
