Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab3C0UFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 16:05:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:37758 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab3C0UFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 16:05:45 -0400
Date: Wed, 27 Mar 2013 21:05:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Nathan Zimmer <nzimmer@sgi.com>, linux-kernel@vger.kernel.org,
        John Stultz <johnstul@us.ibm.com>, Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH 2/2] timer_list: convert timer list to be a proper
 seq_file
In-Reply-To: <20130327121412.f589d0cc105843284e1d8eb5@linux-foundation.org>
Message-ID: <alpine.LFD.2.02.1303272104150.22263@ionos>
References: <alpine.LFD.2.02.1303251651200.22263@ionos> <1364345790-14577-1-git-send-email-nzimmer@sgi.com> <1364345790-14577-3-git-send-email-nzimmer@sgi.com> <20130327121412.f589d0cc105843284e1d8eb5@linux-foundation.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Mar 2013, Andrew Morton wrote:
> On Tue, 26 Mar 2013 19:56:30 -0500 Nathan Zimmer <nzimmer@sgi.com> wrote:
> > +void sysrq_timer_list_show(void)
> > +{
> > +	u64 now = ktime_to_ns(ktime_get());
> > +	int cpu;
> > +
> > +	timer_list_header(NULL, now);
> >  
> >  	for_each_online_cpu(cpu)
> 
> hm, it seems this code is taking the optimistic approach to CPU hotplug.

Right. It's not really relevant. The data structures are not going
away and this can cope with the fact that the cpu went away under us.

Thanks,

	tglx
