Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab3HWKiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 06:38:19 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:51004 "EHLO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab3HWKiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 06:38:16 -0400
Message-ID: <52173BBD.3050803@fold.natur.cuni.cz>
Date: Fri, 23 Aug 2013 12:38:53 +0200
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:23.0) Gecko/20100101 Firefox/23.0 SeaMonkey/2.20
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Theodore Tso <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>,
        mingo@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [sched_delayed] sched: RT throttling activated
References: <521722EE.70209@fold.natur.cuni.cz> <20130823100913.GQ31370@twins.programming.kicks-ass.net>
In-Reply-To: <20130823100913.GQ31370@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Peter Zijlstra wrote:
> On Fri, Aug 23, 2013 at 10:53:02AM +0200, Martin Mokrejs wrote:
>> Hi,
>>   I tried to figure out what this message really means. I came to 
>> https://rt.wiki.kernel.org/index.php/Frequently_Asked_Questions
>> but I am still lost. I lack in the FAQ some user-related information.
>> The first paragraph is still unclear to me. I have a i7-2640M based
>> laptop, hyperthreading is enabled by BIOS but I shut down the two
>> emulated cores by (no BIOS option to disable HT):
>>
>> Would you please clarify what the "[sched_delayed] sched: RT throttling activated"
>> really means? 
> 
> It means you have (a) real-time task(s) that consume significant amount

How can I find them? I don't think I need the RT, I have two CPU-bound
processes and want to run them at max speed. Rest of the system is unimportant.

I still don't understand what the $subj message actually says. Does it say
the RT-requiring task was slowed down? I am a bit lost here.

> of time. At some point we throttle them in an attempt to keep the system
> from falling over.

Will I get companion "[sched_delayed] sched: RT throttling deactivated"
at some point?

> 
>> Is that because there is some RT-requiring application on my system?
> 
> Yep.

Which? How can I find them and turn that requirement off (if I understand right they
interrupt my long-living computing processes)?

> 
>> I don't know of any (or don't care about real-time responsiveness except that ALSA
>> drivers require me to have CONFIG_SND_HRTIMER=y). Per Goggle answers could the
>> culprit be nfsd? Then I will recompile is as a module.
> 
> Unlikely, I don't think I've ever seen anybody run their nfsd with RT

Maybe false info in that thread, I don't know:
http://forums.opensuse.org/english/get-technical-help-here/applications/482756-kernel-panic-rt-throttling-activated.html

> priority. Also, you can run RT tasks regardless of the config options.
> SCHED_RR and SCHED_FIFO are POSIX specified and always available.

Are python-based apps requiring the realtime features?


I used to get the messages below which are now gone with my CPU cooler being replaced yesterday:

[ 4172.717272] CPU1: Core temperature above threshold, cpu clock throttled (total events = 153727)
[ 4172.717277] CPU1: Package temperature above threshold, cpu clock throttled (total events = 158008)
[ 4172.717348] CPU0: Package temperature above threshold, cpu clock throttled (total events = 158008)
[ 4172.718291] CPU1: Core temperature/speed normal
[ 4172.718293] CPU1: Package temperature/speed normal
[ 4172.718347] CPU0: Package temperature/speed normal
[ 4205.336883] mce: [Hardware Error]: Machine check events logged
...
[ 8966.052786] CPU1: Core temperature/speed normal
[ 8966.052788] CPU0: Package temperature/speed normal
[ 8966.052791] CPU1: Package temperature/speed normal
[ 9266.421068] CPU1: Core temperature above threshold, cpu clock throttled (total events = 530778)
[ 9266.421070] CPU0: Package temperature above threshold, cpu clock throttled (total events = 547228)
[ 9266.421075] CPU1: Package temperature above threshold, cpu clock throttled (total events = 547228)
[ 9266.422076] CPU1: Core temperature/speed normal
[ 9266.422078] CPU0: Package temperature/speed normal
[ 9266.422081] CPU1: Package temperature/speed normal
[ 9445.150679] [sched_delayed] sched: RT throttling activated
[ 9566.792369] CPU1: Core temperature above threshold, cpu clock throttled (total events = 559429)
[ 9566.792372] CPU0: Package temperature above threshold, cpu clock throttled (total events = 576882)
[ 9566.792378] CPU1: Package temperature above threshold, cpu clock throttled (total events = 576882)
[ 9566.793377] CPU1: Core temperature/speed normal
[ 9566.793380] CPU0: Package temperature/speed normal
[ 9566.793382] CPU1: Package temperature/speed normal
[ 9872.630811] CPU1: Core temperature above threshold, cpu clock throttled (total events = 583223)
[ 9872.630813] CPU0: Package temperature above threshold, cpu clock throttled (total events = 601532)
[ 9872.630817] CPU1: Package temperature above threshold, cpu clock throttled (total events = 601532)
[ 9872.631818] CPU1: Core temperature/speed normal
[ 9872.631820] CPU0: Package temperature/speed normal
[ 9872.631823] CPU1: Package temperature/speed normal

mcelog report in such cases:

Hardware event. This is not a software error.
MCE 0
CPU 1 THERMAL EVENT TSC 1bf82e2a146 
TIME 1375536062 Sat Aug  3 15:21:02 2013
Processor 1 heated above trip temperature. Throttling enabled.
Please check your system cooling. Performance will be impacted
STATUS 880003c3 MCGSTATUS 0
MCGCAP c07 APICID 2 SOCKETID 0 
CPUID Vendor Intel Family 6 Model 42





While my CPU cooler got replaced even now I still get (hence this email thread):

[39564.452795] blah.py[14396]: segfault at 7ff67af34a58 ip 00007ff67badff00 sp 00007fff771ce798 error 4 in libpython2.7.so.1.0[7ff67b9cf000+173000]
[44520.259205] [sched_delayed] sched: RT throttling activated
[48956.057816] blah.py[16623]: segfault at 2f ip 00007fd462e5d046 sp 00007fff638431e0 error 4 in libpython2.7.so.1.0[7fd462d7c000+173000]
[49288.388797] blah.py[28631]: segfault at 7fe254b6aa58 ip 00007fe255715f00 sp 00007fff6ddaaff8 error 4 in libpython2.7.so.1.0[7fe255605000+173000]
[49942.020084] blah.py[6950]: segfault at d0 ip 00007f3e8a9acf9c sp 00007fffa72288a0 error 4 in libpython2.7.so.1.0[7f3e8a904000+173000]
[66696.443342] blah.py[8015]: segfault at cf ip 00007f798f708f9c sp 00007fff420336e0 error 4 in libpython2.7.so.1.0[7f798f660000+173000]
[67561.587383] blah.py[7483]: segfault at 7f7b16e01540 ip 00007f7b17a85f00 sp 00007fffe663d9b8 error 4 in libpython2.7.so.1.0[7f7b17975000+173000]
[77262.490502] blah.py[29107]: segfault at 21e1458 ip 00007fc54cd17f00 sp 00007fff283c5c38 error 4 in libpython2.7.so.1.0[7fc54cc07000+173000]


So, what does this "[sched_delayed] sched: RT throttling activated" tell me?


Thank you for your guidance,
Martin


