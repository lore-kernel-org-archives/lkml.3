Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaJ0NHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 09:07:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:45965 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbaJ0NHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 09:07:19 -0400
Date: Mon, 27 Oct 2014 14:07:12 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, tglx@linutronix.de, ak@linux.intel.com,
        eranian@google.com, dzickus@redhat.com, jmario@redhat.com,
        acme@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Attempt to cleanup the HSW offcore bits
Message-ID: <20141027130712.GF3337@twins.programming.kicks-ass.net>
References: <20141023105119.173457103@infradead.org>
 <20141027122340.GU12538@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141027122340.GU12538@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 01:23:40PM +0100, Andi Kleen wrote:
> On Thu, Oct 23, 2014 at 12:51:19PM +0200, Peter Zijlstra wrote:
> > So Don asked about offcore and because I forgot I looked at the code and found
> > the terrible mess Andi created with the HSW/BDW bits.
> > 
> > This series attempts to clean some of that up but seeing how it was all magic
> > numbers 
> 
> All the bits are documented. The actual definitions are available
> in the JSON offcore definitions at https://download.01.org/perfmon/

Yeah, no. That's not how we write code. Also, there's no actual JSON
offcore file for HSW only some TSV file, and I've no mind to go decode
and reverse engineer that stuff.

Also, semi unreadable files on a weird web location is not
documentation, the SDM is and the SDM does not explain why you didn't
put the PF request bits in the OP_PREFETCH events, nor why you added the
IFETCH bits to the OP_READ where all the other uarchs didn't.

Nor does it explain why you set bits 7,9 in OP_READ even though they're
listed as 'reserved'.

It also doesn't explain why you don't program a Supplier Info for
RESULT_ACCESS.

Nor why you set 0x78 in bits 23:30, which even for SNB are still listed
as reserved, even though its official offcore events have that set to
0xFF for all remote events.

And lacking SDM you should have explained all that in your Changelog,
but that's also entirely devoid of any usable information.

> > and no reasons provided for the differences with existing uarchs this
> > might just break things horribly.
> > That said, if this does break things, fixes will have to explain things, so
> > that's good.
> 
> I trust you won't submit or merge untested patches.

You trust wrong.. I should never have merged your patches, but seeing
they're in it needed cleaning up.

I can revert your patches if you'd rather have that?
