Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab3IKPfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 11:35:41 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:60180 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab3IKPfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 11:35:37 -0400
Date: Wed, 11 Sep 2013 08:35:31 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>
Subject: Re: [PATCH] drivers: of: fix build break if asm/dma-contiguous.h is
 missing
Message-ID: <20130911153531.GB28449@roeck-us.net>
References: <1378804400-31716-1-git-send-email-m.szyprowski@samsung.com>
 <522F76CF.6080907@gmail.com>
 <52300E5A.7010202@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52300E5A.7010202@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 08:31:54AM +0200, Marek Szyprowski wrote:
> Hello,
> 
> On 9/10/2013 9:45 PM, Rob Herring wrote:
> >On 09/10/2013 04:13 AM, Marek Szyprowski wrote:
> >> It is not needed to include asm/dma-contiguous.h header to compile
> >> reserved memory initialization code, so remove it to avoid build break
> >> on architectures without CMA support.
> >>
> >> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> >
> >Acked-by: Rob Herring <rob.herring@calxeda.com>
> >
> >I can apply this or it can go with other CMA stuff.
> 
> I think it will be best if I push it to Linus asap to fix the build break
> on arm64 and mips, introduced by my pull request. It is really strange that
> I got no report from linux-next about that issue, although this patch was
> there for about 2 weeks.
> 
If you refer to the the kisskb builds, arm64 is not on its build list.
The cavium_octeon build error does show up:
	http://kisskb.ellerman.id.au/kisskb/buildresult/9483218/

The error is also seen in mips:nlm_xlp_defconfig, which is part
of my build set but not on kisskb (just don't ask me why I added it ;).

Guenter

> >Aren't there also some comments from Grant to address as well?
> 
> Right, I'm working on providing an update which will address the issues
> pointed by Grant, but I got sick and had to take some days off. I still
> didn't recover completely, but I hope I will manage to finish them by
> the end of the week.
> 
> Best regards
> -- 
> Marek Szyprowski
> Samsung R&D Institute Poland
> 
> 
> 
