Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933523Ab3LIM5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 07:57:07 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:33461 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933192Ab3LIM5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 07:57:02 -0500
MIME-Version: 1.0
In-Reply-To: <52A11220.8080509@wwwdotorg.org>
References: <1384881351-10782-1-git-send-email-t.figa@samsung.com>
	<528BB1F2.4080107@wwwdotorg.org>
	<CAD=FV=XS0dbE7zfgDGVdp84h4fHH6tfO8aN_HNh1LbOjYy51aQ@mail.gmail.com>
	<528BB913.6080409@wwwdotorg.org>
	<CAH9JG2UjnL5bZzNUuJhWY3GpwPD=rJvR2O4Hcpm33G+prSS=BA@mail.gmail.com>
	<CACRpkdbyjm0X9RX+8WjqQxBPyRjBOAunkqVcO-0KUd1PTdGavA@mail.gmail.com>
	<5293ACA6.7060403@bracey.fi>
	<CACRpkdYrPd9tnO48bA_5n+-k=KEDyhY7czkCNhTZfpgF3ar+LQ@mail.gmail.com>
	<52A11220.8080509@wwwdotorg.org>
Date: Mon, 9 Dec 2013 13:57:00 +0100
Message-ID: <CACRpkdbDxNkb9XnVnfVWK9HEKj1mb+VUawh1GMe1bggQVg88KA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: samsung: Allow pin value to be initialized using pinfunc.
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Kevin Bracey <kevin@bracey.fi>, Kyungmin Park <kmpark@infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Tomasz Figa <t.figa@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 6, 2013 at 12:54 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 12/03/2013 02:29 AM, Linus Walleij wrote:

(skipped the conversation on weak hogs, we are on the same page
here, just waiting for someone to start working on it ...)

> Related, I prefer to put /all/ static pinctrl configuration into the
> pinctrl device's "default" state (i.e. use a hog) rather than
> configuring the static pinctrl setup per device, for another reason too:
>
> If a particular IO controller's signals can be routed to n different
> (sets of) pins, then we need to do *both* of the following when setting
> up the pinmux:
>
> a) Configure the pins we want to host those signals to route to/from
> that particular IO controller.
>
> b) Configure any other pins that could route to/from that particular IO
> controller as some other function; either disabled, or routed to/from
> some different IO controller.
>
> That is so that the IO controller's RX/input signals are not connected
> from two different sets of pins at once, which would cause two things to
> driver them. Depending on HW, this could cause on of:
>
> 1) Multiple drivers -> high power usage, or even Silicon damage.
>
> 2) Inconsistent configuration, with the "wrong" set of pins driving the
> IO controller's inputs, and hence the signals on the "correct" pins
> being ignored -> hard to find bug.

I'm following, I think what we need here is to think about additional
behaviours and electronic constraints we can encode into the drivers
and/or the pin tables to safeguard pin states from electronically
unsound states.

That is to say, I prefer the subsystem to be conscious about the
electronic constraints and navigate around them or put up a road
block, rather than trying ti avoid driving into the roadblocks by means
of carefully crafted tables if you get the picture ...

Yours,
Linus Walleij
