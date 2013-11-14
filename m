Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab3KNIbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 03:31:00 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48689 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab3KNIa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 03:30:57 -0500
Date: Thu, 14 Nov 2013 09:30:37 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Preeti Murthy <preeti.lkml@gmail.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        mikey@neuling.org, linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH v2] sched: Check sched_domain before computing group
 power.
Message-ID: <20131114083037.GT21461@twins.programming.kicks-ass.net>
References: <tip-db2pe0vxwunv37plc7onnugj@git.kernel.org>
 <20131112105547.GA27310@linux.vnet.ibm.com>
 <20131112115736.GO5056@laptop.programming.kicks-ass.net>
 <20131112164126.GF2559@linux.vnet.ibm.com>
 <CAM4v1pNMn=5oZDiX3fUp9uPkZTPJgk=vEKEjevzvpwn=PjTzXg@mail.gmail.com>
 <20131113112329.GC543@linux.vnet.ibm.com>
 <52846863.4060001@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52846863.4060001@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 11:36:27AM +0530, Preeti U Murthy wrote:
> However I was thinking that a better fix would be to reorder the way we call
> update_group_power() and cpu_attach_domain(). Why do we need to do
> update_group_power() of the groups of the sched domains that would probably
> degenerate in cpu_attach_domain()? So it seemed best to move update_group_power()
> to after cpu_attach_domain() so that it saves unnecessary iterations over
> sched domains which could degenerate, and it fixes the issue that you have brought out
> as well. See below for the patch:

So how is publishing the domain tree before we've set these values at
all going to help avoid the divide-by-zero problem?

Also its just terribly bad form to publish something before you're done
with initialization.
