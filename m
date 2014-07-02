Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbaGBG4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 02:56:11 -0400
Received: from ozlabs.org ([103.22.144.67]:55471 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbaGBG4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 02:56:08 -0400
Message-ID: <1404284165.7254.2.camel@concordia>
Subject: Re: Re: Re: [PATCH v4] [BUGFIX] kprobes: Fix "Failed to find
 blacklist" error on ia64 and ppc64
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
Date: Wed, 02 Jul 2014 16:56:05 +1000
In-Reply-To: <53B3A91D.2040107@hitachi.com>
References: <20140620022307.23075.55858.stgit@kbuild-fedora.novalocal>
	   <53B0D61B.9010104@hitachi.com> <1404128176.7888.1.camel@concordia>
	  <53B21B0E.8010707@hitachi.com> <1404276081.7254.1.camel@concordia>
	 <53B3A91D.2040107@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-02 at 15:39 +0900, Masami Hiramatsu wrote:
> (2014/07/02 13:41), Michael Ellerman wrote:
> > On Tue, 2014-07-01 at 11:21 +0900, Masami Hiramatsu wrote:
> >> (2014/06/30 20:36), Michael Ellerman wrote:
> >>> On Mon, 2014-06-30 at 12:14 +0900, Masami Hiramatsu wrote:
> >>>> Ping? :)
> >>>
> >>> Yeah sorry. I started looking at this and got dragged into another mess.
> >>>
> >>> You seem to have duplicated the functionality of arch_deref_entry_point(),
> >>> which was also added for kprobes, and for the same reason - ie. because some
> >>> arches have strange function pointers. Is there some reason you can't use it?
> >>
> >> Ah, right! Hmm, it seems some more work to update it. but basically, we can do.
> >> BTW, is there any other users who need to access the actual function entry (for
> >> kallsyms case)?
> > 
> > Not that I'm aware of. We have had function descriptors on 64-bit powerpc for
> > ever, so in theory by now we should have already found any cases where we need
> > that sort of wrapper.
> 
> OK, then I'll update this patch to use arch_deref_entry_point(), and add additional
> patch which update to support PPC64 ABIv2.

I've already done the latter:

  https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=2f0143c91d30823f6f6e7d94d7fa818f7ab18a18

cheers


