Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbaESSPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 14:15:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40421 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbaESSPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 14:15:44 -0400
Date: Mon, 19 May 2014 20:15:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Chen Yucong <slaoub@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Subject: Re: [PATCH] x86/mce: Clear a useless global variable in mce.c
Message-ID: <20140519181524.GC6311@pd.tnic>
References: <1400328343-6483-1-git-send-email-slaoub@gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3280E51C@ORSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3280E51C@ORSMSX114.amr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 05:59:23PM +0000, Luck, Tony wrote:
> -	atomic_inc(&mce_entry);
> -
> 
> I have used this in the past (in conjunction with an external debugger) to
> diagnose problems (not all cpus showing up in the machine check handler).
> 
> But I suppose these can also be diagnosed from the "Timeout synchronizing ..."
> message from mce_timed_out() [though with a bit less precision ... we know
> that some cpus didn't show up, but we don't have a count of how many did,
> or how many are missing.
> 
> If we print the value of "mce_callin" somewhere in mce_timed_out() ...
> then I think we'd have equivalent functionality (in fact better - because
> we don't need the external debugger to peek at mce_entry).

Right, I was thinking about it and this is something maybe you guys
should decide: do we want to panic by default in mce_timed_out if some
cores didn't show up?

I'm looking at this snippet:

                /* CHECKME: Make panic default for 1 too? */
                if (mca_cfg.tolerant < 1)
                        mce_panic("Timeout synchronizing machine check over CPUs",
                                  NULL, NULL);

and since we have .tolerant=1 by default...

I mean, does the machine even recover after some of the cores have gone
into the weeds in #MC? Provided, of course, we don't have a no-way-out
MCE and we can resume execution.

Or is the box so hammered that there's no turning back?

Concerning mce_entry, I don't care all that much - if it is really
useful, you might slap a comment saying so and keep it, for all I care.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
