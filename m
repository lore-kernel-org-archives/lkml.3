Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759774AbaCTWkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 18:40:20 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:40493 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759160AbaCTWkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 18:40:17 -0400
Message-ID: <532B6E48.2070205@redhat.com>
Date: Thu, 20 Mar 2014 23:40:08 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Waiman Long <Waiman.Long@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Peter Zijlstra <peterz@infradead.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@redhat.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-arch@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Scott J Norton <scott.norton@hp.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Wright <chrisw@sous-sol.org>, Alok Kataria <akataria@vmware.com>,
        virtualization@lists.linux-foundation.org,
        Chegu Vinod <chegu_vinod@hp.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 06/11] pvqspinlock, x86: Allow unfair queue spinlock
 in a KVM guest
References: <1395260049-30839-1-git-send-email-Waiman.Long@hp.com>	<1395260049-30839-7-git-send-email-Waiman.Long@hp.com>	<532B6543.7050707@redhat.com> <532B6BC8.8010502@zytor.com>
In-Reply-To: <532B6BC8.8010502@zytor.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 20/03/2014 23:29, H. Peter Anvin ha scritto:
> > No!  Please do what I asked you to do.  You are not handling Hyper-V or
> > VMWare.  Just use X86_FEATURE_HYPERVISOR and it will cover all
> > hypervisors that actually follow Intel's guidelines.
>
> And for those that don't, we should turn on X86_FEATURE_HYPERVISOR in
> the Linux enumeration code as we do for other features we detect
> independently.

Yeah, but all the hypervisors we detect right now are fine.  Not 
surprising, since Microsoft won't certify Windows on your hypervisor 
unless you set the bit, and KVM/Xen/VMware are all certified (Hyper-V 
does not go through the same certification, but sets it anyway).

I got a second-hand report that VirtualBox doesn't set it---and I 
haven't verified that yet---but we don't even try to detect vbox right now.

Paolo
