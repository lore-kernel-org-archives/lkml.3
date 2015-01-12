Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbbALPNI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:13:08 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:51836 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbbALPNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:13:06 -0500
Message-ID: <54B3E466.2030006@oracle.com>
Date: Mon, 12 Jan 2015 10:12:38 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [RFC 1/4] lockdep: additional lock specific information when
 dumping locks
References: <1421074631-18831-1-git-send-email-sasha.levin@oracle.com> <20150112150633.GD25256@twins.programming.kicks-ass.net>
In-Reply-To: <20150112150633.GD25256@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 10:06 AM, Peter Zijlstra wrote:
> On Mon, Jan 12, 2015 at 09:57:08AM -0500, Sasha Levin wrote:
>> When dumping held locks, it might be useful to get additional lock-specific
>> information about each lock.
>>
>> This is mainly useful to figure out who really holds each lock rather then
>> who's just waiting on it, but it could be extended further or extended to
>> the other lockdep users if required.
> 
> I really don't see the point in this; I would much rather have something
> useful like:
> 
>  http://lwn.net/Articles/579849/

As far as I can tell, they have completely different purposes.

The reason for my patch is simple: I'm fuzzing with hundreds of worker threads
which at some point trigger a complete system lockup for some reason.

When lockdep dumps the list of held locks it shows that pretty much every one
of those threads is holding the lock which caused the lockup, which is incorrect
because it considers locks in the process of getting acquired as "held".

This is my solution to that issue. I wanted to know which one of the threads is
really holding the lock rather than just waiting on it.

Is there a better way to solve that problem?


Thanks,
Sasha
