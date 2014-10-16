Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbaJPLS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 07:18:56 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49927 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbaJPLSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 07:18:55 -0400
Date: Thu, 16 Oct 2014 13:18:58 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>
Subject: Re: [RFC 1/5] x86: Clean up cr4 manipulation
Message-ID: <20141016111858.GB25025@nazgul.tnic>
References: <cover.1413323611.git.luto@amacapital.net>
 <724658a527c0572dde1a400a5e90b85f45421201.1413323611.git.luto@amacapital.net>
 <20141016081633.GG7369@worktop.fdxtended.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141016081633.GG7369@worktop.fdxtended.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 10:16:33AM +0200, Peter Zijlstra wrote:
> On Tue, Oct 14, 2014 at 03:57:35PM -0700, Andy Lutomirski wrote:
> > +/* Set in this cpu's CR4. */
> > +static inline void cr4_set(unsigned long mask)
> > +{
> > +	unsigned long cr4;
> > +
> > +	cr4 = read_cr4();
> > +	cr4 |= mask;
> > +	write_cr4(cr4);
> > +}
> > +
> > +/* Clear in this cpu's CR4. */
> > +static inline void cr4_clear(unsigned long mask)
> > +{
> > +	unsigned long cr4;
> > +
> > +	cr4 = read_cr4();
> > +	cr4 &= ~mask;
> > +	write_cr4(cr4);
> > +}
> 
> I would have called these cr4_or() and cr4_nand(). When first reading
> this I expected cr4_set() to be a pure write_cr4() and cr4_clear() to do
> write_cr4(0) -- which obviously doesn't make too much sense.
> 
> 
> cr4_{set,clear}_mask() might maybe be clearer but is more typing, and
> the logical ops as suggested should have unambiguous meaning.

Or maybe ...{set,clear}_bits() because we're setting/clearing a mask of
a bunch of bits...

-- 
Regards/Gruss,
    Boris.
--
