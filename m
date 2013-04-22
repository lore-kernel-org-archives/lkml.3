Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab3DVV5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 17:57:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:33977 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555Ab3DVV5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 17:57:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,529,1363158000"; 
   d="scan'208";a="322570886"
From: Andi Kleen <andi@firstfloor.org>
To: Rik van Riel <riel@redhat.com>
Cc: Jiannan Ouyang <ouyang@cs.pitt.edu>, LKML <linux-kernel@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Avi Kivity <avi.kivity@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Andrew Jones <drjones@redhat.com>, Karen Noel <knoel@redhat.com>
Subject: Re: Preemptable Ticket Spinlock
References: <CAJocwccu5QQyuKRvgNyPSFz2K_rzCW419W9-XdSUYOL7+KqQKg@mail.gmail.com>
	<51745650.9050204@redhat.com>
Date: Mon, 22 Apr 2013 14:56:44 -0700
In-Reply-To: <51745650.9050204@redhat.com> (Rik van Riel's message of "Sun, 21
	Apr 2013 17:12:48 -0400")
Message-ID: <m2k3nuw7oj.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel <riel@redhat.com> writes:
>
> If we always incremented the ticket number by 2 (instead of 1), then
> we could use the lower bit of the ticket number as the spinlock.

Spinning on a single bit is very inefficient, as you need to do
try lock in a loop which is very unfriendly to the MESI state protocol.
It's much better to have at least three states and allow
spinning-while-reading-only.

This is typically very visible on systems with >2S.

-Andi
        
-- 
ak@linux.intel.com -- Speaking for myself only
