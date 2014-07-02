Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417AbaGBRbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 13:31:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624AbaGBRbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 13:31:01 -0400
Message-ID: <53B44182.4090107@redhat.com>
Date: Wed, 02 Jul 2014 13:29:38 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC tip/core/rcu] Parallelize and economize NOCB kthread
 wakeups
References: <20140627142038.GA22942@linux.vnet.ibm.com> <20140702123412.GD19379@twins.programming.kicks-ass.net> <20140702153915.GQ4603@linux.vnet.ibm.com> <20140702160412.GO19379@twins.programming.kicks-ass.net> <20140702170838.GS4603@linux.vnet.ibm.com> <20140702172600.GR19379@twins.programming.kicks-ass.net>
In-Reply-To: <20140702172600.GR19379@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/02/2014 01:26 PM, Peter Zijlstra wrote:
> On Wed, Jul 02, 2014 at 10:08:38AM -0700, Paul E. McKenney wrote:
>> As were others, not that long ago.  Today is the first hint that
>> I got that you feel otherwise.  But it does look like the softirq
>> approach to callback processing needs to stick around for awhile
>> longer.  Nice to hear that softirq is now "sane and normal"
>> again, I guess.  ;-)
> 
> Nah, softirqs are still totally annoying :-)
> 
> So I've lost detail again, but it seems to me that on all CPUs that
> are actually getting ticks, waking tasks to process the RCU state
> is entirely over doing it. Might as well keep processing their RCU
> state from the tick as was previously done.

For CPUs that are not getting ticks (eg. because they are idle),
is it worth waking up anything on that CPU, or would it make more
sense to simply process their RCU callbacks on a different CPU,
if there aren't too many pending?

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTtEGCAAoJEM553pKExN6D7t4IALdymyu0+/SdaXG73dfkzNKd
yJ3WJtJl1TV6JyejV747IRdKYfkuliZJ+99JZHtJ9dWvOoTtw19GqXXXVANlFpNE
8dQ4UTR6gDE1fRHnWKCdi0p8s3JwgZYdyhr0fKq7k09EXs+eJvDUTVVptBwLj36P
oaENzeONv5xkn3LS9cZVQATX1ZjpYiXjFUxblWoi/NJfSIlq81IkPj8ujaZ4f/6Q
6QLqymNbUGnF5n8v5gs8UqsP+fM3phsIJsT5m42hqnS9eKVwcw4T7UZ8UMFie+mC
hzy7vA0ClcdMWOMlRCSRbJMq0lDA0ej8acYpnj4Yz13wY2DIdTYVU38BbUE+iNA=
=Ia0S
-----END PGP SIGNATURE-----
