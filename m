Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbaBEU6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:58:51 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:32511 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754338AbaBEU6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:58:43 -0500
Date: Wed, 5 Feb 2014 15:58:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: David Rientjes <rientjes@google.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>, akpm@linux-foundation.org,
        penberg@kernel.org, cl@linux.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl
Subject: Re: [PATCH v3] slub: fix false-positive lockdep warning in
 free_partial()
Message-ID: <20140205155840.43d6b4ad@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.02.1402051231250.5616@chino.kir.corp.google.com>
References: <52F1F25F.20402@parallels.com>
	<1391588133-15469-1-git-send-email-vdavydov@parallels.com>
	<20140205195837.GA6857@home.goodmis.org>
	<alpine.DEB.2.02.1402051231250.5616@chino.kir.corp.google.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Feb 2014 12:32:43 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Wed, 5 Feb 2014, Steven Rostedt wrote:

> There's an extremely small overhead of taking this lock, the cache has 
> been destroyed and is the process of being torn down, there will be 
> absolutely no contention on n->list_lock.

But why add it if it isn't necessary? You're even disabling interrupts,
which means that you add to the response latency. That is, this change
does affect other aspects of the kernel!

-- Steve
