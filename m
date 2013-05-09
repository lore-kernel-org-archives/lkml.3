Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab3EIMzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 08:55:38 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53609 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556Ab3EIMzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 08:55:37 -0400
Date: Thu, 9 May 2013 14:58:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123
 native_smp_send_reschedule
Message-ID: <20130509125859.GG27333@pd.tnic>
References: <alpine.LNX.2.00.1305091423460.23038@pobox.suse.cz>
 <20130509125040.GF27333@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130509125040.GF27333@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 02:50:40PM +0200, Borislav Petkov wrote:
> Looks like we're sending a resched IPI to a cpu which is not online
> yet in order to start the MCE polling timer. So the rcu* options are
> kinda unlikely to be related, AFAICT.

On a second thought, they must be somehow indirectly related because I
had "rcu_nocbs=4-7" on the command line and have the warning on the same
CPUs: 4 - 7.

Actually, NO_HZ_FULL_ALL makes all CPUs full dynticks so I'd guess the
RCU callback offloading happens on all of them, thus the warning can
happen on every CPU which is in full dynticks mode but not online yet.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
