Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab3DYJTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 05:19:13 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:61867 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab3DYJTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 05:19:12 -0400
Date: Thu, 25 Apr 2013 10:19:06 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>, Vinod Koul <vinod.koul@intel.com>,
        Per Forlin <per.forlin@stericsson.com>, Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 05/32] dmaengine: ste_dma40: Supply macros to resolve
 'src' and 'dst' directions
Message-ID: <20130425091906.GG4623@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-6-git-send-email-lee.jones@linaro.org>
 <CACRpkdYD21VEHZ2825=e7PnATp-tfrL2rg4rKboG-Fq04U162A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYD21VEHZ2825=e7PnATp-tfrL2rg4rKboG-Fq04U162A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Apr 2013, Linus Walleij wrote:

> On Thu, Apr 18, 2013 at 12:11 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > There are lots of lengthy if() statements located sporadically up and
> > down the driver. This simple macro should make many of them a little
> > simpler to decipher. The remainder have to stay in place, as they
> > detail slightly more specific settings.
> >
> > Cc: Vinod Koul <vinod.koul@intel.com>
> > Cc: Dan Williams <djbw@fb.com>
> > Cc: Per Forlin <per.forlin@stericsson.com>
> > Cc: Rabin Vincent <rabin@rab.in>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> (...)
> 
> > +#define D40_IS_SRC(dir)  ((dir == STEDMA40_PERIPH_TO_MEM) ? true : false)
> 
> And when I reas the code and see D40_IS_SRC, what does that
> mean? That the channel is a source of .. what exactly?
> 
> The older explicit comparison would be more informative.
> 
> > +#define D40_IS_DST(dir) (((dir == STEDMA40_MEM_TO_PERIPH) || \
> > +                         (dir == STEDMA40_MEM_TO_MEM)) ? true : false)
> > +
> 
> The comparison to STEDMA40_MEM_TO_MEM is unintelligible, if I see
> that macro it has a very unintuitive name, since it is not just
> DST but also SRC.
> 
> The latter macro would be named somthing like D40_IS_DST_OR_MEM2MEM
> and then it will not simplify the code very much.
> 
> You need to come up with something different here, this is just making the
> driver harder to understand.
> 
> I think this patch should be just dropped.

Okay.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
