Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab3IYR5C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 13:57:02 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:40370 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab3IYR5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 13:57:01 -0400
Date: Wed, 25 Sep 2013 10:56:58 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ming Liu <ming.liu@windriver.com>
cc: akpm@linux-foundation.org, mhocko@suse.cz, rusty@rustcorp.com.au,
        hannes@cmpxchg.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oom: avoid killing init if it assume the oom killed
 thread's mm
In-Reply-To: <52427970.8010905@windriver.com>
Message-ID: <alpine.DEB.2.02.1309251056020.17676@chino.kir.corp.google.com>
References: <1379929528-19179-1-git-send-email-ming.liu@windriver.com> <alpine.DEB.2.02.1309241933590.26187@chino.kir.corp.google.com> <52427970.8010905@windriver.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Sep 2013, Ming Liu wrote:

> > We shouldn't be selecting a process where mm == init_mm in the first
> > place, so this wouldn't fix the issue entirely.
> 
> But if we add a control point for "mm == init_mm" in the first place(ie. in
> oom_unkillable_task), that would forbid the processes sharing mm with init to
> be selected, is that reasonable? Actually my fix is just to protect init
> process to be killed for its vfork child being selected and I think it's the
> only place where there is the risk. If my understanding is wrong, pls correct
> me.
> 

We never want to select a process where task->mm == init_mm because if we 
kill it we won't free any memory, regardless of vfork().  The goal of the 
oom killer is solely to free memory, so it always tries to avoid needless 
killing.
