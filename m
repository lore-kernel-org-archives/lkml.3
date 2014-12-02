Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736AbaLBTMP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:12:15 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:20953 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbaLBTMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:12:13 -0500
Date: Tue, 2 Dec 2014 14:10:58 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>
Subject: Re: [PATCH v13 10/11] pvqspinlock, x86: Enable PV qspinlock for KVM
Message-ID: <20141202191058.GA357@laptop.dumpdata.com>
References: <1414613951-32532-1-git-send-email-Waiman.Long@hp.com>
 <1414613951-32532-11-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414613951-32532-11-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 04:19:10PM -0400, Waiman Long wrote:
> This patch adds the necessary KVM specific code to allow KVM to
> support the CPU halting and kicking operations needed by the queue
> spinlock PV code.
> 
> Two KVM guests of 20 CPU cores (2 nodes) were created for performance
> testing in one of the following three configurations:
>  1) Only 1 VM is active
>  2) Both VMs are active and they share the same 20 physical CPUs
>     (200% overcommit)
> 
> The tests run included the disk workload of the AIM7 benchmark on
> both ext4 and xfs RAM disks at 3000 users on a 3.17 based kernel. The
> "ebizzy -m" test and futextest was was also run and its performance
> data were recorded.  With two VMs running, the "idle=poll" kernel
> option was added to simulate a busy guest. If PV qspinlock is not
> enabled, unfairlock will be used automically in a guest.

What is the unfairlock? Isn't it just using a bytelock at this point?
