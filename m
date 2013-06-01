Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab3FAUOw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 16:14:52 -0400
Received: from one.firstfloor.org ([193.170.194.197]:48909 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab3FAUOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 16:14:50 -0400
Date: Sat, 1 Jun 2013 22:14:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: gleb@redhat.com, mingo@redhat.com, jeremy@goop.org, x86@kernel.org,
        konrad.wilk@oracle.com, hpa@zytor.com, pbonzini@redhat.com,
        linux-doc@vger.kernel.org, habanero@linux.vnet.ibm.com,
        xen-devel@lists.xensource.com, peterz@infradead.org,
        mtosatti@redhat.com, stefano.stabellini@eu.citrix.com,
        andi@firstfloor.org, attilio.rao@citrix.com, ouyang@cs.pitt.edu,
        gregkh@suse.de, agraf@suse.de, chegu_vinod@hp.com,
        torvalds@linux-foundation.org, avi.kivity@gmail.com,
        tglx@linutronix.de, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stephan.diestelhorst@amd.com, riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V9 0/19] Paravirtualized ticket spinlocks
Message-ID: <20130601201442.GP6123@two.firstfloor.org>
References: <20130601082145.22955.33596.sendpatchset@codeblue>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130601082145.22955.33596.sendpatchset@codeblue>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FWIW I use the paravirt spinlock ops for adding lock elision
to the spinlocks.

This needs to be done at the top level (so the level you're removing)

However I don't like the pv mechanism very much and would 
be fine with using an static key hook in the main path
like I do for all the other lock types.

It also uses interrupt ops patching, for that it would 
be still needed though.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
