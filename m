Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbaCJL6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 07:58:35 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:43218 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752193AbaCJL6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 07:58:33 -0400
Date: Mon, 10 Mar 2014 11:58:18 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Mark Brown <broonie@kernel.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the arm-soc tree
Message-ID: <20140310115817.GA10240@arm.com>
References: <20140309115514.GY28112@sirena.org.uk>
 <20140310104558.GB8830@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140310104558.GB8830@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 10:45:58AM +0000, Will Deacon wrote:
> On Sun, Mar 09, 2014 at 11:55:14AM +0000, Mark Brown wrote:
> > Hi all,
> 
> Hi Mark,
> 
> > After merging the arm-soc tree, today's linux-next build (20140309)
> > failed for arm64 defconfig like this:
> > 
> > /home/broonie/next/next/drivers/irqchip/irq-gic.c: In function 'gic_raise_softirq':
> > /home/broonie/next/next/drivers/irqchip/irq-gic.c:666:2: error: implicit declaration of function 'dmb' [-Werror=implicit-function-declaration]
> >   dmb(ishst);
> >   ^
> 
> Damnit, that's because we ended up going with dmb instead of dsb after it
> (surprisingly) turned out to be sufficient. The simple patch below fixes the
> problem -- Catalin, can we get this into -next please?

Done.

-- 
Catalin
