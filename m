Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab3FAUhQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 16:37:16 -0400
Received: from claw.goop.org ([74.207.240.146]:51286 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915Ab3FAUhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 16:37:15 -0400
X-Greylist: delayed 551 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Jun 2013 16:37:14 EDT
Message-ID: <51AA5950.6050603@goop.org>
Date: Sat, 01 Jun 2013 13:28:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>, gleb@redhat.com,
        mingo@redhat.com, x86@kernel.org, konrad.wilk@oracle.com,
        hpa@zytor.com, pbonzini@redhat.com, linux-doc@vger.kernel.org,
        habanero@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
        peterz@infradead.org, mtosatti@redhat.com,
        stefano.stabellini@eu.citrix.com, attilio.rao@citrix.com,
        ouyang@cs.pitt.edu, gregkh@suse.de, agraf@suse.de, chegu_vinod@hp.com,
        torvalds@linux-foundation.org, avi.kivity@gmail.com,
        tglx@linutronix.de, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stephan.diestelhorst@amd.com, riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V9 0/19] Paravirtualized ticket spinlocks
References: <20130601082145.22955.33596.sendpatchset@codeblue> <20130601201442.GP6123@two.firstfloor.org>
In-Reply-To: <20130601201442.GP6123@two.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2013 01:14 PM, Andi Kleen wrote:
> FWIW I use the paravirt spinlock ops for adding lock elision
> to the spinlocks.

Does lock elision still use the ticketlock algorithm/structure, or are
they different?  If they're still basically ticketlocks, then it seems
to me that they're complimentary - hle handles the fastpath, and pv the
slowpath.

> This needs to be done at the top level (so the level you're removing)
>
> However I don't like the pv mechanism very much and would 
> be fine with using an static key hook in the main path
> like I do for all the other lock types.

Right.

    J
