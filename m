Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab3HMGDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:03:10 -0400
Received: from mailout-12.websupport.sk ([37.9.172.141]:45086 "EHLO
	mailout-12.websupport.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab3HMGDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:03:08 -0400
X-Greylist: delayed 358 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Aug 2013 02:03:07 EDT
Message-ID: <1376373421.2828.19.camel@das>
Subject: Re: [PCMCIA] Solved: No USB 2.0 (ehci) in PCMCIA slot on E7110
From: Tomas Kovacik <nail@nodomain.sk>
To: Andreas Mohr <andi@lisas.de>
Cc: Thomas Richter <richter@rus.uni-stuttgart.de>,
        Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        Josep Lladonosa <jlladono@gmail.com>, dahinds@users.sourceforge.net,
        linux-pcmcia@lists.infradead.org
Date: Tue, 13 Aug 2013 07:57:01 +0200
In-Reply-To: <20130812212507.GA12254@rhlx01.hs-esslingen.de>
References: <20130812212507.GA12254@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Checked: Checked by ClamAV on lb2.websupport.sk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi everyone, 

i don't have that old laptop anymore, but as you can see in lspci logs,
it was Ali chipset so, it was really old beast :). Anyway if is O2 used
in new computer, maybe it's fixed and wifi card (atheros) with wpa2 will
work. Try it :)

t.

 On Mon, 2013-08-12 at 23:25 +0200, Andreas Mohr wrote:
> Hi,
> 
> that means we're talking this one (have you had a look at Bugzilla #15014?
> Might be useful...):
> 
> commit 35169529093be3bbef70afd3c4125e35cece7e03
> Author: Wolfram Sang <w.sang@pengutronix.de>
> Date:   Sun Jan 10 09:41:24 2010 +0100
> 
>     pcmcia/yenta: add module parameter for O2 speedups
>     
>     O2-bridges can do read prefetch and write burst. However, for some combinations
>     of older bridges and cards, this causes problems, so it is disabled for those
>     bridges. Now, as some users know their setup works with the speedups enabled, a
>     new parameter is introduced to the driver. Now, a user can specifically enable
>     or disable these features, while the default is what we have today: detect the
>     bridge and decide accordingly. Fixes Bugzilla entry 15014.
>     
>     Simplify and unify the printouts, fix a whitespace issue while we are here.
>     
>     Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
>     Tested-by: frodone@gmail.com
>     [linux@dominikbrodowski.net: whitespace fixes]
>     Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
> 
> 
> And my
> 
> git log -p drivers/pcmcia/o2micro.h
> 
> also mentions
> 
> commit 1ff84890b62b20823b3697a6041bbec1b5280cee
> Author: Tomas Kovacik <nail@nodomain.sk>
> Date:   Sun Jul 26 22:04:58 2009 +0200
> 
>     pcmcia: disable prefetch/burst for OZ6933
>     
>     Problems have been reported [1], so disable prefetch/burst, to be on the safe
>     side.
>     
>     [1] http://www.mail-archive.com/linux-pcmcia@lists.infradead.org/msg02048.html
>     
>     Signed-off-by: Tomáš Kováčik <nail@nodomain.sk>
>     Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> 
> 
> A useful idea would be to kindly ask Tomáš Kováčik (CC'd) about details of his system
> (4 years later - but hopefully...), specifically lspci -vv -xxx or some such
> (especially the revision of that controller might be *different*,
> so perhaps only *some* 6933 remained affected, whereas newer ones of that
> possibly more modern chipset ID started to get corrected).
> Or quite likely there's some sufficiently detailed lspci log of that hardware
> out on the internet somewhere...
> 
> 
> Note that there's the comment
> "for some bridges it is at 0x94, for others at 0xD4. it's
>          * ok to write to both registers on all O2 bridges."
> , yet our 6933 support lines were added *later*,
> so there's a faint possibility that the compatibility statement
> actually does not apply to this chipset.
> 
> 
> 
> And of course there remains the question *why* such slow communication
> would then cause such severe USB HC communication trouble.
> There might be some safeguard missing there as well...
> 
> 
> And kudos to the patch submitters for having supplied
> such nicely detailed commit logs!
> (although mentioning the title of URLs probably would have been even better)
> 
> 
> 
> > Note that this is only a 1.7Ghz Pentium-4-M dinosaur.
> 
> That means you really don't want to know which kinds of machines I am using ;)
> (yes, I'm sitting at a CardBus box here, too)
> ((TI CardBus controller))
> 
> 
> Greetings,
> 
> Andreas Mohr (KA/S)


