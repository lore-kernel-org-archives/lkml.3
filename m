Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162024Ab3DEQ32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 12:29:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58014 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161989Ab3DEQ31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:29:27 -0400
Message-ID: <1365179211.4530.9.camel@marge.simpson.net>
Subject: Re: [PATCH -mm -next] ipc,sem: untangle RCU locking with
 find_alloc_undo
From: Mike Galbraith <bitbucket@online.de>
To: Rik van Riel <riel@surriel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hhuang@redhat.com, jason.low2@hp.com,
        walken@google.com, lwoodman@redhat.com, chegu_vinod@hp.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Fri, 05 Apr 2013 18:26:51 +0200
In-Reply-To: <515ECFD0.4090202@surriel.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	 <5151DBD3.6080201@oracle.com>
	 <1364320297.5146.7.camel@buesod1.americas.hpqcorp.net>
	 <5151E3D2.1070103@oracle.com>
	 <20130326160059.7b466a8d@annuminas.surriel.com>
	 <1365136697.4579.12.camel@marge.simpson.net> <515ECFD0.4090202@surriel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:i98Wf5Py5zFpBNN4I/xkql89XoZgSikGUJdTGQpPsj+
 CGY+N+pW4ex9FHViEW7Ne5zUwTZdmMzcYXB6htqakCsI1ej8ul
 jczL1mz4deuUVAyJTUGe5VkXH5y9pURiL5KeoShUJU7NpV62ft
 6ZeeJQ5vgrbWdFs7XNDD4yG2tfcNztpz5mQaxPiuZp2qyGjcS3
 7yXXWsDoqJpc0azvcDxGuAiPOVTsmsqp4SsRbpICWg4BhoWfHv
 zJbaJ68nhkCwknkpoAs6+KCgbKioh3Czn4jx8mU0uWTG7ylO4N
 ixmXgThtbBM8DiIzZbiMScNKu/wRHloeEKjXER5pt4k2mOtZX7
 3Wx79BkHRVyOQZc2R4f+HF6gb9oxNiIlqR0YPa++Jls4MgkPVJ
 3/VsmKV5nbt/w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-05 at 09:21 -0400, Rik van Riel wrote: 
> On 04/05/2013 12:38 AM, Mike Galbraith wrote:
> > On Tue, 2013-03-26 at 16:00 -0400, Rik van Riel wrote:
> 
> >> The ipc semaphore code has a nasty RCU locking tangle, with both
> >> find_alloc_undo and semtimedop taking the rcu_read_lock(). The
> >> code can be cleaned up somewhat by only taking the rcu_read_lock
> >> once.
> >>
> >> There are no other callers to find_alloc_undo.
> >>
> >> This should also solve the trinity issue reported by Sasha Levin.
> >
> > I take it this is on top of the patchlet Sasha submitted?
> 
> Indeed, and all the other fixes that got submitted :)
> 
> > (I hit rcu stall banging on patch set in rt with 60 synchronized core
> > executive model if I let it run long enough, fwtw)
> 
> What are you using to trigger an rcu stall?

Running a model of a userspace task scheduler.  That was a fix or so ago
now though.  I'll try the set again on that box.

-Mike

