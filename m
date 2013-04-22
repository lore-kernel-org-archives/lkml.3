Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab3DVUua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 16:50:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab3DVUu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 16:50:29 -0400
Message-ID: <5175A277.5080208@redhat.com>
Date: Mon, 22 Apr 2013 16:49:59 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jiannan Ouyang <ouyang@cs.pitt.edu>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
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
References: <CAJocwccu5QQyuKRvgNyPSFz2K_rzCW419W9-XdSUYOL7+KqQKg@mail.gmail.com> <51745650.9050204@redhat.com> <1366631460.4443.3.camel@laptop> <51753289.70406@redhat.com> <1366660147.6454.6.camel@laptop> <517595FA.800@redhat.com> <1366661294.6454.18.camel@laptop> <CAJocwceW6BuEu0Yuyv472aarpcziZH1wd-Xbc+Om81ES8+w+SA@mail.gmail.com>
In-Reply-To: <CAJocwceW6BuEu0Yuyv472aarpcziZH1wd-Xbc+Om81ES8+w+SA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2013 04:46 PM, Jiannan Ouyang wrote:

> It would still be very interesting to conduct more experiments to
> compare these two, to see if the fairness enforced by pv_lock is
> mandatory, and if preemptable-lock outperforms pv_lock in most cases,
> and how do they work with PLE.

Given the fairly high cost of rescheduling a VCPU (which is likely
to include an IPI), versus the short hold time of most spinlocks,
I have the strong suspicion that your approach would win.

The fairness is only compromised in a limited way and in certain
circumstances, so I am not too worried about that.

-- 
All rights reversed
