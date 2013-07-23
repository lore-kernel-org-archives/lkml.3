Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab3GWIyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:54:04 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38191 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916Ab3GWIyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:54:00 -0400
Date: Tue, 23 Jul 2013 09:53:46 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@vger.kernel.org
Subject: Re: [PATCH v3] ARM: kirkwood: extend the kirkwood i2s driver for
	DT usage
Message-ID: <20130723085346.GQ24642@n2100.arm.linux.org.uk>
References: <20130723104615.3696f1a9@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723104615.3696f1a9@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 10:46:15AM +0200, Jean-Francois Moine wrote:
> The kirkwood i2s driver is used without DT in the Kirkwood machine.
> This patch adds a DT compatible definition for use in other Marvell
> machines as the Armada 88AP510 (Dove).

Yet again, this illustrates why converting to DT causes backwards
steps in drivers: the conversion of devm_clk_get() to of_clk_get()
necessitates a clk_put().

Can someone please provide a devm_of_clk_get() function before we
accept any more patches doing this kind of thing?

The other issue is that kirkwood-dma.c and kirkwood-i2s.c should be
one driver; they're not separate hardware on these platforms, so that
needs fixing before coming up with any kind of DT model for this stuff.
