Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509AbaJPL3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 07:29:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49663 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbaJPL3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 07:29:08 -0400
Date: Thu, 16 Oct 2014 13:29:10 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>
Subject: Re: [RFC 1/5] x86: Clean up cr4 manipulation
Message-ID: <20141016112910.GC25025@nazgul.tnic>
References: <cover.1413323611.git.luto@amacapital.net>
 <724658a527c0572dde1a400a5e90b85f45421201.1413323611.git.luto@amacapital.net>
 <20141016081633.GG7369@worktop.fdxtended.com>
 <20141016111858.GB25025@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141016111858.GB25025@nazgul.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 01:18:58PM +0200, Borislav Petkov wrote:
> On Thu, Oct 16, 2014 at 10:16:33AM +0200, Peter Zijlstra wrote:
> > On Tue, Oct 14, 2014 at 03:57:35PM -0700, Andy Lutomirski wrote:
> > > +/* Set in this cpu's CR4. */
> > > +static inline void cr4_set(unsigned long mask)
> > > +{
> > > +	unsigned long cr4;
> > > +
> > > +	cr4 = read_cr4();
> > > +	cr4 |= mask;
> > > +	write_cr4(cr4);
> > > +}
> > > +
> > > +/* Clear in this cpu's CR4. */
> > > +static inline void cr4_clear(unsigned long mask)
> > > +{
> > > +	unsigned long cr4;
> > > +
> > > +	cr4 = read_cr4();
> > > +	cr4 &= ~mask;
> > > +	write_cr4(cr4);
> > > +}

Btw, on a related note, we probably should check whether the bits we
want to set/clear are already set/cleared and then save us the CR4
write.

It probably won't be the case all that much but still...

-- 
Regards/Gruss,
    Boris.
--
