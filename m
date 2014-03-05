Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbaCEAvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 19:51:18 -0500
Received: from mga01.intel.com ([192.55.52.88]:10843 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243AbaCEAvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 19:51:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,589,1389772800"; 
   d="scan'208";a="492468172"
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Khalid Aziz <khalid.aziz@oracle.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        peterz@infradead.org, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, oleg@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>
	<531641A8.40306@zytor.com> <53164824.3000704@oracle.com>
	<20140304222356.41c55bbc@alan.etchedpixels.co.uk>
	<5316574F.6040105@oracle.com>
	<alpine.DEB.2.02.1403050129570.18573@ionos.tec.linutronix.de>
Date: Tue, 04 Mar 2014 16:51:15 -0800
In-Reply-To: <alpine.DEB.2.02.1403050129570.18573@ionos.tec.linutronix.de>
	(Thomas Gleixner's message of "Wed, 5 Mar 2014 01:39:07 +0100 (CET)")
Message-ID: <8738ix5uyk.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> On Tue, 4 Mar 2014, Khalid Aziz wrote:
>> be in the right control group. Besides they want to use a common mechanism
>> across multiple OSs and pre-emption delay is already in use on other OSs. Good
>> idea though.
>
> Well, just because preemption delay is a mechanism exposed by some
> other OS does not make it a good idea.
>
> In fact its a horrible idea.
>
> What you are creating is a crystal ball based form of time bound
> priority ceiling with the worst user space interface i've ever seen.

So how would you solve the user space lock holder preemption 
problem then?

It's a real problem, affecting lots of workloads.

Just saying everything is crap without suggesting anything 
constructive is not really getting us anywhere.

The workarounds I've seen for it are generally far worse
than this. Often people do all kinds of fragile tunings
to address this, when then break on the next kernel
update that does even a minor scheduler change.

futex doesn't solve the problem at all.

The real time scheduler is also really poor fit for these 
workloads and needs a lot of hacks to scale.

The thread swap proposal from plumbers had some potential,
but it's likely very intrusive everywhere and seems
to have died too.

Anything else?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
