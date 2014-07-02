Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbaGBElZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 00:41:25 -0400
Received: from ozlabs.org ([103.22.144.67]:60775 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbaGBElX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 00:41:23 -0400
Message-ID: <1404276081.7254.1.camel@concordia>
Subject: Re: Re: [PATCH v4] [BUGFIX] kprobes: Fix "Failed to find blacklist"
 error on ia64 and ppc64
From: Michael Ellerman <mpe@ellerman.id.au>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@gmail.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, linux-ia64@vger.kernel.org,
        sparse@chrisli.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, linux-tip-commits@vger.kernel.org,
        akataria@vmware.com, anil.s.keshavamurthy@intel.com,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Chris Wright <chrisw@sous-sol.org>, yrl.pp-manager.tt@hitachi.com,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, rdunlap@infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, dl9pf@gmx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 02 Jul 2014 14:41:21 +1000
In-Reply-To: <53B21B0E.8010707@hitachi.com>
References: <20140620022307.23075.55858.stgit@kbuild-fedora.novalocal>
	  <53B0D61B.9010104@hitachi.com> <1404128176.7888.1.camel@concordia>
	 <53B21B0E.8010707@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-01 at 11:21 +0900, Masami Hiramatsu wrote:
> (2014/06/30 20:36), Michael Ellerman wrote:
> > On Mon, 2014-06-30 at 12:14 +0900, Masami Hiramatsu wrote:
> >> Ping? :)
> > 
> > Yeah sorry. I started looking at this and got dragged into another mess.
> > 
> > You seem to have duplicated the functionality of arch_deref_entry_point(),
> > which was also added for kprobes, and for the same reason - ie. because some
> > arches have strange function pointers. Is there some reason you can't use it?
> 
> Ah, right! Hmm, it seems some more work to update it. but basically, we can do.
> BTW, is there any other users who need to access the actual function entry (for
> kallsyms case)?

Not that I'm aware of. We have had function descriptors on 64-bit powerpc for
ever, so in theory by now we should have already found any cases where we need
that sort of wrapper.

cheers


