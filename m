Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab3FQS5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 14:57:00 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43191 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab3FQS47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 14:56:59 -0400
Date: Mon, 17 Jun 2013 19:56:18 +0100
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
Subject: Re: [RFC PATCH 08/11] dmaengine: PL08x: Add cyclic transfer support
Message-ID: <20130617185618.GP2718@n2100.arm.linux.org.uk>
References: <1371416058-22047-1-git-send-email-tomasz.figa@gmail.com> <1371416058-22047-9-git-send-email-tomasz.figa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371416058-22047-9-git-send-email-tomasz.figa@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 16, 2013 at 10:54:15PM +0200, Tomasz Figa wrote:
> @@ -561,9 +564,9 @@ static u32 pl08x_getbytes_chan(struct pl08x_dma_chan *plchan)
>  			bytes += get_bytes_in_cctl(llis_va[index].cctl);
>  
>  		/*
> -		 * A LLI pointer of 0 terminates the LLI list
> ++		 * A LLI pointer going backward terminates the LLI list

Spot the unfixed up merge error...
