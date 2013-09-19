Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab3ISSP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 14:15:59 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39043 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752519Ab3ISSP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 14:15:58 -0400
X-Sasl-enc: 4cTanB/JeBdDGmbjmjiztpq6gq/98szv073NssDiHx2T 1379614557
Date: Thu, 19 Sep 2013 15:15:54 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: Jacob Shin <jacob.shin@amd.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Issues with AMD microcode updates
Message-ID: <20130919181554.GA10055@khazad-dum.debian.net>
References: <20130919145834.GA4298@khazad-dum.debian.net>
 <20130919164409.GA9427@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130919164409.GA9427@pd.tnic>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Sep 2013, Borislav Petkov wrote:
> On Thu, Sep 19, 2013 at 11:58:34AM -0300, Henrique de Moraes Holschuh wrote:
> > I take care of the amd64 microcode update support for Debian, and I'm
> > receiving user reports of lockup issues with the AMD microcode driver in
> > several kernels.  This is about the runtime update interface,
> > /sys/devices/system/cpu/*/microcode/reload and
> > /sys/devices/system/cpu/microcode/reload.
> > 
> > Basically, the issue is that the process that tries to write "1" to the
> > reload node gets stuck in "D" state on several kernel versions.
> > 
> > I started by blacklisting several older kernels (e.g. I got a report of
> > 2.6.38 locking up), but recently I got a report of a lockup with kernel
> > 3.5.1.  Blacklisting everything before 3.10 is not exactly kosher, not when

The kernels reproted to be broken are 2.6.38 and 3.5.2, I got the last one
wrong.

> > I would have to blindly trust 3.0, 3.2 and 3.4 to not have whatever issue is
> > causing the lockups.

...

> > Debian bug reports:
> > http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=717185
> > http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=723081
> 
> Well, both Andreas and Jacob don't work for AMD anymore. I could try to
> help with this but it'll be slow as I'm pretty busy with other stuff.

Well, if someone can give me suitable ssh and full root access to a small
AMD box anywhere in the world [with a suitably outdated BIOS/EFI that
doesn't have the latest microcode for the processor] so that I can bissect
this, I'm game.  Preferably, a box with a throw-away install of the latest
Debian stable, which might help track down the issue faster since it is what
I am most confortable with.

> Anyway, I'd suggest we look only on the long term kernels since they're
> the only ones which can get updates/fixes anyway.

If I could get a confirmation that "it's good on latest 3.0, 3.2, 3.4, 3.10
and mainline", I'd at least be able to blacklist everything else.  But I'd
need at least a control test of 3.5.2 (which should fail) to make sure it is
easy to reproduce the bug on the test box...

I'm almost sure that the latest 3.2 and 3.10+ work just fine, otherwise I'd
have noticed it really fast...

> Now, how do I reproduce this? Writing 1 to .../reload on latest kernel
> works here. So I'd need a reproducer. Alternatively, I'd need a sysrq-l
> and sysrq-w from those systems with hung processes.

I can request help on debian-user or debian-devel to get someone with an AMD
box to help with bissection, but it is usually best if we don't ask general
users to bissect kernels (due to non-zero risk of data corruption if the
bissect hit one of the problem spots that often show up during the
development window).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
