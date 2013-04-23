Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab3DWR5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 13:57:03 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53708 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749Ab3DWR5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 13:57:00 -0400
Date: Tue, 23 Apr 2013 13:56:57 -0400 (EDT)
Message-Id: <20130423.135657.824070337983596004.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: David.Laight@aculab.com, mingo@kernel.org, hpa@zytor.com,
        tglx@linutronix.de, tytso@mit.edu, linux-kernel@vger.kernel.org,
        x86@kernel.org, netdev@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: Unsigned widening casts of binary "not" operations..
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFzVcptyMSDpFzE_-npbs-ycS+9z_nknoZm1+bQws1pWnA@mail.gmail.com>
References: <CA+55aFxvpcF7+dyy5d3+JP4Wfv90zPsRVtEhNG9Pky5gWTm_Pg@mail.gmail.com>
	<20130423.133732.2222922370397287096.davem@davemloft.net>
	<CA+55aFzVcptyMSDpFzE_-npbs-ycS+9z_nknoZm1+bQws1pWnA@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 23 Apr 2013 10:57:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 23 Apr 2013 10:52:33 -0700

> On Tue, Apr 23, 2013 at 10:37 AM, David Miller <davem@davemloft.net> wrote:
>>
>> I just want to mention that this is dangerous in different ways, we
>> just recently got a patch in the networking that removed such a cast.
>> The problem is when the cast narrows, f.e.:
>>
>>         ~(u8)0
>>
>> doesn't do what you think it does.  That doesn't evaluate to 0xff.
> 
> Yeah, sparse will get that right, but won't warn about it even with my
> patch. The normal "all arithmetic is done in *at*least* 'int'" will
> always kick any C expression like that up to 'int' before the binary
> not op is done. So in your example, the implicit cast is widening the
> value *before* the binary not, not after.

If you're not bored, and could add a check for that kind of narrowing
situation, I'd really appreciate it.
