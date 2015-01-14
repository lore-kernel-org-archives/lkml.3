Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272AbbANEoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 23:44:12 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:54154 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbbANEoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 23:44:10 -0500
Message-ID: <54B5F410.2030002@linux.vnet.ibm.com>
Date: Wed, 14 Jan 2015 10:14:00 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Edjunior Barbosa Machado <emachado@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
CC: mikey@neuling.org, james.hogan@imgtec.com, avagin@openvz.org,
        Paul.Clothier@imgtec.com, peterz@infradead.org, palves@redhat.com,
        Ulrich Weigand <uweigand@de.ibm.com>, shuahkh@osg.samsung.com,
        akpm@linux-foundation.org, oleg@redhat.com, dhowells@redhat.com,
        kirjanov@gmail.com, davej@redhat.com, tglx@linutronix.de,
        sukadev@linux.vnet.ibm.com, davem@davemloft.net,
        sam.bobroff@au1.ibm.com
Subject: Re: [V6,1/9] elf: Add new powerpc specifc core note sections
References: <20141203052204.9DA8F1400DD@ozlabs.org> <547EB253.5050307@linux.vnet.ibm.com> <548578A8.5020901@linux.vnet.ibm.com> <54947C64.4030206@linux.vnet.ibm.com> <54A50094.5070902@linux.vnet.ibm.com>
In-Reply-To: <54A50094.5070902@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011404-0013-0000-0000-00000354E349
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/2015 01:38 PM, Anshuman Khandual wrote:
>> > Also, we've noticed that the 'misc' regset contains registers from different ISA
>> > versions (dscr and ppr appear in ISA 2.05, tar is from 2.07). I'm not sure if
>> > there is a way to detect presence/validity of such registers, but perhaps it
>> > might be a good idea to separate registers from different ISAs in different
>> > regsets.
> Thats right, will use feature CPU_FTR_ARCH_207S (which checks whether we are v2.07
> compliant) to detect whether TAR register is available or not. 
> 

Need to correct something here. Run time detection of the presence of TAR register
through the feature bit CPU_FTR_ARCH_207S as I had mentioned before is not required.
Right now we take care of the compile time availability of the individual registers
the same way it is present on the thread struct. In the systems which do not have the
TAR register, thread.tar is always going to be 0 which is exactly the same value we
would get by excluding tar register copy after the run time detection of the feature.

