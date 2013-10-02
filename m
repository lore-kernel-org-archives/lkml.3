Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab3JBDwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 23:52:16 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:42421 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab3JBDwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 23:52:12 -0400
Date: Tue, 1 Oct 2013 20:52:09 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ming Liu <ming.liu@windriver.com>
cc: akpm@linux-foundation.org, mhocko@suse.cz, rusty@rustcorp.com.au,
        hannes@cmpxchg.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1] oom: avoid selecting threads sharing mm with init
In-Reply-To: <5244E7BA.4040408@windriver.com>
Message-ID: <alpine.DEB.2.02.1310012048170.10383@chino.kir.corp.google.com>
References: <1380182957-3231-1-git-send-email-ming.liu@windriver.com> <alpine.DEB.2.02.1309261143160.10904@chino.kir.corp.google.com> <5244E7BA.4040408@windriver.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Sep 2013, Ming Liu wrote:

> I might mislead you, when I talked about init, I meant the pid 1 process but
> not the idle, and isn't the idle a kthread and has not this risk getting
> killed by oom?

You can disqualify for p->mm == &init_mm, but the oom killer has been 
rewritten since 2.6.27 so please post a log from a recent kernel that 
exhibits the problem.
