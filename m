Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965083Ab3GLOV3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 10:21:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47820 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964919Ab3GLOV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 10:21:27 -0400
Date: Fri, 12 Jul 2013 16:21:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Ming Lei <tom.leiming@gmail.com>, Linda Walsh <lkml@tlinx.org>,
        Linux-Kernel <linux-kernel@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org
Subject: Re: BUG: key ffff880c1148c478 not in .data! (V3.10.0)
Message-ID: <20130712142106.GJ24008@pd.tnic>
References: <51D9EAF3.4050804@tlinx.org>
 <CACVXFVPRwakzB6vtqRqL49StHKdugCpxDyNvx3VzcDC7GggFMQ@mail.gmail.com>
 <20130712080428.GB359@x4>
 <20130712134115.GI24008@pd.tnic>
 <51E00B55.5070003@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51E00B55.5070003@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 10:57:41AM -0300, Mauro Carvalho Chehab wrote:
> This will be overriding the content of the static var mc_bus every for
> every new memory controller. Are you sure that bus.name is only used
> on register, or if its contents is stored somewhere?

bus_register does kobject_set_name which copies bus->name, for example,
but I didn't look exhaustively.

Just to be on the safe side, I should probably do a

static const char **bus_names = { "mc0", "mc1", ..., "mc7" };

and use it. Are 8 enough for your edac drivers too?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
