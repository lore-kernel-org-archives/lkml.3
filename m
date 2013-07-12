Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275Ab3GLQOB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 12:14:01 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42216 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932612Ab3GLQN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 12:13:59 -0400
Date: Fri, 12 Jul 2013 13:13:40 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Ming Lei <tom.leiming@gmail.com>, Linda Walsh <lkml@tlinx.org>,
        Linux-Kernel <linux-kernel@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: BUG: key ffff880c1148c478 not in .data! (V3.10.0)
Message-ID: <20130712131340.1a371662.mchehab@infradead.org>
In-Reply-To: <20130712142106.GJ24008@pd.tnic>
References: <51D9EAF3.4050804@tlinx.org>
	<CACVXFVPRwakzB6vtqRqL49StHKdugCpxDyNvx3VzcDC7GggFMQ@mail.gmail.com>
	<20130712080428.GB359@x4>
	<20130712134115.GI24008@pd.tnic>
	<51E00B55.5070003@infradead.org>
	<20130712142106.GJ24008@pd.tnic>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 12 Jul 2013 16:21:06 +0200
Borislav Petkov <bp@alien8.de> escreveu:

> On Fri, Jul 12, 2013 at 10:57:41AM -0300, Mauro Carvalho Chehab wrote:
> > This will be overriding the content of the static var mc_bus every for
> > every new memory controller. Are you sure that bus.name is only used
> > on register, or if its contents is stored somewhere?
> 
> bus_register does kobject_set_name which copies bus->name, for example,

Ok, so, it could be safe.

> but I didn't look exhaustively.

Did you try to remove and reinsert the edac driver a few times, on a
multi-memory controller machine? The bus nodes got created properly?
> 
> Just to be on the safe side, I should probably do a
> 
> static const char **bus_names = { "mc0", "mc1", ..., "mc7" };

You would likely to use an array for the bus_type too, if reusing
the static one is an issue.

> and use it. Are 8 enough for your edac drivers too?

With edac_ghes, I suspect that the worse case, on Intel side, is the
Nehalem/Sandy Bridge/Ivy Bridge EX machines.

Tony,

What would be a reasonable maximum limit for the number of memory
controllers, on a -EX machine?

Cheers,
Mauro
