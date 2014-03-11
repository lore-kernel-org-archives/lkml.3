Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbaCKIhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 04:37:52 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:51239 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbaCKIhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 04:37:48 -0400
Date: Tue, 11 Mar 2014 09:37:44 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Stefani Seibold <stefani@seibold.net>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: [PATCH v2] x86: Remove compat vdso support
Message-ID: <20140311083744.GA27605@gmail.com>
References: <f23ea19270122375e8d2efe0646bbe6101c451b4.1394499629.git.luto@amacapital.net>
 <CA+55aFwaWgb-hCfOf8Y_LA+ZAHpTFYU937XN=7T6SxDAdpPzcg@mail.gmail.com>
 <CALCETrUe0TjzjEo-N2GZkD9DiVbtjretGjTVqiv7U+ZJerWLXQ@mail.gmail.com>
 <CA+55aFydgX7yejyPq0ckuXabEFhjXO960F=L0-+yYNT=U=Madg@mail.gmail.com>
 <CALCETrXd_7K2rc-JPDFtxQWE+ZURzY6qfOLR9DDtjp-nBG1Sgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXd_7K2rc-JPDFtxQWE+ZURzY6qfOLR9DDtjp-nBG1Sgg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Lutomirski <luto@amacapital.net> wrote:

> [...]
> 
> Currently there are three options: sane vDSO, no vDSO, and OpenSuSE 
> 9-compatible vDSO.  The latter is a mess to maintain and breaks ASLR 
> (even for users of modern glibc), and having a vDSO is apparently 
> important enough that people are willing to pay to enhance it.  The 
> default is OpenSuSE 9-compatible vDSO, which is IMO an odd choice.

The 'odd choice' was to not break the ABI by default...

> ISTM the right solution is to make OpenSuSE 9 users turn off the 
> vDSO (which is a performance hit for them, but not a correctness 
> issue) and let everyone else have a simpler kernel that has no ASLR 
> issues.

Could we just remove the option and automagically disable the vdso on 
OpenSuSE-9, without any boot flags? Is the segfault distinctive enough 
to base a disable-vdso quirk on, either to disable the vdso, or to map 
it into the compatibility position on demand?

That would remove most of this complication. Being somewhat slower on 
an old distro with a new kernel is perfectly OK. The question is, can 
this be done easily enough - chances are that it cannot be done.

Thanks,

	Ingo
