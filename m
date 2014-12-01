Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbaLAS2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 13:28:11 -0500
Received: from mta-out1.inet.fi ([62.71.2.195]:56765 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbaLAS2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 13:28:10 -0500
Date: Mon, 1 Dec 2014 20:25:19 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Will Deacon <will.deacon@arm.com>, Tejun Heo <tj@kernel.org>,
        Dave Jones <davej@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Don Zickus <dzickus@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141201182519.GA16749@node.dhcp.inet.fi>
References: <20141119021902.GA14216@redhat.com>
 <CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
 <20141119145902.GA13387@redhat.com>
 <546D0530.8040800@mit.edu>
 <20141120152509.GA5412@redhat.com>
 <20141125122217.GA15280@arm.com>
 <20141201114854.GB18466@arm.com>
 <CA+55aFyhB5LBVadA5TfuX8+TrZZWTHwT-2NCYRLat8Fp6eBjgw@mail.gmail.com>
 <20141201171036.GH18466@arm.com>
 <CA+55aFwooh31=GMVUoriev+t92=roye_ck+czqr48M1sQ3UOMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwooh31=GMVUoriev+t92=roye_ck+czqr48M1sQ3UOMg@mail.gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 09:53:16AM -0800, Linus Torvalds wrote:
> On Mon, Dec 1, 2014 at 9:10 AM, Will Deacon <will.deacon@arm.com> wrote:
> >
> > So I don't even have binfmt-misc compiled in. The two handlers I have are
> > BINFMT_ELF and BINFMT_SCRIPT, but they both check for headers that we won't
> > get back from oom_score afaict.
> 
> Hmm. So I can't even get that "oom_score" file to be executable in the
> first place, which should mean that execve() should terminate very
> quickly with an EACCES error.

No idea about oom_score, but kernel happily accepts chmod on any file
under /proc/PID/net/. It caused issues before[1].

Why do we allow this?

I've asked before, but no answer so far.


[1] https://lkml.org/lkml/2014/8/2/103

-- 
 Kirill A. Shutemov
