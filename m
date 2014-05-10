Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747AbaEJBJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 21:09:20 -0400
Received: from g6t1526.atlanta.hp.com ([15.193.200.69]:58980 "EHLO
	g6t1526.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541AbaEJBJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 21:09:18 -0400
Message-ID: <536D7C28.8010609@hp.com>
Date: Fri, 09 May 2014 21:08:56 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v10 08/19] qspinlock: Make a new qnode structure to support
 virtualization
References: <1399474907-22206-1-git-send-email-Waiman.Long@hp.com> <1399474907-22206-9-git-send-email-Waiman.Long@hp.com> <20140508190459.GQ2844@laptop.programming.kicks-ass.net>
In-Reply-To: <20140508190459.GQ2844@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2014 03:04 PM, Peter Zijlstra wrote:
> On Wed, May 07, 2014 at 11:01:36AM -0400, Waiman Long wrote:
>>   /*
>> + * To have additional features for better virtualization support, it is
>> + * necessary to store additional data in the queue node structure. So
>> + * a new queue node structure will have to be defined and used here.
>> + */
>> +struct qnode {
>> +	struct mcs_spinlock mcs;
>> +};
> You can ditch this entire patch; its pointless, just add a new
> DEFINE_PER_CPU for the para-virt muck.

Yes, I can certainly merge it to the next one in the series. I break it 
out to make each individual patch smaller, more single-purpose and 
easier to review.

-Longman
