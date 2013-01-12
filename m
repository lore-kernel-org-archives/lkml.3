Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab3ALNgU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 08:36:20 -0500
Received: from 4.mo2.mail-out.ovh.net ([87.98.172.75]:43583 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753232Ab3ALNgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 08:36:19 -0500
Date: Sat, 12 Jan 2013 14:34:50 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Olof Johansson <olof@lixom.net>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, voice.shen@atmel.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-sound@vger.kernel.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH 0/2 v2] at91/ssc: fixes on ASoC tree for 3.8
Message-ID: <20130112133450.GF7360@game.jcrosoft.org>
References: <cover.1357912706.git.nicolas.ferre@atmel.com>
 <CAOesGMhhSkrvP7X=y8qmdMKKXZ694+1+ZXY3y6HK1E85qaN5sQ@mail.gmail.com>
 <20130111193948.GA8677@opensource.wolfsonmicro.com>
 <20130111195331.GA2533@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130111195331.GA2533@quad.lixom.net>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 7410673188751977263
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehledrhedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehledrhedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:53 Fri 11 Jan     , Olof Johansson wrote:
> On Fri, Jan 11, 2013 at 07:39:49PM +0000, Mark Brown wrote:
> > On Fri, Jan 11, 2013 at 10:52:19AM -0800, Olof Johansson wrote:
> > > On Fri, Jan 11, 2013 at 6:08 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> > > 
> > > > This material was designed to enter Mark's fixes queue, but as discussed with
> > > > Olof, we can imagine merging everything through arm-soc or split the series (of
> > > > 2 patches) and let them progress upstream separated (option that I do not like
> > > > even if I know that the consequences are not so dramatic).
> > > > So please, Olof, if you feel confortable with this series, tell us what you
> > > > prefer and we will make our best to make this material go forward...
> > 
> > > You're setting yourself up for awkward merges. The driver change is
> > > strongly dependent on the device tree change by failing probe unless
> > > the device tree update is there, while before this patch, it still
> > > worked.
> > 
> > This is partly my fault for getting grumpy about adding the bolier plate
> > code without error checking - overall Linus' change to do the get in the
> > core seems like the most sane approach here.
> > 
> > > But to be honest, I don't think this is a fix, it's a feature that you
> > > just didn't include in time for the merge window. I don't really see
> > > them as appropriate 3.8 material at this point.
> > 
> > Jean-Christophe has been most insistent that pinctrl support is now
> > manadatory for all AT91 systems using device tree. 
> 
> That's a noble goal but enforcing it early gives everyone a lot of pain, and
> quite honestly doesn't make sense. During transition it's better to be lenient
> and allow both old and new methods (without breakage), unless it causes
> significant extra churn.
except here we can not as the same ip manage gpio & pinctrl

so no choice we need to do the switch at once

and that's why we wait 1 more release to do the switch so erveryone can play
with it before

Best Regards,
J.
