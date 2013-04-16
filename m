Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934832Ab3DPMik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 08:38:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64045 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934444Ab3DPMii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 08:38:38 -0400
Message-ID: <1366115870.4784.23.camel@marge.simpson.net>
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
Date: Tue, 16 Apr 2013 14:37:50 +0200
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
X-Provags-ID: V02:K0:nUOpyzVcWAfA2bWQlVkFcTEKH9wXdHFSPOtgBawziOx
 bhfBu4UTnUgQABC9Ay3Iwk6GGFtXBfUGzgSrlhvXZk7y4T0xYE
 sk3Br+XMRBbfSn07Y7khAiJbjknWCMol/XigwRNQe99MztEbFQ
 ISbJTwmMbOjGESbGYJhUD7K3cBYJdYMdvZioMDiJQS2j6IhyoD
 GJk3iESncyQNjm0ACuEE0N/Sw57S07wzsnGR3LXp8If7F+Fhdq
 mP8QPIuoLOQTL/eCexeUkqwJM+UfaB1QKs/q117UWMny9gv4mv
 5BNjEUoOLhYvlJqmrh83npVmRDdQXEAUvs5N+7ww5IEXjqTnVo
 iZeeFvBKo7dFhI9oR5uIr7JccOmdKqpCdLKwB/e3lDkTHzfvGJ
 gguM2F03AR+CQ==
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

I plugged it into my 64 core rt box and beat on it again, no stalls or
any other troubles noted.

-Mike

