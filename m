Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbaCVAbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 20:31:00 -0400
Received: from one.firstfloor.org ([193.170.194.197]:32897 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaCVAa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 20:30:57 -0400
Date: Sat, 22 Mar 2014 01:30:56 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Wu <peter@lekensteyn.nl>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: GPF in intel_pmu_lbr_reset() with qemu -cpu host
Message-ID: <20140322003056.GQ22728@two.firstfloor.org>
References: <4055058.qLAukpngnj@al>
 <20140321192938.GJ3132@tassilo.jf.intel.com>
 <970fd799-8d4c-4759-8a96-1291b411f307@email.android.com>
 <20140321213753.GK3132@tassilo.jf.intel.com>
 <532CB21B.4040502@zytor.com>
 <8761n7nryi.fsf@tassilo.jf.intel.com>
 <532CB54C.8020003@zytor.com>
 <20140322002244.GP22728@two.firstfloor.org>
 <532CD8A9.5080603@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532CD8A9.5080603@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 05:26:17PM -0700, H. Peter Anvin wrote:
> On 03/21/2014 05:22 PM, Andi Kleen wrote:
> >> Actually, Ingo, Borislav and I have been discussing making rdmsr_safe()
> >> more of the default, especially for things like this where the error
> >> handling is obvious (doesn't work?  Disable the PMU.)
> > 
> > That would be completely wrong. KVM has a full architectural perfmon PMU,
> > just no model specific extensions like LBR.
> > 
> 
> s/PMU/PMU extension in question/

%  grep -r 'rdmsr' arch/x86/*  | grep -v safe | wc -l
285

I assume it'll keep you all busy for a while.

[compared to a likely one liner in KVM]

-Andi
