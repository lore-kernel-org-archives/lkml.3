Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbaD0SeE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 14:34:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:39336 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749AbaD0SeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 14:34:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,938,1389772800"; 
   d="scan'208";a="521453632"
Date: Sun, 27 Apr 2014 11:34:01 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Oren Twaig <oren@scalemp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Shai Fultheim <shai@scalemp.com>
Subject: Re: [PATCH v2] X86: Hook apic vector allocation domain only when
 interrupt routing are set to ignore
Message-ID: <20140427183401.GB19657@tassilo.jf.intel.com>
References: <1398376326-3055-1-git-send-email-oren@scalemp.com>
 <20140425142248.GL8874@tassilo.jf.intel.com>
 <535CAA77.4000405@scalemp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535CAA77.4000405@scalemp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 09:57:59AM +0300, Oren Twaig wrote:
> Hi Andi,
> 
> On 04/25/2014 05:22 PM, Andi Kleen wrote:
> >> +static int irc = 1;
> > Using a static for such state is very unusual. You need to describe what
> > protects it against races and why that is needed over a cleaner solution.
> 
> The only reason I've used a static variable is because I wanted to avoid
> inserting another code/functions which are depended on CONFIG_PCI.  The code is
> used once during initialization and hence cannot be racy.

Again, what lock protects it?

If you cannot answer that question you likely shouldn't use static.

-Andi
