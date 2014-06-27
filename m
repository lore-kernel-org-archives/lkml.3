Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbaF0AzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 20:55:04 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:19705 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751057AbaF0AzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 20:55:03 -0400
Date: Thu, 26 Jun 2014 20:55:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ring-buffer: Race when writing and swapping cpu buffer
 in parallel
Message-ID: <20140626205500.3f8e111c@gandalf.local.home>
In-Reply-To: <20140626095831.667f834f@gandalf.local.home>
References: <1403788958-6751-1-git-send-email-pmladek@suse.cz>
	<20140626095831.667f834f@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014 09:58:31 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> What we can do is force ring_buffer_swap_cpu() to only work for the CPU
> that it is on. As we have snapshot in per_cpu buffers, to make that
> work, we will need to change the per_cpu version of snapshot to do a
> smp_call_function_single() to the CPU that it wants to take a snapshot
> of, and run the swap there.
> 
> To force this, we can remove the cpu parameter from the
> ring_buffer_swap_cpu(). By doing this, we may be able to remove some of
> the CONFIG_RING_BUFFER_ALLOW_SWAP hacks too!
> 
> I'm not going to sacrifice the general performance of the ring buffer
> for a feature that is seldom (if ever) used.

Did you want to do the above, or do you want me to write something up?

-- Steve
