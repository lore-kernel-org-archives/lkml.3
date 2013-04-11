Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab3DKUKD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:10:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:54883 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab3DKUKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:10:01 -0400
Message-ID: <51671878.9050800@infradead.org>
Date: Thu, 11 Apr 2013 13:09:28 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu,
        Borislav Petkov <bp@alien8.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Kevin Hilman <khilman@linaro.org>, Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH documentation 2/2] kthread: Document ways of reducing
 OS jitter due to per-CPU kthreads
References: <20130411160524.GA30384@linux.vnet.ibm.com> <1365696359-30958-1-git-send-email-paulmck@linux.vnet.ibm.com> <1365696359-30958-2-git-send-email-paulmck@linux.vnet.ibm.com> <5166F062.2090007@infradead.org> <20130411184053.GN29861@linux.vnet.ibm.com>
In-Reply-To: <20130411184053.GN29861@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/13 11:40, Paul E. McKenney wrote:
> On Thu, Apr 11, 2013 at 10:18:26AM -0700, Randy Dunlap wrote:
>> On 04/11/2013 09:05 AM, Paul E. McKenney wrote:
>>> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>>>
>>> The Linux kernel uses a number of per-CPU kthreads, any of which might
>>> contribute to OS jitter at any time.  The usual approach to normal
>>> kthreads, namely to affinity them to a "housekeeping" CPU, does not
>>
>> ugh.               to affine them
> 
> How about s/affinity/bind/ instead?

Yes, that's good.

>>> work with these kthreads because they cannot operate correctly if moved
>>> to some other CPU.  This commit therefore lists ways of controlling OS
>>> jitter from the Linux kernel's per-CPU kthreads.
>>>
>>> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>>> Cc: Steven Rostedt <rostedt@goodmis.org>
>>> Cc: Borislav Petkov <bp@alien8.de>
>>> Cc: Arjan van de Ven <arjan@linux.intel.com>
>>> Cc: Kevin Hilman <khilman@linaro.org>
>>> Cc: Christoph Lameter <cl@linux.com>
>>> ---
>>>  Documentation/kernel-per-CPU-kthreads.txt | 159 ++++++++++++++++++++++++++++++
>>>  1 file changed, 159 insertions(+)
>>>  create mode 100644 Documentation/kernel-per-CPU-kthreads.txt
>>>
>>> diff --git a/Documentation/kernel-per-CPU-kthreads.txt b/Documentation/kernel-per-CPU-kthreads.txt
>>> new file mode 100644
>>> index 0000000..495dacf
>>> --- /dev/null
>>> +++ b/Documentation/kernel-per-CPU-kthreads.txt
>>> @@ -0,0 +1,159 @@
>>> +REDUCING OS JITTER DUE TO PER-CPU KTHREADS
>>> +
>>> +
>>> +Name: irq/%d-%s
>>> +Purpose: Handle threaded interrupts.
>>> +To reduce corresponding OS jitter, do the following:
>>> +1.	Use irq affinity to force the irq threads to execute on
>>> +	some other CPU.
>>
>> It would be very nice to explain here how that is done.
> 
> Documentation/IRQ-affinity.txt
> 
> I added a pointer to this near the beginning.
> 

Good.

> Thank you for your review and comments!  Given my rationale above,
> are you still comfortable with my applying your Reviewed-by?

Sure.  Thanks.

>> Reviewed-by: Randy Dunlap <rdunlap@infradead.org>


-- 
~Randy
