Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbaETRdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:33:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37528 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbaETRda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:33:30 -0400
Date: Tue, 20 May 2014 19:33:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Chen Yucong <slaoub@gmail.com>
Cc: tony.luck@intel.com, ak@linux.intel.com, ying.huang@intel.com,
        seto.hidetoshi@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org
Subject: Re: [PATCH v2] x86/mce: Distirbute the clear operation of mces_seen
 to Per-CPU rather than only monarch CPU
Message-ID: <20140520173308.GE16428@pd.tnic>
References: <1400551885-13828-1-git-send-email-slaoub@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1400551885-13828-1-git-send-email-slaoub@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 10:11:25AM +0800, Chen Yucong wrote:
> mces_seen is a Per-CPU variable which should only be accessed by
> Per-CPU as possible. So the clear operation of mces_seen should also
> be lcoal to Per-CPU rather than monarch CPU.
>
> Meanwhile, there is also a potential risk that mces_seen will not
> be be cleared if a timeout occors in mce_end for monarch CPU. As a
> reuslt, the stale value of mces_seen will reappear on the next mce.

I don't know how many times I have to tell you this already: if we reach
the timeout, we have a much bigger friggin' problem!

What you could do instead is make the machine panic in the tolerant==1,
i.e., the default case, in mce_timed_out().

Basically, in the case any core is stuck and we reach a timeout, we want
to panic the whole box immediately. There's a very little chance we can
recover so panic is the only sane thing left to do.

Ok?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
