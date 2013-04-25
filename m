Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514Ab3DYXPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 19:15:11 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:53699 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758244Ab3DYXPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 19:15:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>, Pankaj Dev <pankaj.dev@st.com>
Subject: Re: [PATCH] pinctrl: document the "GPIO mode" pitfall
Date: Fri, 26 Apr 2013 01:15:09 +0200
Message-ID: <1761651.lXztZzrj1S@avalon>
User-Agent: KMail/4.10.2 (Linux/3.7.10-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <CACRpkdag=YTeQH=VjW4fQ+G94REWeURhC=ErJxjmSUuP=pKYbA@mail.gmail.com>
References: <1363345636-2006-1-git-send-email-linus.walleij@stericsson.com> <2408684.1bsjMDDzMu@avalon> <CACRpkdag=YTeQH=VjW4fQ+G94REWeURhC=ErJxjmSUuP=pKYbA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Thursday 25 April 2013 23:39:18 Linus Walleij wrote:
> On Tue, Apr 23, 2013 at 3:33 PM, Laurent Pinchart wrote:
> >> +And your machine configuration may look like this:
> >> +--------------------------------------------------
> >> +
> >> +static unsigned long uart_default_mode[] = {
> >> +    PIN_CONF_PACKED(PIN_CONFIG_DRIVE_PUSH_PULL, 0),
> >> +};
> >> +
> >> +static unsigned long uart_sleep_mode[] = {
> >> +    PIN_CONF_PACKED(PIN_CONFIG_OUTPUT, 0),
> >> +};
> > 
> > I'm having a bit of trouble with PIN_CONFIG_DRIVE_PUSH_PULL and
> > PIN_CONFIG_OUTPUT. Strictly speaking, when configured in output mode, the
> > pin will be in a push-pull configuration.
> 
> For your system or for any system? Open drain, open source are also
> output modes, and none of them are push-pull.

Indeed. I was actually thinking about the opposite, push-pull is output.

> > Could you clarify the exact scope of the two configuration parameters ?
> 
> PIN_CONFIG_OUTPUT is left a bit unspecified, but here the idea was a passive
> drive, like just connecting the pin to VDD or GND without any driver stage
> at all.

Isn't that a driver stage ? :-)

> Maybe I should patch the documentation since we seem to be the only user?
> 
> In the above case (which is derived from the ABx500) I think what is
> happening is that the pin is connected to ground during sleep, without any
> enabled driver stages, which saves a lot of power, since you do not need to
> bias the totempole during sleep in that way.

Right. What is unclear to me is the interaction between OUTPUT and DRIVE_*. 
That's the part I would like to see clarified. Does DRIVE_* imply that the pin 
is driven by the selected function, and OUTPUT imply that the pin is driven to 
a fixed level ? If so, how do you configure the drive type of a pin that will 
be used through the GPIO API ? What about cases where I want to drive the pin 
to a fixed level in a non low-power output mode (for instance because I need 
more current that what the low-power output mode provides) ?

-- 
Regards,

Laurent Pinchart

