Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332AbaLEQA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 11:00:26 -0500
Received: from ns.horizon.com ([71.41.210.147]:14611 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750907AbaLEQAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 11:00:23 -0500
Date: 5 Dec 2014 11:00:20 -0500
Message-ID: <20141205160020.5785.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: borntraeger@de.ibm.com, linux@horizon.com
Subject: Re: [PATCH 1/9] kernel: Provide READ_ONCE and ASSIGN_ONCE
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org
In-Reply-To: <548178A2.9050409@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Minor style nit: is it necessary to name a non-pointer variable "p"?
>> I expect typeof(p) to be a pointer type.

> v might be better.

The current ACCESS_ONCE uses x.  I also considered "var" and "mem".

>> (The other fun style question, which is a lot less minor, is whether
>> ASSIGN_ONCE should be (src,dst) as above, or (dst,src) like = and
>> <string.h>.)

> I tend to prefer dst, src, but Linus used src, dst in his proposal -
> so I used that.

The question is, does Linus actually care (hey, Linus, do you?), or was
that just a thoughtless part of a discussion about semantics?

Because if you prefer it too, there are arguments...
There are plenty of "store" operations with (src, dst) arguments,
because the focus is on the value being stored, so it comes first.

But the name "assign" almost always refers to the ":=" operation,
with the focus more on the destination.

(Now you have me thinking about German grammar and how the destination
can be identified by the dative "dem".  But even though German depends
on word order less than English, normally the dative comes first.)
