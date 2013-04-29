Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228Ab3D2R5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 13:57:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:16018 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757302Ab3D2R5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 13:57:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,575,1363158000"; 
   d="scan'208";a="234389181"
From: Andi Kleen <andi@firstfloor.org>
To: "Warlich\, Christof" <christof.warlich@siemens.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: X86 fpu registers in a signal handler's ucontext
References: <6D83E89737156549AEA25EF9ED712C5DDEF7@DEFTHW99EK1MSX.ww902.siemens.net>
Date: Mon, 29 Apr 2013 10:57:34 -0700
In-Reply-To: <6D83E89737156549AEA25EF9ED712C5DDEF7@DEFTHW99EK1MSX.ww902.siemens.net>
	(Christof Warlich's message of "Mon, 29 Apr 2013 14:34:41 +0000")
Message-ID: <m2a9ohusmp.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Warlich, Christof" <christof.warlich@siemens.com> writes:
>
> First, this link:
> http://valgrind.10908.n7.nabble.com/need-FPU-and-SSE-state-in-sigcontext-ucontext-td19844.html
> suggests that unlike the GPRs, the FP registers are _not_ restored after
> returnung from the signal handler. 

The FP registers are restored lazily, but the state for this is kept in
the kernel.

One easy way may be to catch the FPU exception too and clear from there?

There can be some complications with different save formats too (XSAVE
vs FXSAVE). So your solution may not be necessarily 100% portable
to all systems.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
