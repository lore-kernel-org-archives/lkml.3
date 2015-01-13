Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751127AbbAMFTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 00:19:07 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:29192 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbbAMFTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 00:19:06 -0500
Message-ID: <54B4AAAE.2040907@oracle.com>
Date: Tue, 13 Jan 2015 00:18:38 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [RFC 1/4] lockdep: additional lock specific information when
 dumping locks
References: <1421074631-18831-1-git-send-email-sasha.levin@oracle.com> <20150112150633.GD25256@twins.programming.kicks-ass.net> <54B3E466.2030006@oracle.com> <20150112153747.GE25256@twins.programming.kicks-ass.net> <54B3F0F9.9040202@oracle.com> <20150112162339.GF25256@twins.programming.kicks-ass.net>
In-Reply-To: <20150112162339.GF25256@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 11:23 AM, Peter Zijlstra wrote:
>>> > > Alternatively, make better/more use of lock_acquired() and track the
>>> > > acquire vs acquired information in the held_lock (1 bit) and look at it
>>> > > when printing.
>> > 
>> > We could do that, but then we'd lose the ability to get information out of
>> > locks, what's the benefit of doing that?
> That's mission creep; you never stated that as a goal.
> 
> One of the reasons i'm not particularly keen on it is because it creates
> a circular dependency between lock implementations and lockdep. It also
> creates asymmetry between lock types/capabilty.

Fair enough.

__lock_acquired() which looks up held_lock doesn't happen unless
CONFIG_LOCK_STAT is set, which means that if we want to use this method we'd
need to look up held_lock just for that, which would make that path heavier.

Before I go ahead and implement it, do you find it acceptable?


Thanks,
Sasha
