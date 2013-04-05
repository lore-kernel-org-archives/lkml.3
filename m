Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161769Ab3DENVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 09:21:41 -0400
Received: from shelob.surriel.com ([74.92.59.67]:46380 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161152Ab3DENVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 09:21:40 -0400
Message-ID: <515ECFD0.4090202@surriel.com>
Date: Fri, 05 Apr 2013 09:21:20 -0400
From: Rik van Riel <riel@surriel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: Sasha Levin <sasha.levin@oracle.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hhuang@redhat.com, jason.low2@hp.com,
        walken@google.com, lwoodman@redhat.com, chegu_vinod@hp.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH -mm -next] ipc,sem: untangle RCU locking with find_alloc_undo
References: <1363809337-29718-1-git-send-email-riel@surriel.com>  <5151DBD3.6080201@oracle.com>  <1364320297.5146.7.camel@buesod1.americas.hpqcorp.net>  <5151E3D2.1070103@oracle.com>  <20130326160059.7b466a8d@annuminas.surriel.com> <1365136697.4579.12.camel@marge.simpson.net>
In-Reply-To: <1365136697.4579.12.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2013 12:38 AM, Mike Galbraith wrote:
> On Tue, 2013-03-26 at 16:00 -0400, Rik van Riel wrote:

>> The ipc semaphore code has a nasty RCU locking tangle, with both
>> find_alloc_undo and semtimedop taking the rcu_read_lock(). The
>> code can be cleaned up somewhat by only taking the rcu_read_lock
>> once.
>>
>> There are no other callers to find_alloc_undo.
>>
>> This should also solve the trinity issue reported by Sasha Levin.
>
> I take it this is on top of the patchlet Sasha submitted?

Indeed, and all the other fixes that got submitted :)

> (I hit rcu stall banging on patch set in rt with 60 synchronized core
> executive model if I let it run long enough, fwtw)

What are you using to trigger an rcu stall?

>> Reported-by: Sasha Levin <sasha.levin@oracle.com>
>> Signed-off-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
