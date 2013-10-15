Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab3JOJEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 05:04:23 -0400
Received: from intranet.asianux.com ([58.214.24.6]:31903 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab3JOJEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 05:04:22 -0400
X-Spam-Score: -100.8
Message-ID: <525D04D4.2070909@asianux.com>
Date: Tue, 15 Oct 2013 17:03:16 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: josh@freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] kernel/rcutorture.c: about using scnprintf() instead
 of sprintf().
References: <5253C335.5050609@asianux.com> <20131013110518.GC5790@linux.vnet.ibm.com> <525B4BB0.1090609@asianux.com> <525B555C.3040102@asianux.com> <20131014112457.GN5790@linux.vnet.ibm.com> <525C9D18.6040909@asianux.com> <20131015083112.GH5790@linux.vnet.ibm.com>
In-Reply-To: <20131015083112.GH5790@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 04:31 PM, Paul E. McKenney wrote:
> On Tue, Oct 15, 2013 at 09:40:40AM +0800, Chen Gang wrote:
>> > Hmm... Can it really work on 1024 CPUs? sorry I don't know. But in fact,
>> > that is not about this patch (it is just one of case which may cause
>> > issues).
>> > 
>> > This patch is only about "use truncation instead of memory overflow, and
>> > make sure the modification without negative effect". So in my opinion,
>> > current test case is enough for this requirement.
> Yes, the patch is about "use truncation instead of memory overflow",
> but the truncation would also be a problem on large systems.  Is it
> possible to prevent memory from overflow in the first place?
> 

Yes of cause it can, but in my opinion, for a test module, truncating
information is acceptable, but memory overflow is not acceptable.

In fact, every information truncation case, can be "prevented memory
from overflow in the first place".  It depends on whether we have enough
interest to do that.


>> > We have to face the efficiency: it is only a test module, if the tester
>> > (assume he/she is a programmer, too) notices about the truncation, they
>> > can simply extend the maximize length to avoid truncation.
> True.  But you can make a change that is just as simple that allows you
> to test what would happen on a 1024-CPU system even though your own
> system has only 2 CPUs.  Can you see what that change is?

In fact, from modifying code, we can virtual most of cases, if current
test case is enough, we need not do that (leave it for guys who have
real 1024-CPUs).


Thanks.
-- 
Chen Gang
