Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab3HUTY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 15:24:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17615 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab3HUTYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 15:24:55 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Q2XQTs2BGfUA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=n8N6v9TcQfMA:10 a=9JqiQa6tcvzDIpBCPpcA:9 a=CjuIK1q_8ugA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 21 Aug 2013 15:24:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, mhocko@suse.cz, hare@suse.de
Subject: Re: [PATCH 4/4] printk: Use unbound irq work for printing and
 waking
Message-ID: <20130821152453.16b07622@gandalf.local.home>
In-Reply-To: <1377072512-7986-5-git-send-email-jack@suse.cz>
References: <1377072512-7986-1-git-send-email-jack@suse.cz>
	<1377072512-7986-5-git-send-email-jack@suse.cz>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Aug 2013 10:08:32 +0200
Jan Kara <jack@suse.cz> wrote:

> Now when per-cpu printk buffers are gone, there's no need to have printk
> flags or printk irq_work per cpu. Just make printk_pending a single
> variable operated by atomic operations and have single unbound irq work
> doing the waking and printing. This has an advantage that any cpu can do the
> printing / wakeup work thus lowering the latency of printing and better
> distributing the printing work over cpus.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
