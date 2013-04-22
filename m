Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab3DVVCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 17:02:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45888 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab3DVVCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 17:02:01 -0400
Message-ID: <1366664518.8337.21.camel@laptop>
Subject: Re: Preemptable Ticket Spinlock
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Jiannan Ouyang <ouyang@cs.pitt.edu>, LKML <linux-kernel@vger.kernel.org>,
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
Date: Mon, 22 Apr 2013 23:01:58 +0200
In-Reply-To: <5175A277.5080208@redhat.com>
References: <CAJocwccu5QQyuKRvgNyPSFz2K_rzCW419W9-XdSUYOL7+KqQKg@mail.gmail.com>
	 <51745650.9050204@redhat.com> <1366631460.4443.3.camel@laptop>
	 <51753289.70406@redhat.com> <1366660147.6454.6.camel@laptop>
	 <517595FA.800@redhat.com> <1366661294.6454.18.camel@laptop>
	 <CAJocwceW6BuEu0Yuyv472aarpcziZH1wd-Xbc+Om81ES8+w+SA@mail.gmail.com>
	 <5175A277.5080208@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-22 at 16:49 -0400, Rik van Riel wrote:
> Given the fairly high cost of rescheduling a VCPU (which is likely
> to include an IPI), versus the short hold time of most spinlocks,
> I have the strong suspicion that your approach would win.

  https://lkml.org/lkml/2012/5/2/101

If you schedule too often your SPIN_THRESHOLD is far too low.

Anyway.. performance can't be that bad, otherwise Jeremey would have
spend as much time on it as he did.

