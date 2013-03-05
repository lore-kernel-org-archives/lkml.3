Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523Ab3CEQcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 11:32:18 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:47122 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab3CEQcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 11:32:15 -0500
MIME-Version: 1.0
In-Reply-To: <51361540.3060603@cn.fujitsu.com>
References: <512C7A38.8060906@linux.vnet.ibm.com>
	<CACvQF51RvhM8XNqu3-1OTQ=cZUZ=pAX+_zx0a29+W67N1X+BgQ@mail.gmail.com>
	<512CC509.1050000@linux.vnet.ibm.com>
	<CACvQF50UgiqPpDk3HCmV86zKSf6tPjqr0bZowfPEOJs0g0r0MQ@mail.gmail.com>
	<512D0D67.9010609@linux.vnet.ibm.com>
	<CACvQF53ph2ixdM-otzetjM5cR+2kcZj6sckOp3TnzzA_x-EZ8w@mail.gmail.com>
	<512E7879.20109@linux.vnet.ibm.com>
	<5130E8E2.50206@cn.fujitsu.com>
	<20130301182854.GA3631@redhat.com>
	<CANN689HEW=b5S93J27p+rBX-5m7jkW4FER=eHDCp7OgMaTWLPw@mail.gmail.com>
	<20130302170656.GB29769@redhat.com>
	<51361540.3060603@cn.fujitsu.com>
Date: Tue, 5 Mar 2013 08:32:14 -0800
Message-ID: <CANN689EKsSZpq-oVPL3_y+ReT+vbz5wPbOs8iz8YzS_Wo-FboQ@mail.gmail.com>
Subject: Re: [PATCH] lglock: add read-preference local-global rwlock
From: Michel Lespinasse <walken@google.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Lai Jiangshan <eag0628@gmail.com>, linux-doc@vger.kernel.org,
        peterz@infradead.org, fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, mingo@kernel.org, linux-arch@vger.kernel.org,
        linux@arm.linux.org.uk, xiaoguangrong@linux.vnet.ibm.com,
        wangyun@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        rusty@rustcorp.com.au, rostedt@goodmis.org, rjw@sisk.pl,
        vincent.guittot@linaro.org, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        sbw@mit.edu, tj@kernel.org, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 5, 2013 at 7:54 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> On 03/03/13 01:06, Oleg Nesterov wrote:
>> On 03/02, Michel Lespinasse wrote:
>>>
>>> My version would be slower if it needs to take the
>>> slow path in a reentrant way, but I'm not sure it matters either :)
>>
>> I'd say, this doesn't matter at all, simply because this can only happen
>> if we race with the active writer.
>>
>
> It can also happen when interrupted. (still very rarely)
>
> arch_spin_trylock()
>         ------->interrupted,
>                 __this_cpu_read() returns 0.
>                 arch_spin_trylock() fails
>                 slowpath, any nested will be slowpath too.
>                 ...
>                 ..._read_unlock()
>         <-------interrupt
> __this_cpu_inc()
> ....

Yes (and I think this is actually the most likely way for it to happen).

We do need this to work correctly, but I don't expect we need it to be fast.
(could be wrong, this is only my intuition)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
