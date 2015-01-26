Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbbAZRt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:49:28 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:55430 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573AbbAZRtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:49:20 -0500
Date: Mon, 26 Jan 2015 17:48:45 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Doug Anderson <dianders@chromium.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Mark Rutland <mark.rutland@arm.com>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "tgih.jun@samsung.com" <tgih.jun@samsung.com>,
        Chris Ball <chris@printf.net>, Jianqun Xu <xjq@rock-chips.com>,
        chenfen <chenfen@rock-chips.com>, Chris Zhong <zyw@rock-chips.com>,
        lintao <lintao@rock-chips.com>, Jaehoon Chung <jh80.chung@samsung.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Han Jiang <hj@rock-chips.com>, Dinh Nguyen <dinguyen@altera.com>,
        Tao Huang <huangtao@rock-chips.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Addy Ke <addy.ke@rock-chips.com>, Alexandru Stan <amstan@chromium.org>,
        =?utf-8?B?UGF3ZcWC?= Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        =?utf-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        zhangqing <zhangqing@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Sonny Rao <sonnyrao@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lin Huang <hl@rock-chips.com>, Randy Dunlap <rdunlap@infradead.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        "zhenfu.fang" <zhenfu.fang@rock-chips.com>, zyf <zyf@rock-chips.com>
Subject: Re: [PATCH 1/2] mmc: core: use card pointer as the first parameter
 of execute_tuning()
Message-ID: <20150126174845.GJ26493@n2100.arm.linux.org.uk>
References: <1422271175-19445-1-git-send-email-addy.ke@rock-chips.com>
 <1422271175-19445-2-git-send-email-addy.ke@rock-chips.com>
 <CAPDyKFp=5epMggHu0+u_LU7ETujcoeP2xOpB7iD6JF2bs8BnEA@mail.gmail.com>
 <CAD=FV=X9x0gW5TyLi4ERm8nxixQB__Y=5bRAtOax-_w+T33rCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=X9x0gW5TyLi4ERm8nxixQB__Y=5bRAtOax-_w+T33rCg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 09:45:07AM -0800, Doug Anderson wrote:
> Ulf,
> 
> On Mon, Jan 26, 2015 at 7:15 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> > On 26 January 2015 at 12:19, Addy Ke <addy.ke@rock-chips.com> wrote:
> >> We need to take the card pointer in execute_tuning() for mmc_send_status(),
> >
> > mmc_send_status() is an mmc core function, not intended for host's to call.
> >
> >> but mmc->card is NULL in tuning state. So we need change the first parameter
> >> of execute_tuning() to card pointer(struct mmc_card * card).
> >
> > So, why do we need this?
> 
> I asked Addy to post upstream against mmc_send_tuning(), but I guess
> he didn't (he posted against Alex's NAKed patch instead).
> 
> ...when I talked to him about it, Addy was asserting that when tuning
> fails it is important (at least on dw_mmc on rk3288) that we wait for
> the card to stop being busy and that the way to detect was using
> mmc_send_status().
> 
> That would mean that against upstream you'd need to change
> mmc_send_tuning() to take in the card as well (or move the "host->card
> = card" assignment to before UHS init, which seems less desirable?)
> 
> What do you think about that?  Is there a better solution?

That sounds like a generic thing though - in which case, what do the
specs have to say on this, and does the code implement what it says?

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
