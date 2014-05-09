Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140AbaEIQmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 12:42:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:52529 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756907AbaEIQmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 12:42:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1019,1389772800"; 
   d="scan'208";a="509110106"
Message-ID: <536D0571.6030202@intel.com>
Date: Fri, 09 May 2014 09:42:25 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: KVM_GUEST support breaks page fault tracing
References: <536C039A.5000204@intel.com>	<alpine.DEB.2.02.1405090024050.6261@ionos.tec.linutronix.de>	<536C0DA8.4090608@intel.com> <20140508194508.561ed220@gandalf.local.home>
In-Reply-To: <20140508194508.561ed220@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2014 04:45 PM, Steven Rostedt wrote:
> As your patch showed up as an attachment, I couldn't include it in my
> reply. But sure, that may work. But you could also play tricks to keep
> the overhead off when tracing is disabled like this one:
...

How important is it to have zero-overhead?  This bug was introduced by
trying to do just that, and I'm worried about having an explosion of so
many paths to get in to the page fault code.  The overhead in this case
is just a few noops, right?

I guess that's a question for the KVM folks.  Do you guys prefer zero
overhead or simpler code?
