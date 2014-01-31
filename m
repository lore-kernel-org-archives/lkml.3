Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbaAaVns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 16:43:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51773 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbaAaVnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 16:43:47 -0500
Date: Fri, 31 Jan 2014 13:43:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michel Lespinasse <walken@google.com>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Salman Qazi <sqazi@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Reverting warning for vmalloc and kmemcheck faults in NMI
Message-Id: <20140131134345.0d63bce0fc19d5fe86541e13@linux-foundation.org>
In-Reply-To: <CANN689FzOonHtEazR6KE+yZzohetwVQKaXHHnNYgC+615JszLw@mail.gmail.com>
References: <CANN689FzOonHtEazR6KE+yZzohetwVQKaXHHnNYgC+615JszLw@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014 19:06:58 -0800 Michel Lespinasse <walken@google.com> wrote:

> Hi,
> 
> Way back in 2010, Frederic added commit
> ebc8827f75954fe315492883eee5cb3f355d547d to warn us about cases where
> faults were incorrectly firing during NMI handling on x86, as the IRET
> from such faults would possibly trigger nested NMIs.
> 
> Later (2012), Salman added commit
> 28696f434fef0efa97534b59986ad33b9c4df7f8 to enable nested NMI
> handling. See http://lwn.net/Articles/484932/
> 
> So, I believe such faults nesting under NMI are not an issue anymore,
> and we could revert ebc8827f75954fe315492883eee5cb3f355d547d ?

Seems logical.

> Background: I'm asking this because at Google we like to dump memory
> regions pointed by registers in our arch_trigger_all_cpu_backtrace
> handler, and this occasionally causes the vmalloc_fault in_nmi()
> warning to fire.
> 

It seems odd that x86 arch_trigger_all_cpu_backtrace() uses NMI - why
didn't it use the regular old IPI?  If a CPU is stuck with interrupts
disable, the NMI watchdog will provide the diagnostic?

