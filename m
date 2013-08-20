Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab3HTRP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 13:15:27 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:49124 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751801Ab3HTRPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 13:15:25 -0400
Date: Tue, 20 Aug 2013 18:14:53 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "msalter@redhat.com" <msalter@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64: add screen_info for console support
Message-ID: <20130820171453.GF21383@arm.com>
References: <1376842970.11104.11.camel@t520.redhat.com>
 <20130820133733.GF26129@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820133733.GF26129@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 02:37:33PM +0100, Will Deacon wrote:
> Hi Mark,
> 
> On Sun, Aug 18, 2013 at 05:22:50PM +0100, Mark Salter wrote:
> > The arm64 port doesn't provide a screen_info struct for console support
> > which leads to a build failure with some configurations:
> > 
> >   drivers/video/console/vgacon.c:820: undefined reference to `screen_info'
> > 
> > This patch adds an empty declaration of screen_info to fix the build
> > problem. Some additional runtime code is needed to actually make it
> > useful.
> > 
> > Signed-off-by: Mark Salter <msalter@redhat.com>
> > ---
> >  arch/arm64/kernel/setup.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> > index add6ea6..eb9f93a 100644
> > --- a/arch/arm64/kernel/setup.c
> > +++ b/arch/arm64/kernel/setup.c
> > @@ -64,6 +64,10 @@ static const char *cpu_name;
> >  static const char *machine_name;
> >  phys_addr_t __fdt_pointer __initdata;
> >  
> > +#if defined(CONFIG_VGA_CONSOLE) || defined(CONFIG_DUMMY_CONSOLE)
> > +struct screen_info screen_info;
> > +#endif
> 
> You may be able to do something similar to the proposal for PARPORT here and
> factor out the lengthy "depends on" clause for VGA_CONSOLE instead of adding
> the dummy info.

I was wondering about this but do we need screen_info for DUMMY_CONSOLE
as well?

-- 
Catalin
