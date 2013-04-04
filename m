Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762389Ab3DDP3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 11:29:12 -0400
Received: from mail.abilis.ch ([195.70.19.74]:27659 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762305Ab3DDP3J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 11:29:09 -0400
Date: Thu, 4 Apr 2013 17:28:10 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: tglx@linutronix.de, Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        Robert Love <rml@tech9.net>, kpreempt-tech@lists.sourceforge.net,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [PATCH] Gaurantee spinlocks implicit barrier for
 !PREEMPT_COUNT
Message-ID: <20130404152808.GB15261@ab42.lan>
References: <alpine.LFD.2.02.1304031433350.21884@ionos>
 <1364998282-21437-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1364998282-21437-1-git-send-email-vgupta@synopsys.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vineet,

Our stress testing campaign has just successfully completed on this
patch. It seems to solve several issues we have seen in unpatched
versions, amongst others the original timer issue, a crash in hrtimer
rb-tree manipulation etc.

Greetings,
  Christian

On Wed, Apr 03, 2013 at 07:41:22PM +0530, Vineet Gupta wrote:
> spinlocks built in a !PREEMPT_COUNT config don't have the compiler
> barrier provided by preempt_* routines. This can break lot of code which
> relies on barrier semantics.
> 
> This manifested as random crashes in timer code when stress testing
> ARC Linux (3.9-rc3): !SMP && !PREEMPT_COUNT
> 
> [...]
> 
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> Reported-by: Christian Ruppert <christian.ruppert@abilis.com>
Tested-by: Christian Ruppert <christian.ruppert@abilis.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Christian Ruppert <christian.ruppert@abilis.com>
> Cc: Pierrick Hascoet <pierrick.hascoet@abilis.com>
> Cc: Robert Love <rml@tech9.net>
> Cc: kpreempt-tech@lists.sourceforge.net
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <srostedt@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: linux-kernel@vger.kernel.org
> [...]
-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
