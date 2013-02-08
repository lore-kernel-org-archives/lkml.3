Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759895Ab3BHDsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 22:48:37 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:51085 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759703Ab3BHDsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 22:48:35 -0500
MIME-Version: 1.0
In-Reply-To: <20130208004023.GM2545@linux.vnet.ibm.com>
References: <1358896415-28569-1-git-send-email-walken@google.com>
	<1358896415-28569-2-git-send-email-walken@google.com>
	<20130207223434.GG2545@linux.vnet.ibm.com>
	<1360277809.28557.60.camel@edumazet-glaptop>
	<CANN689G0N0ynSMVcH9CbOFgL_mLSswOBx5yBzPBag0AO9fk8+A@mail.gmail.com>
	<1360281834.28557.73.camel@edumazet-glaptop>
	<20130208004023.GM2545@linux.vnet.ibm.com>
Date: Thu, 7 Feb 2013 19:48:33 -0800
Message-ID: <CANN689EUBav=9LkC0s4+teQirGhymgvRxaHRcnK7brjwDU28FQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/6] kernel: implement queue spinlock API
From: Michel Lespinasse <walken@google.com>
To: paulmck@linux.vnet.ibm.com
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 4:40 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Thu, Feb 07, 2013 at 04:03:54PM -0800, Eric Dumazet wrote:
>> It adds yet another memory write to store the node pointer in the
>> lock...
>>
>> I suspect it's going to increase false sharing.
>
> On the other hand, compared to straight MCS, it reduces the need to
> pass the node address around.  Furthermore, the node pointer is likely
> to be in the same cache line as the lock word itself, and finally
> some architectures can do a double-pointer store.
>
> Of course, it might well be slower, but it seems like it is worth
> giving it a try.

Right. Another nice point about this approach is that there needs to
be only one node per spinning CPU, so the node pointers (both tail and
next) might be replaced with CPU identifiers, which would bring the
spinlock size down to the same as with the ticket spinlock (which in
turns makes it that much more likely that we'll have atomic stores of
that size).

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
