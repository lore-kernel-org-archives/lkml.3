Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbaIYPuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:50:52 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39119 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861AbaIYPuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:50:50 -0400
Date: Thu, 25 Sep 2014 17:50:44 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: x86, microcode: BUG: microcode update that changes x86_capability
Message-ID: <20140925155044.GB28201@nazgul.tnic>
References: <20140919150042.GC5318@nazgul.tnic>
 <20140919164217.GD17456@khazad-dum.debian.net>
 <20140923200054.GB16467@pd.tnic>
 <20140924145658.GB31678@khazad-dum.debian.net>
 <20140925085158.GF22317@nazgul.tnic>
 <20140925113643.GB10569@khazad-dum.debian.net>
 <20140925121007.GA25334@nazgul.tnic>
 <20140925144025.GA14030@khazad-dum.debian.net>
 <20140925145655.GA28201@nazgul.tnic>
 <20140925153006.GB10814@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140925153006.GB10814@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 12:30:06PM -0300, Henrique de Moraes Holschuh wrote:
> Userspace can install the microcode only inside the initramfs, if it wants
> to avoid it being loaded later.  It is not even too difficult to do so.

Hmm, so in thinking about this more, what we need to do on all kernels
should be something along those lines (if I'm not missing something,
that is):


	if (early microcode loading support) {
		install microcode into initramfs;
	}

	install microcode into /lib/firmware/...;
	tell the user to reboot;

On the next reboot, everything gets loaded automatically.

Of course, user needs to make sure that the microcode loader module gets
loaded during boot. If its built-in, we're fine.

-- 
Regards/Gruss,
    Boris.
--
