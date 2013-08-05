Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab3HEQ7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:59:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54599 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502Ab3HEQ7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:59:32 -0400
Message-ID: <51FFD9D8.3000704@zytor.com>
Date: Mon, 05 Aug 2013 09:59:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Gleb Natapov <gleb@redhat.com>, Mukesh Rathor <mukesh.rathor@oracle.com>,
        Mike Rapoport <mike.rapoport@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, xen-devel@lists.xensource.com
Subject: Re: [QUERY] lguest64
References: <CALkWK0n7zedKD4tnxKh-qMuDnMJ5RXjnPJ9EUWT=cCgiokX11A@mail.gmail.com> <51E97779.3020103@zytor.com> <87zjte9iah.fsf@rustcorp.com.au> <CABpLfohrweJd0=0eFJDO7dv2HHxx_mbP0uySMDrsZZZXExdXug@mail.gmail.com> <51F9005F.30501@zytor.com> <20130731131757.GB22124@phenom.dumpdata.com> <51F91030.9060606@zytor.com> <20130802190934.GA4354@phenom.dumpdata.com> <20130804123708.GM6042@redhat.com> <20130805165040.GC22093@phenom.dumpdata.com>
In-Reply-To: <20130805165040.GC22093@phenom.dumpdata.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 09:50 AM, Konrad Rzeszutek Wilk wrote:
>>>
>>> Let me iterate down what the experimental patch uses:
>>>
>>>          struct pv_init_ops pv_init_ops;                                         
>>> 		[still use xen_patch, but I think that is not needed anymore]
>>>
>>>          struct pv_time_ops pv_time_ops;                                         
>>> 		[we need that as we are using the PV clock source]
>>>
>>>          struct pv_cpu_ops pv_cpu_ops;                                           
>>> 		[only end up using cpuid. This one is a tricky one. We could
>>> 		 arguable remove it but it does do some filtering - for example
>>> 	 	 THERM is turned off, or MWAIT if a certain hypercall tells us to
>>> 		 disable that. Since this is now a trapped operation this could be
>>> 		 handled in the hypervisor - but then it would be in charge of
>>> 		 filtering certain CPUID - and this is at bootup - so there is not
>>> 		 user interaction. This needs a bit more of thinking]
>>>
>> read_msr/write_msr in this one make all msr accesses safe. IIRC there
>> are MSRs that Linux uses without checking cpuid bits.
>> IA32_PERF_CAPABILITIES for instance is used without checking PDCM bit.
> 
> Right, those are needed as well. Completly forgot about them.

CPUID is not too bad.  RDMSR/WRMSR is actually worse since there are
some MSRs which are performance-critical.  The really messy pvops are
the memory-related ones, as they don't match the hardware behavior.

Similarly, beyond pvops, what new assumptions does this code add to the
code base?

	-hpa


