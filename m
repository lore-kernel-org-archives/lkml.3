Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaIYLhG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 07:37:06 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33903 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750947AbaIYLhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 07:37:04 -0400
X-Sasl-enc: u9NGLRe7A853FWnHK6Pl9KWAY25DZVb1POO9dXo6Spq7 1411645022
Date: Thu, 25 Sep 2014 08:36:45 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: x86, microcode: BUG: microcode update that changes x86_capability
Message-ID: <20140925113643.GB10569@khazad-dum.debian.net>
References: <20140919001311.GB5331@khazad-dum.debian.net>
 <CALCETrVoeqQUXH7g+reu=hUvCJoiy+edHKBqYKPWXPCS3_UtUw@mail.gmail.com>
 <20140919110014.GC29639@khazad-dum.debian.net>
 <20140919112953.GA3256@nazgul.tnic>
 <20140919075415.5149d5f2@as>
 <20140919150042.GC5318@nazgul.tnic>
 <20140919164217.GD17456@khazad-dum.debian.net>
 <20140923200054.GB16467@pd.tnic>
 <20140924145658.GB31678@khazad-dum.debian.net>
 <20140925085158.GF22317@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140925085158.GF22317@nazgul.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2014, Borislav Petkov wrote:
> > But IMHO we still need to detect and do something smart when
> > x86_capability changes due to a microcode update.
> > 
> > And I'd really prefer it to be "update x86_capability, warn the user and
> > carry on" for anything that is not going to crash the kernel.
> 
> The problem is with hiding CPUID bits and userspace using HLE after
> having detected it previously. I think we'll be on the safe side if we

It is safe to apply this particular batch of problematic microcode updades
inside the regular initramfs, as long as you do it as one of the very first
tasks.

This isn't an useless fix, it will allow systems without early initramfs
support to operate correctly after a microcode update.  And kernels 3.0, 3.2
and 3.4 _cannot_ apply early initramfs microcode updates at all, so they
need it.

Besides, we need to detect and scream bloody murder when microcode updates
do something like this anyway, now that the pandora box was opened.  If
we're going to detect it, might as well fix it when it is not something the
kernel uses.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
