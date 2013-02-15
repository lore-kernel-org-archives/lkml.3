Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab3BOUD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 15:03:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940Ab3BOUD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 15:03:27 -0500
Message-ID: <511E9480.5070202@redhat.com>
Date: Fri, 15 Feb 2013 20:03:12 +0000
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrey Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        criu@openvz.org, linux-api@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ptrace: add ability to retrieve signals without removing
 them from a queue
References: <1360768595-31943-1-git-send-email-avagin@openvz.org> <511E8223.6010506@redhat.com> <20130215194356.GA12413@redhat.com>
In-Reply-To: <20130215194356.GA12413@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to reply to this bit:

On 02/15/2013 07:43 PM, Oleg Nesterov wrote:
>> We'd miss the poke
>> > variant, but that looks like something that could be always be added
>> > later.
> Yes. _POKE_ or _QUEUE_ or _DEQUEUE_, we can add more features if user-
> space wants them.

In general, IMO, I agree with Roland at https://lkml.org/lkml/2002/12/20/84
in that it's good to have setters for completeness, so that you can
change all the state via ptrace that you can read via ptrace.

But I'm not doing any of this work, hence my "could always be
added later" comment instead of actually requesting it.  But if
we had it, we could make e.g., gdb inspect the signal queues,
and then be able to tweak a realtime signal before it is
delivered.

-- 
Pedro Alves
