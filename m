Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbaH3SxZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 14:53:25 -0400
Received: from gloria.sntech.de ([95.129.55.99]:59779 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbaH3SxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 14:53:24 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Jianqun <jay.xu@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>, perex@perex.cz,
        tiwai@suse.de, yongjun_wei@trendmicro.com.cn,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 0/2] rockchip-i2s: add power setting for I2S controller and fix some critical bugs
Date: Sat, 30 Aug 2014 20:55:12 +0200
Message-ID: <2985541.F8SvxX1thq@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <CAD=FV=XPYkDJ2J3rTHZgKzbH_EMBUmCMwHWjpf1Aagnv_mUqGQ@mail.gmail.com>
References: <1409350027-17604-1-git-send-email-jay.xu@rock-chips.com> <CAD=FV=XPYkDJ2J3rTHZgKzbH_EMBUmCMwHWjpf1Aagnv_mUqGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 29. August 2014, 21:30:43 schrieb Doug Anderson:
> Jianqun,
> 
> On Fri, Aug 29, 2014 at 3:07 PM, Jianqun <jay.xu@rock-chips.com> wrote:
> > Add optional power setting for i2s controller found on rk3066, rk3168 and
> > rk3288 processors from rockchip, should according to hardware design.
> > 
> > Default setting for I2S controller is powered by 3.3V, there needs this
> > patch if it's powered by 1.8V by hardware design.
> > 
> > Jianqun (2):
> >   rockchip-i2s: dt: add grf requested properties to set power of I2S
> >   controller rockchip-i2s: add power setting for I2S controller, also fix
> >   some bugs>  
> >  .../devicetree/bindings/sound/rockchip-i2s.txt     |  6 +-
> >  sound/soc/rockchip/rockchip_i2s.c                  | 93
> >  +++++++++++++--------- sound/soc/rockchip/rockchip_i2s.h                
> >   | 13 +--
> >  3 files changed, 68 insertions(+), 44 deletions(-)
> 
> Did the general solution I posted at
> <https://patchwork.kernel.org/patch/4807821/> not work for you?  ...or
> did you not see that?

Also, I don't think it's a good idea to set the io voltage bit simply from a 
dt setting without looking at the actual regulator voltage ... as a 1.8V 
setting when the regulator supplies 3.3V supposedly is able to damage the 
chip.


