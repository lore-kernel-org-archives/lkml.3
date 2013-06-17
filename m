Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab3FQSxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 14:53:04 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43172 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab3FQSxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 14:53:01 -0400
Date: Mon, 17 Jun 2013 19:52:23 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        alsa-devel@alsa-project.org, Kukjin Kim <kgene.kim@samsung.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Padmavathi Venna <padma.v@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: Re: [RFC PATCH 03/11] dma: amba-pl08x: Add support for different
	offset of CONFIG register
Message-ID: <20130617185223.GO2718@n2100.arm.linux.org.uk>
References: <1371416058-22047-1-git-send-email-tomasz.figa@gmail.com> <1371416058-22047-4-git-send-email-tomasz.figa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371416058-22047-4-git-send-email-tomasz.figa@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 16, 2013 at 10:54:10PM +0200, Tomasz Figa wrote:
> Some variants of PL08x (namely PL080S, found in Samsung S3C64xx SoCs)
> have CONFIG register at different offset. This patch makes the driver
> use offset from vendor data struct.

I'd suggest doing this a different way.  Instead of having to pass around
two pointers everywhere in order to access this register, add to
struct pl08x_phy_chan a void __iomem *reg_config; member, and initialize
that to base + vd->config_offset.  Then use ch->reg_cfg instead of
ch->base + PL080_CH_CONFIG.

This has the benefit that you won't have to modify a whole load of
functions to pass another argument, which costs not only an additional
register, but also storage to keep it around.
