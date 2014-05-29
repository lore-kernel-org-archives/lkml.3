Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbaE2SjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 14:39:08 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:57938 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754999AbaE2SjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 14:39:06 -0400
Message-ID: <1401388744.25908.16.camel@x220>
Subject: Re: [PATCH] pcmcia: m8xx: remove checks for four macros
From: Paul Bolle <pebolle@tiscali.nl>
To: Scott Wood <scottwood@freescale.com>
Cc: Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-pcmcia@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Thu, 29 May 2014 20:39:04 +0200
In-Reply-To: <1401387624.6603.161.camel@snotra.buserror.net>
References: <1400916970.31526.78.camel@x220>
	 <1401387624.6603.161.camel@snotra.buserror.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 May 2014 18:39:04.0783 (UTC) FILETIME=[447E8DF0:01CF7B6D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-29 at 13:20 -0500, Scott Wood wrote:
> On Sat, 2014-05-24 at 09:36 +0200, Paul Bolle wrote:
> > This driver contains checks for four Kconfig macros. But the related
> > Kconfig symbols have never been part of the tree. Remove these checks
> > and the code they hide.
> > 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > ---
> > Untested.
> > 
> > This has been an issue ever since this driver was added in v2.6.15. Note
> > that there is no header named "*/cpld.h", so setting PRxK can't possibly
> > work.
> > 
> >  drivers/pcmcia/m8xx_pcmcia.c | 75 --------------------------------------------
> >  1 file changed, 75 deletions(-)
> 
> Does anything in this driver still work?  It looks like bitrot from the
> arch/ppc days, that sort of got updated to use the device tree -- but
> even after this patch there are lots of instances of CONFIG symbols
> being used to assert the exact hardware being used, rather than what
> hardware is supported.

I'm not sure I get what you're pointing at. Can you give one example?

> Is anyone actively maintaining/testing this code?

Related observation: doing
    scripts/get_maintainer.pl -f drivers/pcmcia/m8xx_pcmcia.c --no-git-fallback --no-keywords

just gave me
    linux-pcmcia@lists.infradead.org (open list:PCMCIA SUBSYSTEM)
    linux-kernel@vger.kernel.org (open list)

Note that there's no person responsible for PCMCIA. That's why I
included the people (and lists) maintaining PPC8XX and PPC.


Paul Bolle

