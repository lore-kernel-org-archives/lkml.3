Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762450Ab3ECNaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 09:30:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17612 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762295Ab3ECNaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 09:30:21 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=O4Sx1LqlDMUA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=IGil-QtXnCsA:10 a=NHpyNkQ_rdBYyQvT5GUA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1367587818.7373.12.camel@gandalf.local.home>
Subject: Re: [PATCH, RFC 14/22] oprofile: always enable IRQ_WORK
From: Steven Rostedt <rostedt@goodmis.org>
To: Robert Richter <rric@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, oprofile-list@lists.sf.net
Date: Fri, 03 May 2013 09:30:18 -0400
In-Reply-To: <20130503115332.GT8356@rric.localhost>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
	 <1367507786-505303-15-git-send-email-arnd@arndb.de>
	 <20130503115332.GT8356@rric.localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-03 at 13:53 +0200, Robert Richter wrote:
> On 02.05.13 17:16:18, Arnd Bergmann wrote:
> > oprofile fails to build if CONFIG_IRQ_WORK is not already enabled,
> > because of the dependency on the RING_BUFFER code that now uses
> > the irq work library.
> > 
> > kernel/built-in.o: In function `ring_buffer_unlock_commit':
> > :(.text+0x5b8f0): undefined reference to `irq_work_queue'
> > kernel/built-in.o: In function `ring_buffer_write':
> > :(.text+0x5bd10): undefined reference to `irq_work_queue'
> 
> Shouldn't this be fixed in the ring_buffer implementation?

Hmm, I thought I had ring buffer select irq work. I must have not have
done that.

> 
> I also do not see, where this comes from. I was successfully compiling
> a kernel with OPROFILE and RING_BUFFER enabled but IRQ_WORK disabled.
> Do you have that config still available?
> 

The ring buffer code can now wake up waiters, and to do so it requires
irq_work. I'll send a patch.

Thanks,

-- Steve



