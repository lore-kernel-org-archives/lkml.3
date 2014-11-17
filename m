Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaKQUtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 15:49:50 -0500
Received: from www.sr71.net ([198.145.64.142]:37013 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbaKQUtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 15:49:49 -0500
Message-ID: <546A5F6A.7070704@sr71.net>
Date: Mon, 17 Nov 2014 12:49:46 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: linux-kernel@vger.kernel.org, dave.hansen@linux.intel.com, x86@kernel.org,
        a.p.zijlstra@chello.nl, paulus@samba.org, acme@kernel.org,
        jkenisto@us.ibm.com, srikar@linux.vnet.ibm.com, tglx@linutronix.de,
        ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: Re: [PATCH] x86: remove arbitrary instruction size limit in instruction
 decoder
References: <20141112225352.D49917A8@viggo.jf.intel.com> <5464C4FD.60705@hitachi.com>
In-Reply-To: <5464C4FD.60705@hitachi.com>
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2014 06:49 AM, Masami Hiramatsu wrote:
> (2014/11/13 7:53), Dave Hansen wrote:
>> The kprobes code probably needs to be looked at here a bit more
>> carefully.  This patch still respects the MAX_INSN_SIZE limit
>> there but the kprobes code does look like it might be able to
>> be a bit more strict than it currently is.
> 
> Would you mean kprobes can copy shorter? Maybe, but I think current
> one is enough because it is on a cold path.
> OK, at least this looks good to me.

As it stands now, if you happened to be decoding an instruction which is
short and it was *JUST* before a memory hole, I think it could oops the
kernel.

This doesn't look like it is very common (or maybe even possible) in
practice.

>> Note: the v10 version of the MPX patches I just posted depends
>> on this patch.
> 
> BTW, current insn decoder doesn't support MPX... That should be
> updated (add bnd* to x86-insn-map.txt)

I think they're in there already:

> grep -i bnd arch/x86/lib/x86-opcode-map.txt
1a: BNDCL Ev,Gv | BNDCU Ev,Gv | BNDMOV Gv,Ev | BNDLDX Gv,Ev,Gv
1b: BNDCN Ev,Gv | BNDMOV Ev,Gv | BNDMK Gv,Ev | BNDSTX Ev,GV,Gv

Or were there others you were thinking of?
