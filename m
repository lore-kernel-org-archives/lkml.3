Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbaIWLq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 07:46:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971AbaIWLqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 07:46:24 -0400
Message-ID: <54215D52.8030201@redhat.com>
Date: Tue, 23 Sep 2014 07:45:22 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] signal: simplify deadlock-avoidance in lock_task_sighand()
References: <20140922164404.GA28910@redhat.com>	<20140922164437.GA28939@redhat.com>	<20140922145828.4d06108a@gandalf.local.home>	<20140922191130.GA4527@redhat.com> <20140922172405.71c4a110@gandalf.local.home>
In-Reply-To: <20140922172405.71c4a110@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 09/22/2014 05:24 PM, Steven Rostedt wrote:
> On Mon, 22 Sep 2014 21:11:30 +0200 Oleg Nesterov <oleg@redhat.com>
> wrote:

>> so this patch doesn't try to change the rules.
>> 
>> But perhaps we can simply remove this preempt_disable/enable?
>> 
>> Or. We can shift rcu_read_unlock() from lock_task_sighand() to 
>> unlock_task_sighand(). This way we can avoid preempt_disable too,
>> but I'd prefer to not do this.
> 
> I really thing the preempt_disable/enable is not needed.
> 
> Paul, Thomas, care to comment?

I suspect you are right.  On normal kernels, rcu_read_lock() will
ensure preemption is disabled.

On -rt, the locks within are all sleepable mutexes.

Either way, things should be ok.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUIV1SAAoJEM553pKExN6DXroIAIFFNLb1tDCHZCmW5q/so0U9
sd0MLhN/oRx9+tZuZw7RfIglTDEukMKuFI7lRvoIkH+uZ9ObRVqjGB35CWNVRaWy
wzEyjIPO9OboHTCygBdxmLgC6I9Lg3qFQP2tuwLyEeWJMFylWuDDBtHCmVnbq78G
AvUxyz9z+XuFSHLumD+DYMLkYSpMhzzCSSQ7uiOEYP+LA3a2DJuFgNxBvZWQAIu4
j7uWcWLlv3TJYkK7iTudJyXl4DqyhanILh5pHLXIv3w2I0tAycpPv73QH64Qog6S
3R5BoIrfFvfgldx1YaB26lk6jvg3jgi61fSaUx6ZoaMGBM+QBfxiNdI4G7Yn/8k=
=EKgM
-----END PGP SIGNATURE-----
