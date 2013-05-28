Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764Ab3E1KlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 06:41:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56078 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932547Ab3E1KlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 06:41:12 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        "Trond Myklebust" <Trond.Myklebust@netapp.com>
Subject: Re: [54/94] sunrpc: clarify comments on rpc_make_runnable
References: <lsq.1369712992.755341692@decadent.org.uk>
	<lsq.1369712993.690390643@decadent.org.uk>
	<20130528061435.0e1b1cc4@corrin.poochiereds.net>
Date: Tue, 28 May 2013 11:41:08 +0100
In-Reply-To: <20130528061435.0e1b1cc4@corrin.poochiereds.net> (Jeff Layton's
	message of "Tue, 28 May 2013 06:14:35 -0400")
Message-ID: <87ehcrqtdn.fsf@canonical.com>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Layton <jlayton@redhat.com> writes:

> On Tue, 28 May 2013 04:49:53 +0100
> Ben Hutchings <ben@decadent.org.uk> wrote:
>
>> 3.2.46-rc1 review patch.  If anyone has any objections, please let me know.
>> 
>> ------------------
>> 
>> From: Jeff Layton <jlayton@redhat.com>
>> 
>> commit 506026c3ec270e18402f0c9d33fee37482c23861 upstream.
>> 
>> rpc_make_runnable is not generally called with the queue lock held, unless
>> it's waking up a task that has been sitting on a waitqueue. This is safe
>> when the task has not entered the FSM yet, but the comments don't really
>> spell this out.
>> 
>> Signed-off-by: Jeff Layton <jlayton@redhat.com>
>> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
>> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
>> ---
>>  net/sunrpc/sched.c |    5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>> 
>> --- a/net/sunrpc/sched.c
>> +++ b/net/sunrpc/sched.c
>> @@ -296,8 +296,9 @@ EXPORT_SYMBOL_GPL(__rpc_wait_for_complet
>>  /*
>>   * Make an RPC task runnable.
>>   *
>> - * Note: If the task is ASYNC, this must be called with
>> - * the spinlock held to protect the wait queue operation.
>> + * Note: If the task is ASYNC, and is being made runnable after sitting on an
>> + * rpc_wait_queue, this must be called with the queue spinlock held to protect
>> + * the wait queue operation.
>>   */
>>  static void rpc_make_runnable(struct rpc_task *task)
>>  {
>> 
>
> Just a comment patch, so this is harmless and I have no objection but
> why pull it into stable? I had always thought stable-kernel-rules.txt
> discouraged taking patches that don't fix real bugs...

I believe the reason Ben took this patch is actually to provide the
correct context for the next one:

a3c3cac5d31879cd9ae2de7874dc6544ca704aec, "SUNRPC: Prevent an rpc_task wakeup race"

So that this is a clean cherry-pick.

(At least this was the reason I picked it for the 3.5 kernel.)

Cheers,
-- 
Luis
