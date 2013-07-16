Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662Ab3GPSqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 14:46:25 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:40678 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933306Ab3GPSqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 14:46:23 -0400
Message-ID: <51E595C6.9020708@linux.vnet.ibm.com>
Date: Wed, 17 Jul 2013 00:19:42 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Gleb Natapov <gleb@redhat.com>, mingo@redhat.com, jeremy@goop.org,
        x86@kernel.org, konrad.wilk@oracle.com, hpa@zytor.com,
        pbonzini@redhat.com, linux-doc@vger.kernel.org,
        habanero@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
        mtosatti@redhat.com, stefano.stabellini@eu.citrix.com,
        andi@firstfloor.org, attilio.rao@citrix.com, ouyang@cs.pitt.edu,
        gregkh@suse.de, agraf@suse.de, chegu_vinod@hp.com,
        torvalds@linux-foundation.org, avi.kivity@gmail.com,
        tglx@linutronix.de, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V10 15/18] kvm : Paravirtual ticketlocks support for
 linux guests running on KVM hypervisor
References: <20130624124014.27508.8906.sendpatchset@codeblue.in.ibm.com> <20130624124342.27508.44656.sendpatchset@codeblue.in.ibm.com> <20130714131241.GA11772@redhat.com> <51E3C5CE.7000009@linux.vnet.ibm.com> <20130715103648.GN11772@redhat.com> <51E4C011.4060803@linux.vnet.ibm.com> <20130716060215.GE11772@redhat.com> <20130716154852.GN23818@dyad.programming.kicks-ass.net>
In-Reply-To: <20130716154852.GN23818@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071618-0260-0000-0000-000003518AB5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 09:18 PM, Peter Zijlstra wrote:
> On Tue, Jul 16, 2013 at 09:02:15AM +0300, Gleb Natapov wrote:
>> BTW can NMI handler take spinlocks?
>
> No -- that is, yes you can using trylock, but you still shouldn't.

Thanks Peter for the clarification.

I had started checking few of nmi handlers code to confirm.
Did saw a raw spinlock in drivers/acpi/apei/ghes.c, but then stopped.

>
>> If it can what happens if NMI is
>> delivered in a section protected by local_irq_save()/local_irq_restore()?
>
> You deadlock.
>

