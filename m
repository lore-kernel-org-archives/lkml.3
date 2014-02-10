Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaBJT2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:28:36 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:48805 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbaBJT2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:28:34 -0500
Date: Tue, 11 Feb 2014 00:57:47 +0530
From: Gautham R Shenoy <ego@linux.vnet.ibm.com>
To: Gautham R Shenoy <ego@linux.vnet.ibm.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, paulus@samba.org,
        oleg@redhat.com, rusty@rustcorp.com.au, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH 26/51] x86, oprofile, nmi: Fix CPU hotplug callback
 registration
Message-ID: <20140210192747.GE3416@in.ibm.com>
Reply-To: ego@linux.vnet.ibm.com
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
 <20140205220921.19080.94715.stgit@srivatsabhat.in.ibm.com>
 <20140210190737.GD3416@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210190737.GD3416@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021019-0320-0000-0000-0000026D96F3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 12:37:37AM +0530, Gautham R Shenoy wrote:
> Hi,
> 
> On Thu, Feb 06, 2014 at 03:39:22AM +0530, Srivatsa S. Bhat wrote:
> > Fix the oprofile code in x86 by using this latter form of callback
> > registration. But retain the calls to get/put_online_cpus(), since they
> > also protect the variables 'nmi_enabled' and 'ctr_running'.
> 
> get/put_online_cpus() protect us against cpu_hotplug_begin/end(). The
> latter is always nested inside cpu_maps_update_begin/end(), which we
> are already using here. 
> 
> So what additional protection are we getting by retaining
> get/put_online_cpus() ?

Probably you mean to say that there are other places which access
'nmi_enabled' and 'ctr_running' with the cpu-hotplug protection
provided only by get/put_online_cpus() and you are retaining the calls
in this patch to be consistent with those other places. If so, could
you reword the changelog to reflect this instead of saying "they also
protect the variables ..." ?

--
Thanks and Regards
gautham.

