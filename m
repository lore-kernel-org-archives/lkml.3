Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab3DVUol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 16:44:41 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:40402
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754852Ab3DVUok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 16:44:40 -0400
Message-ID: <1366663475.8337.10.camel@laptop>
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
Date: Mon, 22 Apr 2013 22:44:35 +0200
In-Reply-To: <51759E43.2080003@redhat.com>
References: <CAJocwccu5QQyuKRvgNyPSFz2K_rzCW419W9-XdSUYOL7+KqQKg@mail.gmail.com>
	    <51745650.9050204@redhat.com> <1366631460.4443.3.camel@laptop>
	   <51753289.70406@redhat.com> <1366660147.6454.6.camel@laptop>
	  <517595FA.800@redhat.com> <1366661294.6454.18.camel@laptop>
	 <51759E43.2080003@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-22 at 16:32 -0400, Rik van Riel wrote:
> 
> IIRC one of the reasons was that the performance improvement wasn't
> as obvious.  Rescheduling VCPUs takes a fair amount of time, quite
> probably more than the typical hold time of a spinlock.

IIRC it would spin for a while before blocking..

/me goes re-read some of that thread...

Ah, its because PLE is curing most of it.. !PLE it had huge gains but
apparently nobody cares about !PLE hardware anymore :-)

