Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbaIYQlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:41:35 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60545 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753593AbaIYQld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:41:33 -0400
X-Sasl-enc: x+oU0rmA8dShzRViLwVeKwSzG9p5tTYOujcKwFru4oeL 1411663292
Date: Thu, 25 Sep 2014 13:41:21 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: x86, microcode: BUG: microcode update that changes x86_capability
Message-ID: <20140925164121.GC10814@khazad-dum.debian.net>
References: <20140919164217.GD17456@khazad-dum.debian.net>
 <20140923200054.GB16467@pd.tnic>
 <20140924145658.GB31678@khazad-dum.debian.net>
 <20140925085158.GF22317@nazgul.tnic>
 <20140925113643.GB10569@khazad-dum.debian.net>
 <20140925121007.GA25334@nazgul.tnic>
 <20140925144025.GA14030@khazad-dum.debian.net>
 <20140925145655.GA28201@nazgul.tnic>
 <20140925153006.GB10814@khazad-dum.debian.net>
 <20140925155044.GB28201@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140925155044.GB28201@nazgul.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2014, Borislav Petkov wrote:
> On Thu, Sep 25, 2014 at 12:30:06PM -0300, Henrique de Moraes Holschuh wrote:
> > Userspace can install the microcode only inside the initramfs, if it wants
> > to avoid it being loaded later.  It is not even too difficult to do so.
> 
> Hmm, so in thinking about this more, what we need to do on all kernels
> should be something along those lines (if I'm not missing something,
> that is):
> 
> 
> 	if (early microcode loading support) {
> 		install microcode into initramfs;
> 	}
> 
> 	install microcode into /lib/firmware/...;
> 	tell the user to reboot;
> 
> On the next reboot, everything gets loaded automatically.
> 
> Of course, user needs to make sure that the microcode loader module gets
> loaded during boot. If its built-in, we're fine.

We still need to update x86_capability after a microcode update for the
above to really work in the "install microcode into initramfs" case.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
