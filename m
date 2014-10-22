Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbaJVI0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:26:35 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:58480 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaJVI0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:26:33 -0400
Date: Wed, 22 Oct 2014 10:26:25 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Vojtech Pavlik <vojtech@suse.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] s390 vs. kprobes on ftrace
Message-ID: <20141022082625.GB4090@osiris>
References: <1413880229-4796-1-git-send-email-heiko.carstens@de.ibm.com>
 <20141021195831.GA31587@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141021195831.GA31587@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102208-0009-0000-0000-000001A27F00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 09:58:31PM +0200, Vojtech Pavlik wrote:
> Hello Heiko,
> 
> I can confirm that kGraft works well on top of current mainline with
> this patch added.
> 
> Another reason for a performance impact when kGraft is enabled is that
> kGraft still adds two instructions to the syscall path on s390x, as
> there is no space left for a kgraft TIF in the first eight bits of
> thread info flags. Renumbering the thread info flags such that _TIF_WORK
> occupies the first eight bits and TIF_TRACE the next eight would fix
> that problem: Do you believe it is feasible?

Hi Vojtech,

I think you're talking about the SLES12 kernel? There you can simply move
the TIF_SYSCALL bit to the same byte where your TIF_KGR bit resides.

Upstream is a bit different since the TIF_SYSCALL bit is already gone (got
replaced with an s390 specific "PIF" bit). However the free TIF bit got
already eaten up by uprobes..

However we can think of a better solution for upstream if the combined
solution of kGraft/kpatch is ready to be merged.

