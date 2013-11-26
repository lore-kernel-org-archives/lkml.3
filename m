Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab3KZAan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 19:30:43 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:46311 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab3KZAaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 19:30:39 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Kevin Bracey <kevin@bracey.fi>, Linus Walleij <linus.walleij@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kyungmin Park <kmpark@infradead.org>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] pinctrl: samsung: Allow pin value to be initialized using pinfunc.
Date: Tue, 26 Nov 2013 01:30:37 +0100
Message-ID: <2715269.S45Tc0DQGQ@flatron>
User-Agent: KMail/4.11.3 (Linux/3.12.0-gentoo; KDE/4.11.3; x86_64; ; )
In-Reply-To: <5293ACA6.7060403@bracey.fi>
References: <1384881351-10782-1-git-send-email-t.figa@samsung.com> <CACRpkdbyjm0X9RX+8WjqQxBPyRjBOAunkqVcO-0KUd1PTdGavA@mail.gmail.com> <5293ACA6.7060403@bracey.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 of November 2013 22:01:42 Kevin Bracey wrote:
> On 25/11/2013 16:34, Linus Walleij wrote:
> > On Wed, Nov 20, 2013 at 1:02 AM, Kyungmin Park <kmpark@infradead.org> wrote:
> >> On Wed, Nov 20, 2013 at 4:16 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> >>> I think that last point should be addressed by having a driver that owns
> >>> the GPIO set it to the desired output level, and the implementation of
> >> Some pins are not connected (NC). At that cases, there's no drivers to
> >> handle it. To reduce power leakage, it sets proper configuration with
> >> values instead of reset values.
> > This is correspondant to the PIN_CONFIG_OUTPUT from
> > include/linux/pinctrl/pinconf-generic.h
> 
> Indeed it is - I was waiting for someone to point that out. Now we've 
> got there...
> 
> I've been working on extending the shmobile PFC driver to provide 
> "gpio-mode" and implement PIN_CONFIG_OUTPUT as described by 
> Documentation/pinctrl.txt, primarily to handle sleep states, but I have 
> begun to wonder about the initial state problem, as discussed here.
> 
> As far as I can see, we can't currently specify "fallback" states for 
> pins, which is one of Tomasz' key requirements.
> 
> We can specify "hog" states, and we can specify "default for a driver", 
> but not "default before/in absence of a driver" or "sleep in absence of 
> a driver". Having a hog precludes any finer driver control, AFAICT.
> 
> Some of our existing pre-pinconf board files have a "unused pins" table 
> which is used to claim and pull GPIOs. I've converted that to "hog" 
> pinconf, but that only works because the table omits all pins used by 
> drivers. And, unsurprisingly, that's been error-prone; if those tables 
> originally covered all unused pins, they don't any more.
> 
> I'd like confidence that we can get every pin into the correct state by 
> having a fully-populated table containing all pins, that can be used 
> regardless of which drivers start. I think what we're lacking is a "weak 
> hog". Whatever you call that. :)
> 
> That would also specify the state to fallback to when a group is 
> released (where we currently do pinmux_disable_setting).
> 
> Thoughts?

I fully agree with Kevin. We're currently also using "hogs" for this, but
as Kevin mentioned, this is error prone, as it can be used for pins that
are not touched by any drivers.

IMHO a way to specify a default safe state of all pins (with lowest power
consumption, without possibility of glitching external devices, etc.)
would be really useful for Samsung platforms (and probably Renesas ones
as Kevin wrote).

Best regards,
Tomasz

