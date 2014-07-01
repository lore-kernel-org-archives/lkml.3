Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbaGACVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 22:21:14 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:55763 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaGACVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 22:21:12 -0400
Message-ID: <53B21B0E.8010707@hitachi.com>
Date: Tue, 01 Jul 2014 11:21:02 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>
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
Subject: Re: Re: [PATCH v4] [BUGFIX] kprobes: Fix "Failed to find blacklist"
 error on ia64 and ppc64
References: <20140620022307.23075.55858.stgit@kbuild-fedora.novalocal>  <53B0D61B.9010104@hitachi.com> <1404128176.7888.1.camel@concordia>
In-Reply-To: <1404128176.7888.1.camel@concordia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/06/30 20:36), Michael Ellerman wrote:
> On Mon, 2014-06-30 at 12:14 +0900, Masami Hiramatsu wrote:
>> Ping? :)
> 
> Yeah sorry. I started looking at this and got dragged into another mess.
> 
> You seem to have duplicated the functionality of arch_deref_entry_point(),
> which was also added for kprobes, and for the same reason - ie. because some
> arches have strange function pointers. Is there some reason you can't use it?

Ah, right! Hmm, it seems some more work to update it. but basically, we can do.
BTW, is there any other users who need to access the actual function entry (for
kallsyms case)?

If so, I guess it'd better to merge this version and replace kprobe's local
arch_deref_entry_point() with generic function_entry() macro.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


