Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309AbaBWPlH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 10:41:07 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:50344 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaBWPlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 10:41:05 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+xsn3j6g9ybw3w5GUxLqldZfveWeoIY7w=
X-DKIM: OpenDKIM Filter v2.0.1 titan 161495313D3
Date: Sun, 23 Feb 2014 10:40:53 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/16] pinctrl: mvebu: restructure resource
 allocation
Message-ID: <20140223154053.GN7862@titan.lakedaemon.net>
References: <1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1393165274-32492-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393165274-32492-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, Sebastian,

On Sun, Feb 23, 2014 at 03:20:58PM +0100, Sebastian Hesselbarth wrote:
...
> Also, in the meantime, pinctrl driver stubs for new Armada 375/38x have
> been posted [4]. Compared to v3, this patch set now also takes care of
> the new pinctrl stubs for Armada 375/38x. Those patches have been provided
> by Thomas Petazzoni and make this patches depend on them. We have no stable
> branch for the Armada 375/38x pinctrl patches but I guess Jason will provide
> one soon.

Linus,

I certainly don't want to assume we can take this, and you've been quiet
on the previous versions of this series.  We have a lot of moving pieces
for getting the Armada 375/380/385 support added to the kernel.  It's a
huge help to us if we can create a topic branch for you with the pinctrl
changes in it.

This allows us to get more testing in before the merge window and
resolve conflicts before they land in arm-soc or mainline.  The
resulting branch can then be sent through your tree or arm-soc,
whichever you prefer.

Would you be okay with that?  We're already doing this for Mike (clk)
and tglx (irqchip) and it works quite well.

...
> The patches are based on 3.14-rc3. They are also available on an *unstable*
> branch at

Sebastian, Is there something you needed in v3.14-rc3 that isn't in
v3.14-rc1?  If so, what exactly do these need?

thx,

Jason.

> https://github.com/shesselba/linux-dove.git unstable/mvebu-pinctrl-v3.14_v4
> 
> They have been tested on Dove and Kirkwood, compile-tested for the others,
> Andrew's Tested-by for the Kirkwood patches still applies, Thomas gave his
> Tested-by for Armada XP on v3.
> 
> [1] http://www.spinics.net/lists/arm-kernel/msg303496.html
> [2] http://lkml.org/lkml/2014/1/27/562
> [3] http://lkml.org/lkml/2014/2/12/427
> [4] http://www.spinics.net/lists/arm-kernel/msg306409.html
> 
> Sebastian Hesselbarth (13):
>   pinctrl: mvebu: count unnamed controls and allocate name buffer
>   pinctrl: mvebu: remove obsolete per-control name buffer allocation
>   pinctrl: mvebu: identify generic controls by name
>   pinctrl: mvebu: remove passing mvebu_mpp_ctrl to callbacks
>   pinctrl: mvebu: add common mpp reg helper to mvebu pinctrl include
>   pinctrl: mvebu: dove: provide generic mpp callbacks
>   pinctrl: mvebu: kirkwood: provide generic mpp callbacks
>   pinctrl: mvebu: armada-370: provide generic mpp callbacks
>   pinctrl: mvebu: armada-xp: provide generic mpp callbacks
>   pinctrl: mvebu: move resource allocation to SoC specific drivers
>   pinctrl: mvebu: remove common get/set functions
>   pinctrl: mvebu: dove: consolidate auto-numbered pmu mpp ranges
>   pinctrl: mvebu: dove: reuse mpp_{set,get} in pmu callbacks
> 
> Thomas Petazzoni (3):
>   pinctrl: mvebu: armada-375: provide generic mpp callbacks
>   pinctrl: mvebu: armada-38x: provide generic mpp callbacks
>   pinctrl: mvebu: remove MPP_REG_CTRL macro
> 
>  drivers/pinctrl/mvebu/pinctrl-armada-370.c |  20 ++++-
>  drivers/pinctrl/mvebu/pinctrl-armada-375.c |  20 ++++-
>  drivers/pinctrl/mvebu/pinctrl-armada-38x.c |  20 ++++-
>  drivers/pinctrl/mvebu/pinctrl-armada-xp.c  |  24 +++++-
>  drivers/pinctrl/mvebu/pinctrl-dove.c       | 133 +++++++++++++----------------
>  drivers/pinctrl/mvebu/pinctrl-kirkwood.c   |  25 +++++-
>  drivers/pinctrl/mvebu/pinctrl-mvebu.c      | 122 +++++++++-----------------
>  drivers/pinctrl/mvebu/pinctrl-mvebu.h      |  55 +++++++-----
>  8 files changed, 231 insertions(+), 188 deletions(-)
> 
> ---
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Gregory Clement <gregory.clement@free-electrons.com>
> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> -- 
> 1.8.5.3
> 
