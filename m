Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab3EPOPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 10:15:17 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44744 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992Ab3EPOPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 10:15:13 -0400
Date: Thu, 16 May 2013 16:15:05 +0200
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, jkosina@suse.cz, tony.luck@intel.com,
        prarit@redhat.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/urgent] tick: Don't invoke
 tick_nohz_stop_sched_tick( ) if the cpu is offline
Message-ID: <20130516141505.GF31373@pd.tnic>
References: <alpine.LFD.2.02.1305132138160.2863@ionos>
 <tip-f7ea0fd639c2c48d3c61b6eec75362be290c6874@git.kernel.org>
 <20130515194102.GE24004@somewhere>
 <alpine.LFD.2.02.1305161605080.1388@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1305161605080.1388@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 04:06:58PM +0200, Thomas Gleixner wrote:
> No, it's not about restarting the tick. It's about not falling into
> the nohz functions when the cpu is about to die. Just leave it alone,
> that's what the patch does.

Yep, this is how I saw it too: why even fiddle when the tick when we're
going offline anyway. We can look at the tick when we come back online
and enter idle.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
