Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbaBXTkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:40:33 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:34519 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbaBXTkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:40:31 -0500
Date: Mon, 24 Feb 2014 20:39:39 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: phy: add suspend_halted module param
Message-ID: <20140224193939.GD29288@lunn.ch>
References: <1393174719-20806-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20140224191554.GC29288@lunn.ch>
 <CAGVrzcaOSMQWJ69KHJ7TH0_BN9D-O4uoL=fLWDoE=xFdV4RJ4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGVrzcaOSMQWJ69KHJ7TH0_BN9D-O4uoL=fLWDoE=xFdV4RJ4w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 11:37:15AM -0800, Florian Fainelli wrote:
> 2014-02-24 11:15 GMT-08:00 Andrew Lunn <andrew@lunn.ch>:
> > On Sun, Feb 23, 2014 at 05:58:39PM +0100, Sebastian Hesselbarth wrote:
> >> commit 1211ce53077164e0d34641d0ca5fb4d4a7574498
> >>   ("net: phy: resume/suspend PHYs on attach/detach")
> >> introduced a feature to suspend PHYs when entering halted state.
> >>
> >> Unfortunately, not all bootloaders properly power-up PHYs on reset
> >> and fail to access ethernet because the PHY is still powered down.
> >>
> >> Therefore, we add a boolean module parameter suspend_halted with
> >> default value of true. Disabling that parameter prevents PHYs from
> >> being suspended when entering halted state.
> >
> > Hi Sebastian
> >
> > Am i doing something silly here?
> 
> Could the PHY be already suspended during your initial boot?

No. I tftpboot.

> If that
> is the case, the first time we all phy_suspend() the flag is true, we
> suspend it, and we never wake it again despite changing
> suspend_halted. Does it work better if you specify this module
> parameter on the initial kernel boot command-line?

I tried that as well, after i emailed. Makes no difference, no working
Ethernet.

	Andrew
