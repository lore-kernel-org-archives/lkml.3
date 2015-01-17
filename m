Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbbAQAqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 19:46:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:7530 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309AbbAQAqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 19:46:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="441596010"
User-Agent: Microsoft-MacOutlook/14.4.6.141106
Date: Fri, 16 Jan 2015 16:46:39 -0800
Subject: Re: futex(2) man page update help request
From: Darren Hart <dvhart@linux.intel.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: "Carlos O'Donell" <carlos@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>,
        Torvald Riegel <triegel@redhat.com>,
        Roland McGrath <roland@redhat.com>, Darren Hart <dvhart@infradead.org>,
        Anton Blanchard <anton@samba.org>, Petr Baudis <pasky@suse.cz>,
        Eric Dumazet <edumazet@google.com>,
        bill o gallmeister <bgallmeister@gmail.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Daniel Wagner <wagi@monom.org>,
        Rich Felker <dalias@libc.org>
Message-ID: <D0DEECA2.B7EAD%dvhart@linux.intel.com>
Thread-Topic: futex(2) man page update help request
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
 <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>
 <5373D0CA.2050204@redhat.com>
 <alpine.DEB.2.02.1405150121230.6261@ionos.tec.linutronix.de>
 <CAKgNAkjQ5Dd_U9OojXdgeforpRevvPHNFAw99kBFPCwHgf7Ggg@mail.gmail.com>
 <alpine.DEB.2.02.1405151144390.6261@ionos.tec.linutronix.de>
 <54B7D87C.3090901@gmail.com>
 <alpine.DEB.2.11.1501152313330.5526@nanos>
 <54B92B71.2090509@gmail.com>
 <alpine.DEB.2.11.1501161618080.5526@nanos>
 <54B97A72.2050205@gmail.com>
In-Reply-To: <54B97A72.2050205@gmail.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





On 1/16/15, 12:54 PM, "Michael Kerrisk (man-pages)"
<mtk.manpages@gmail.com> wrote:

>On 01/16/2015 04:20 PM, Thomas Gleixner wrote:
>> On Fri, 16 Jan 2015, Michael Kerrisk (man-pages) wrote:
>> 
>>> Hello Thomas,
>>>
>>> On 01/15/2015 11:23 PM, Thomas Gleixner wrote:
>>>> On Thu, 15 Jan 2015, Michael Kerrisk (man-pages) wrote:
>>>>>> [EINVAL] uaddr equal uaddr2. Requeue to same futex.
>>>>>
>>>>> ??? I added this, but does this error not occur only for PI requeues?
>>>>
>>>> It's equally wrong for normal futexes. And its actually the same code
>>>> checking for this for all variants.
>>>
>>> I don't understand "equally wrong" in your reply, I'm sorry. Do you
>>> mean:
>>>
>>> a) This error text should be there for both normal and PI requeues
>> 
>> It is there for both. The requeue code has that check independent of
>> the requeue type (normal/pi). It never makes sense to requeue
>> something to itself whether normal or pi futex. We added this for PI,
>> because there it is harmful, but we did not special case it. So normal
>> futexes get the same treatment.
>
>Hello Thomas, 
>
>Color me stupid, but I can't see this in futex_requeue(). Where is that
>check that is "independent of the requeue type (normal/pi)"?
>
>When I look through futex_requeue(), all the likely looking sources
>of EINVAL are governed by a check on the 'requeue_pi' argument.


Right, in the non-PI case, I believe there are valid use cases: move to
the back of the FIFO, for example (OK, maybe the only example?). Both
tests ensuring uaddr1 != uaddr2 are under the requeue_pi conditional
block. The second compares the keys in case they are not FUTEX_PRIVATE
(uaddrs would be different, but still the same backing store).

Thomas, am I missing a test for this someplace else?


-- 
Darren Hart
Intel Open Source Technology Center



