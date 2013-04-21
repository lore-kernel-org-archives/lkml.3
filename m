Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab3DUXHz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 19:07:55 -0400
Received: from mb2i1mx.ns.pitt.edu ([136.142.11.142]:64206 "EHLO
	mb2i1.ns.pitt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752618Ab3DUXHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 19:07:53 -0400
Date: Sun, 21 Apr 2013 19:07:51 -0400
From: Jiannan Ouyang <ouyang@cs.pitt.edu>
Subject: Re: Preemptable Ticket Spinlock
In-reply-to: <51745650.9050204@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
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
Message-id: <CAJocwccDznaMGkBgWpZ9M5k3JUqf0pnvK2hDyRBR_JEseNrQ_g@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
References: <CAJocwccu5QQyuKRvgNyPSFz2K_rzCW419W9-XdSUYOL7+KqQKg@mail.gmail.com>
 <51745650.9050204@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 21, 2013 at 5:12 PM, Rik van Riel <riel@redhat.com> wrote:
> Your algorithm is very clever, and very promising.
>
> However, it does increase the size of the struct spinlock, and adds
> an additional atomic operation to spin_unlock, neither of which I
> suspect are necessary.
>
> If we always incremented the ticket number by 2 (instead of 1), then
> we could use the lower bit of the ticket number as the spinlock.
>
> If we do NOT run virtualized, we simply increment the ticket by 2
> in spin_unlock, and the code can remain otherwise the same.
>
> If we do run virtualized, we take that spinlock after acquiring
> the ticket (or timing out), just like in your code. In the
> virtualized spin_unlock, we can then release the spinlock and
> increment the ticket in one operation: by simply increasing the
> ticket by 1.
>
> In other words, we should be able to keep the overhead of this
> to an absolute minimum, and keep spin_unlock to be always the
> same cost it is today.
>
> --
> All rights reversed

Hi Rik,

Thanks for your feedback.

Yes I agree with you
- increase the size of struct spinlock is unnecessary
- your idea of utilize the lower bit and save one atomic operation
from unlock is cool!

I can come up with a updated patch soon.

--Jiannan
