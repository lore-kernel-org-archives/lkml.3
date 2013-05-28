Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244Ab3E1Ksv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 06:48:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756363Ab3E1Ksu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 06:48:50 -0400
Date: Tue, 28 May 2013 06:48:40 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        "Trond Myklebust" <Trond.Myklebust@netapp.com>
Subject: Re: [54/94] sunrpc: clarify comments on rpc_make_runnable
Message-ID: <20130528064840.43a9bb43@corrin.poochiereds.net>
In-Reply-To: <87ehcrqtdn.fsf@canonical.com>
References: <lsq.1369712992.755341692@decadent.org.uk>
	<lsq.1369712993.690390643@decadent.org.uk>
	<20130528061435.0e1b1cc4@corrin.poochiereds.net>
	<87ehcrqtdn.fsf@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 May 2013 11:41:08 +0100
Luis Henriques <luis.henriques@canonical.com> wrote:

> Jeff Layton <jlayton@redhat.com> writes:
> 
> > On Tue, 28 May 2013 04:49:53 +0100
> > Ben Hutchings <ben@decadent.org.uk> wrote:
> >
> >> 3.2.46-rc1 review patch.  If anyone has any objections, please let me know.
> >> 
> >> ------------------
> >> 
> >> From: Jeff Layton <jlayton@redhat.com>
> >> 
> >> commit 506026c3ec270e18402f0c9d33fee37482c23861 upstream.
> >> 
> >> rpc_make_runnable is not generally called with the queue lock held, unless
> >> it's waking up a task that has been sitting on a waitqueue. This is safe
> >> when the task has not entered the FSM yet, but the comments don't really
> >> spell this out.
> >> 
> >> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> >> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> >> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> >> ---
> >>  net/sunrpc/sched.c |    5 +++--
> >>  1 file changed, 3 insertions(+), 2 deletions(-)
> >> 
> >> --- a/net/sunrpc/sched.c
> >> +++ b/net/sunrpc/sched.c
> >> @@ -296,8 +296,9 @@ EXPORT_SYMBOL_GPL(__rpc_wait_for_complet
> >>  /*
> >>   * Make an RPC task runnable.
> >>   *
> >> - * Note: If the task is ASYNC, this must be called with
> >> - * the spinlock held to protect the wait queue operation.
> >> + * Note: If the task is ASYNC, and is being made runnable after sitting on an
> >> + * rpc_wait_queue, this must be called with the queue spinlock held to protect
> >> + * the wait queue operation.
> >>   */
> >>  static void rpc_make_runnable(struct rpc_task *task)
> >>  {
> >> 
> >
> > Just a comment patch, so this is harmless and I have no objection but
> > why pull it into stable? I had always thought stable-kernel-rules.txt
> > discouraged taking patches that don't fix real bugs...
> 
> I believe the reason Ben took this patch is actually to provide the
> correct context for the next one:
> 
> a3c3cac5d31879cd9ae2de7874dc6544ca704aec, "SUNRPC: Prevent an rpc_task wakeup race"
> 
> So that this is a clean cherry-pick.
> 
> (At least this was the reason I picked it for the 3.5 kernel.)
> 
> Cheers,

Ok, that's understandable -- sorry for the noise...

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>
