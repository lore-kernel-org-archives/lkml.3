Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab3ISQoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 12:44:16 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51794 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157Ab3ISQoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 12:44:15 -0400
Date: Thu, 19 Sep 2013 18:44:09 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Jacob Shin <jacob.shin@amd.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Issues with AMD microcode updates
Message-ID: <20130919164409.GA9427@pd.tnic>
References: <20130919145834.GA4298@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130919145834.GA4298@khazad-dum.debian.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 11:58:34AM -0300, Henrique de Moraes Holschuh wrote:
> Jacob, Andreas,
> 
> I take care of the amd64 microcode update support for Debian, and I'm
> receiving user reports of lockup issues with the AMD microcode driver in
> several kernels.  This is about the runtime update interface,
> /sys/devices/system/cpu/*/microcode/reload and
> /sys/devices/system/cpu/microcode/reload.
> 
> Basically, the issue is that the process that tries to write "1" to the
> reload node gets stuck in "D" state on several kernel versions.
> 
> I started by blacklisting several older kernels (e.g. I got a report of
> 2.6.38 locking up), but recently I got a report of a lockup with kernel
> 3.5.1.  Blacklisting everything before 3.10 is not exactly kosher, not when
> I would have to blindly trust 3.0, 3.2 and 3.4 to not have whatever issue is
> causing the lockups.
> 
> IMHO that's the point where it becomes interesting to actually track down
> the bug even if it apparently doesn't exist anymore on the more recent
> kernels, and ensure that the stable/long-term kernels have the fix.  That
> would also help distros blacklist microcode update on the broken kernels.
> 
> Unfortunately, I don't own, or have access to, any boxes with an AMD
> processor (let alone one with an AMD processor in need of a microcode
> update) to bissect the problem.
> 
> I'd appreciate if AMD (or anyone with an AMD processor, really) could help
> me track this issue down.
> 
> Debian bug reports:
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=717185
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=723081

Well, both Andreas and Jacob don't work for AMD anymore. I could try to
help with this but it'll be slow as I'm pretty busy with other stuff.

Anyway, I'd suggest we look only on the long term kernels since they're
the only ones which can get updates/fixes anyway.

Now, how do I reproduce this? Writing 1 to .../reload on latest kernel
works here. So I'd need a reproducer. Alternatively, I'd need a sysrq-l
and sysrq-w from those systems with hung processes.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
