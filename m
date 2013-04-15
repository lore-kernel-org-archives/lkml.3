Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933813Ab3DORIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 13:08:24 -0400
Received: from a9-50.smtp-out.amazonses.com ([54.240.9.50]:44322 "EHLO
	a9-50.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932081Ab3DORIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 13:08:23 -0400
X-Greylist: delayed 861 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Apr 2013 13:08:23 EDT
Date: Mon, 15 Apr 2013 16:53:59 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Arjan van de Ven <arjan@linux.intel.com>
cc: paulmck@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH documentation 1/2] nohz1: Add documentation.
In-Reply-To: <516C2DAF.6010908@linux.intel.com>
Message-ID: <0000013e0e9e0ca6-12c738ba-6939-4b31-8a40-186019c5d16a-000000@email.amazonses.com>
References: <20130411160524.GA30384@linux.vnet.ibm.com> <1365696359-30958-1-git-send-email-paulmck@linux.vnet.ibm.com> <20130411182502.GA31684@pd.tnic> <20130411191355.GO29861@linux.vnet.ibm.com> <1365753904.17140.22.camel@laptop> <20130412175419.GG29861@linux.vnet.ibm.com>
 <51684AD3.7090305@linux.intel.com> <0000013e0e6cacbb-b7e44c6f-d551-49b9-aa07-62a4ee280ae7-000000@email.amazonses.com> <516C2DAF.6010908@linux.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.04.15-54.240.9.50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Apr 2013, Arjan van de Ven wrote:

> to put the "cost" into perspective; programming a timer in one-shot mode
> is some math on the cpu (to go from kernel time to hardware time),
> which is a multiply and a shift (or a divide), and then actually
> programming the hardware, which is at the cost of (approximately) a cachemiss
> or two
> (so give or take in the "hundreds" of cycles)
> at least on moderately modern hardware (e.g. last few years)

Well these are PCI transactions which are bound to be high latency
reaching may be more than microscond in total. A timer interrupt may last
2-4 microsecond at best without PCI transactions.

> not cheap. But also not INSANE expensive... and it breaks-even already if you
> only
> save one or two cache misses elsewhere.

Ok then maybe go dynticks if we can save at least one timer tick?
