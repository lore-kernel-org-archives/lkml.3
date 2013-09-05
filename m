Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab3IEONN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 10:13:13 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:59420 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab3IEONL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 10:13:11 -0400
Date: Thu, 5 Sep 2013 16:13:05 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lockref: remove cpu_relax() again
Message-ID: <20130905141305.GB24274@osiris>
References: <20130905131814.GA24274@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905131814.GA24274@osiris>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090514-4966-0000-0000-000006CBB5A0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 03:18:14PM +0200, Heiko Carstens wrote:
> d472d9d9 "lockref: Relax in cmpxchg loop" added a cpu_relax() call to the
> CMPXCHG_LOOP() macro. However to me it seems to be wrong since it is very
> likely that the next round will succeed (or the loop will be left).
> Even worse: cpu_relax() is very expensive on s390, since it means yield
> "my virtual cpu to the hypervisor". So we are talking of several 1000 cycles.
> 
> In fact some measurements show the bad impact of the cpu_relax() call on
> s390 using Linus' test case that "stats()" like mad:
> 
> Without converting s390 to lockref:
> Total loops: 81236173
> 
> After converting s390 to lockref:
> Total loops: 31896802
> 
> After converting s390 to lockref but with removed cpu_relax() call:
> Total loops: 86242190

All of those should have been "converting s390 to ARCH_USE_CMPXCHG_LOCKREF"
instead of "to lockref" of course .. ;)

