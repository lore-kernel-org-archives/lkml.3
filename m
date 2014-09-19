Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbaISPAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:00:53 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39087 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085AbaISPAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:00:51 -0400
Date: Fri, 19 Sep 2014 17:00:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: x86, microcode: BUG: microcode update that changes x86_capability
Message-ID: <20140919150042.GC5318@nazgul.tnic>
References: <20140918135202.GA26038@khazad-dum.debian.net>
 <541B2F33.8000002@amacapital.net>
 <20140918145328.0253f009@as>
 <9c84cde6-3d70-4337-8738-0283d06d8cf0@email.android.com>
 <20140918200659.GA5331@khazad-dum.debian.net>
 <20140919001311.GB5331@khazad-dum.debian.net>
 <CALCETrVoeqQUXH7g+reu=hUvCJoiy+edHKBqYKPWXPCS3_UtUw@mail.gmail.com>
 <20140919110014.GC29639@khazad-dum.debian.net>
 <20140919112953.GA3256@nazgul.tnic>
 <20140919075415.5149d5f2@as>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140919075415.5149d5f2@as>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 07:54:14AM -0500, Chuck Ebbert wrote:
> Assuming we can identify all the affected models and steppings, maybe
> something like this would work:
> 
> 1) Refuse to finish booting if a microcode update that disables TSX
> isn't applied before userspace starts running on those CPUs.

Well, I think when we're booting, we would have already applied the
early microcode, no? Because then it is a non-issue.

> 2) Don't allow a late update if TSX is still enabled on those
> processors.

Yeah, so the use case I have in mind is when a long-running machine
wants to apply microcode and this microcode disables CPUID bits and
instructions. And the machine cannot be rebooted.

I guess in that case we would have to issue a warning only on the
affected processors that a rebooted is mandatory and fail the update...
Maybe something like that.

> (1) could be overridden by a command line option for people who want
> to develop TSX code.

The way I understand it, those people shouldn't apply the microcode
patch at all.

-- 
Regards/Gruss,
    Boris.
--
