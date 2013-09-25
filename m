Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab3IYCe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 22:34:58 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:60365 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab3IYCe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 22:34:56 -0400
Date: Tue, 24 Sep 2013 19:34:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ming Liu <ming.liu@windriver.com>
cc: akpm@linux-foundation.org, mhocko@suse.cz, rusty@rustcorp.com.au,
        hannes@cmpxchg.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oom: avoid killing init if it assume the oom killed
 thread's mm
In-Reply-To: <1379929528-19179-1-git-send-email-ming.liu@windriver.com>
Message-ID: <alpine.DEB.2.02.1309241933590.26187@chino.kir.corp.google.com>
References: <1379929528-19179-1-git-send-email-ming.liu@windriver.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Sep 2013, Ming Liu wrote:

> After selecting a task to kill, the oom killer iterates all processes and
> kills all other user threads that share the same mm_struct in different
> thread groups.
> 
> But in some extreme cases, the selected task happens to be a vfork child
> of init process sharing the same mm_struct with it, which causes kernel
> panic on init getting killed. This panic is observed in a busybox shell
> that busybox itself is init, with a kthread keeps consuming memories.
> 

We shouldn't be selecting a process where mm == init_mm in the first 
place, so this wouldn't fix the issue entirely.
