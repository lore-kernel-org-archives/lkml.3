Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbaIYO5D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 10:57:03 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60628 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305AbaIYO5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 10:57:01 -0400
Date: Thu, 25 Sep 2014 16:56:55 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: x86, microcode: BUG: microcode update that changes x86_capability
Message-ID: <20140925145655.GA28201@nazgul.tnic>
References: <20140919112953.GA3256@nazgul.tnic>
 <20140919075415.5149d5f2@as>
 <20140919150042.GC5318@nazgul.tnic>
 <20140919164217.GD17456@khazad-dum.debian.net>
 <20140923200054.GB16467@pd.tnic>
 <20140924145658.GB31678@khazad-dum.debian.net>
 <20140925085158.GF22317@nazgul.tnic>
 <20140925113643.GB10569@khazad-dum.debian.net>
 <20140925121007.GA25334@nazgul.tnic>
 <20140925144025.GA14030@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140925144025.GA14030@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 11:40:25AM -0300, Henrique de Moraes Holschuh wrote:
> At this point, what alternatives are left?

Here's what we could do:

* Install microcode to /lib/firmware/...

* Refuse to update the microcode and tell the user that she needs to reboot.

* Reboot and load the microcode

For that to work though, we'd need to detect the that we're freshly
booting and only then load the microcode (if we're coming in later,
we should refuse because something linking to libpthread might've run
already).

Now, we need to think about how to detect that reliably, if at all
possible.

The other thing we could do is backport early ucode loading...

Hmm, I'm not crazy about both possibilities though, TBH.

-- 
Regards/Gruss,
    Boris.
--
