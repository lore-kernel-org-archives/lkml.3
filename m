Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbaCQRr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 13:47:58 -0400
Received: from g6t1526.atlanta.hp.com ([15.193.200.69]:30285 "EHLO
	g6t1526.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbaCQRr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 13:47:57 -0400
Message-ID: <53273532.1010003@hp.com>
Date: Mon, 17 Mar 2014 13:47:30 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        virtualization@lists.linux-foundation.org,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Michel Lespinasse <walken@google.com>,
        Alok Kataria <akataria@vmware.com>, linux-arch@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, xen-devel@lists.xenproject.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>, Scott J Norton <scott.norton@hp.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Wright <chrisw@sous-sol.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Chegu Vinod <chegu_vinod@hp.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v6 10/11] pvqspinlock, x86: Enable qspinlock PV support
 for KVM
References: <1394650498-30118-1-git-send-email-Waiman.Long@hp.com>	<1394650498-30118-11-git-send-email-Waiman.Long@hp.com>	<5321B9BE.7050209@redhat.com> <5322035B.5000205@hp.com> <5322C0F7.2090604@redhat.com>
In-Reply-To: <5322C0F7.2090604@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2014 04:42 AM, Paolo Bonzini wrote:
> Il 13/03/2014 20:13, Waiman Long ha scritto:
>>>>
>>>
>>> This should also disable the unfair path.
>>>
>>> Paolo
>>>
>>
>> The unfair lock uses a different jump label and does not require any
>> special PV ops. There is a separate init function for that.
>
> Yeah, what I mean is that the patches that enable paravirtualization 
> should also take care of decreasing the unfair-lock jump label when 
> paravirtualization is enabled.
>
> Paolo

As there are people who don't like unfair lock at all, I prefer to give 
them the option to turn this on or off instead of forcing them to always 
use unfair lock in a PV guest.

-Longman
