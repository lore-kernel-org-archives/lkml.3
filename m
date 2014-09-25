Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbaIYIwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:52:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46763 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbaIYIwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:52:03 -0400
Date: Thu, 25 Sep 2014 10:51:58 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: x86, microcode: BUG: microcode update that changes x86_capability
Message-ID: <20140925085158.GF22317@nazgul.tnic>
References: <20140918200659.GA5331@khazad-dum.debian.net>
 <20140919001311.GB5331@khazad-dum.debian.net>
 <CALCETrVoeqQUXH7g+reu=hUvCJoiy+edHKBqYKPWXPCS3_UtUw@mail.gmail.com>
 <20140919110014.GC29639@khazad-dum.debian.net>
 <20140919112953.GA3256@nazgul.tnic>
 <20140919075415.5149d5f2@as>
 <20140919150042.GC5318@nazgul.tnic>
 <20140919164217.GD17456@khazad-dum.debian.net>
 <20140923200054.GB16467@pd.tnic>
 <20140924145658.GB31678@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140924145658.GB31678@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 11:56:58AM -0300, Henrique de Moraes Holschuh wrote:
> I don't know about AMD, but on Intel, the time it takes to update the
> microcode on a core is anything but negligible[1], so the microcode
> version skew window still exists, and it is not small.  It is much smaller
> than it once was, but it is still there.

I think that window is unsafe but yeah, we probably should take your
empirical observation as good enough for now.

> But IMHO we still need to detect and do something smart when
> x86_capability changes due to a microcode update.
> 
> And I'd really prefer it to be "update x86_capability, warn the user and
> carry on" for anything that is not going to crash the kernel.

The problem is with hiding CPUID bits and userspace using HLE after
having detected it previously. I think we'll be on the safe side if we
reboot thus the suggestion to the user that rebooting should be done
ASAP.

-- 
Regards/Gruss,
    Boris.
--
