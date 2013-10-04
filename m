Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab3JDI3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 04:29:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:63184 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab3JDI3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 04:29:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1031,1371106800"; 
   d="scan'208";a="405201491"
Date: Fri, 4 Oct 2013 16:28:47 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [GIT PULL] x86/asmlinkage changes for v3.12
Message-ID: <20131004082847.GA30635@localhost>
References: <20130903143921.GA28290@gmail.com>
 <CA+55aFxVv==DC0JdS87V+cPr-twN+TujYg5XmgHOjJOAkZ4xwQ@mail.gmail.com>
 <522763A9.8080708@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522763A9.8080708@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 09:45:29AM -0700, H. Peter Anvin wrote:
[snip]
> This also exposes an interesting problem with Fengguang's build robot.
> 
> One build:
> [tip:x86/asmlinkage] 28596b6a8779b736829ad837f95fdc2e81bdd1ee BUILD DONE
> 28596b6a8779b736829ad837f95fdc2e81bdd1ee  x86, asmlinkage, vdso: Mark
> vdso variables __visible
> 
> ... flags the warnings.  The next build for the branch looks clean:
> [tip:x86/asmlinkage] eb86b5fd505cb97743d84226140cf247d91a2f03 BUILD SUCCESS
> eb86b5fd505cb97743d84226140cf247d91a2f03  x86/asmlinkage: Fix warning in
> xen asmlinkage change
> 
> ("DONE" means warnings or errors.)
> 
> A human observer would assume that the problem was fixed, since the
> patch says "fix warnings", but the problem is that it didn't actually
> fix *all* the warnings.  However, the bot has flagged the warnings as
> preexisting from the previous build, and thus no new warnings were
> introduced.

Yeah sorry! The build robot silently ignored any reported errors,
which is not the expected behavior when sending BUILD SUCCESS notifications.

> It would be better if the bot reported any warnings not present in upstream.

I've fixed the robot to remember which tree/branch first introduced
the build error/warning. If the problem still remains in that branch's
new HEAD, the robot will be able to send out BUILD DONE reports which
will include the old error/warning message in the email body.

Sorry for the delay! This feature was added shortly after your report,
however took long time to confirm that it actually works.

Thanks,
Fengguang
