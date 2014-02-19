Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaBSWAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 17:00:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33545 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbaBSWAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 17:00:22 -0500
Date: Wed, 19 Feb 2014 14:00:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH] Set bounds on what /proc/self/make-it-fail accepts.
Message-Id: <20140219140021.f187b2cdc396dab44e680078@linux-foundation.org>
In-Reply-To: <20140219215505.GA28876@redhat.com>
References: <20140218220606.GA9712@redhat.com>
	<20140219134025.fcd70941e1ec98723a1bd230@linux-foundation.org>
	<20140219215505.GA28876@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Feb 2014 16:55:05 -0500 Dave Jones <davej@redhat.com> wrote:

> On Wed, Feb 19, 2014 at 01:40:25PM -0800, Andrew Morton wrote:
>  
>  > Switching `make_it_fail' to unsigned makes the test simpler but it does
>  > rather muck up the typing in there.  task_struct.make_it_fail is still
>  > an int, we should now use simple_strtoul rather than simple_strtol,
>  > proc_fault_inject_read()'s snprintf() should now use %u, etc.  None of
>  > which actually matters, but still...
>  
> I toyed with the idea of changing task_struct.make_it_fail to unsigned too,
> but only realized I missed that after I'd sent out the diff.

If we're touching the task_struct we could make it a bool.

Or just a single bit(field).  task_struct already has a bunch of
bitfields in it (strangely, they aren't contiguous).  But some locking
would be needed if tasks-other-than-current can modify the bit.

