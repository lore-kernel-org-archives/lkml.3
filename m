Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab3FYSew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:34:52 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46446 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab3FYSeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:34:50 -0400
Date: Tue, 25 Jun 2013 19:30:51 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, alsa-devel@alsa-project.org,
        Kukjin Kim <kgene.kim@samsung.com>, Dan Williams <djbw@fb.com>,
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
Subject: Re: [RFC PATCH v2 01/12] dmaengine: PL08x: Refactor
	pl08x_getbytes_chan() to lower indentation
Message-ID: <20130625183050.GA2718@n2100.arm.linux.org.uk>
References: <1371933764-24875-1-git-send-email-tomasz.figa@gmail.com> <1371933764-24875-2-git-send-email-tomasz.figa@gmail.com> <20130625151612.GO23141@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130625151612.GO23141@intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 08:46:12PM +0530, Vinod Koul wrote:
> On Sat, Jun 22, 2013 at 10:42:33PM +0200, Tomasz Figa wrote:
> > -			BUG_ON(clli < llis_bus || clli >= llis_bus +
> > +	llis_va = txd->llis_va;
> > +	llis_bus = txd->llis_bus;
> > +
> > +	BUG_ON(clli < llis_bus || clli >= llis_bus +
> >  				sizeof(struct pl08x_lli) * MAX_NUM_TSFR_LLIS);
> IMO BUG_ON is too much for this. Perhaps returning error and logging error would
> be okay

That should be a separate patch, because that's an unrelated change
to this patch.  As this part is just reformatting this part of the
code, it should contain no actual changes.

There's lots that this driver "should" do differently...
