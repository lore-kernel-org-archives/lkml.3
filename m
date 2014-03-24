Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbaCXOj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 10:39:56 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:42251 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752322AbaCXOjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 10:39:55 -0400
Date: Mon, 24 Mar 2014 10:39:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Aaron Tomlin <atomlin@redhat.com>
Cc: mingo@redhat.com, dzickus@redhat.com, jgh@redhat.com, mguzik@redhat.com,
        pzijlstr@redhat.com, peterz@infradead.org, hpa@linux.intel.com,
        riel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] tracing: Add BUG_ON when stack end location is over
 written
Message-ID: <20140324103952.51f4a5c7@gandalf.local.home>
In-Reply-To: <1395669837-30209-1-git-send-email-atomlin@redhat.com>
References: <1395669837-30209-1-git-send-email-atomlin@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2014 14:03:57 +0000
Aaron Tomlin <atomlin@redhat.com> wrote:

> It is difficult to detect a stack overrun when it
> actually occurs.
> 
> We have observed that this type of corruption is often
> silent and can go unnoticed. Once the corrupted region
> is examined, the outcome is undefined and often
> results in sporadic system crashes.
> 
> When the stack tracing feature is enabled, let's check
> for this condition and take appropriate action.
> 
> Note: init_task doesn't get its stack end location
> set to STACK_END_MAGIC.
> 
> Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
> ---

I added this to my 3.15 queue, and if it survives testing, I'll push it
to my for-next branch.

Thanks,

-- Steve
