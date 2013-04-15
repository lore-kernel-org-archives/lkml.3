Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab3DOQGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 12:06:05 -0400
Received: from a9-58.smtp-out.amazonses.com ([54.240.9.58]:41432 "EHLO
	a9-58.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753635Ab3DOQGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 12:06:03 -0400
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Apr 2013 12:06:02 EDT
Date: Mon, 15 Apr 2013 16:00:04 +0000
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
In-Reply-To: <51684AD3.7090305@linux.intel.com>
Message-ID: <0000013e0e6cacbb-b7e44c6f-d551-49b9-aa07-62a4ee280ae7-000000@email.amazonses.com>
References: <20130411160524.GA30384@linux.vnet.ibm.com> <1365696359-30958-1-git-send-email-paulmck@linux.vnet.ibm.com> <20130411182502.GA31684@pd.tnic> <20130411191355.GO29861@linux.vnet.ibm.com> <1365753904.17140.22.camel@laptop> <20130412175419.GG29861@linux.vnet.ibm.com>
 <51684AD3.7090305@linux.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.04.15-54.240.9.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Apr 2013, Arjan van de Ven wrote:

> but arguably, that's because of HRTIMERS more than NOHZ
> (e.g. I bet we still turn off periodic even for nohz as long as hrtimers are
> enabled)

If we are able to only get rid of one timer tick on average with dynticks
then I would think that is enough to justify having it on by default.

If the scheduling period from the schduler is around 20ms then one may be
able to save processing 20 timer ticks by going to htimers.

The main issue with hrtimers is likely going to be that is it is too much
effort for small timerframes less than 10ms. Could we  only switch off the
timer tick if the next event is more than 10 ticks aways?

