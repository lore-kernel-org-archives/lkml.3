Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbaA2SWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 13:22:52 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:41988 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbaA2SWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 13:22:50 -0500
Date: Wed, 29 Jan 2014 13:22:47 -0500
From: Tejun Heo <tj@kernel.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: kernfs: lockdep complains about kernfs_addrm_ctx
Message-ID: <20140129182247.GN30842@htj.dyndns.org>
References: <alpine.LNX.2.00.1401221456080.27143@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1401221456080.27143@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jiri.

On Wed, Jan 22, 2014 at 03:01:38PM +0100, Jiri Kosina wrote:
> booting with current Linus' tree (df32e43a5) gives me this:
> 
>  INFO: trying to register non-static key.
>  the code is fine but needs lockdep annotation.
>  turning off the locking correctness validator.
>  CPU: 1 PID: 105 Comm: udevd Not tainted 3.13.0-03477-gdf32e43 #1
>  Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
>   0000000000000000 ffff880037ad3468 ffffffff8159701b ffff880037ad34e8
>   ffffffff8109e317 0000000000000000 ffff880037ad4fd0 ffff880037ad34e8
>   0000000000000000 ffff880037ad34b8 ffffffff00000000 0000000000000002
>  Call Trace:
>   [<ffffffff8159701b>] dump_stack+0x72/0x87
>   [<ffffffff8109e317>] register_lock_class+0x497/0x4c0
>   [<ffffffff810a1c2d>] __lock_acquire+0x7d/0x600
>   [<ffffffff810a0cdd>] ? trace_hardirqs_on_caller+0x13d/0x1e0
>   [<ffffffff810a22a1>] lock_acquire+0xf1/0x120
>   [<ffffffff81215460>] ? kernfs_addrm_finish+0x30/0x50
>   [<ffffffff81214cf9>] kernfs_deactivate+0xe9/0x130
...
> 
> I have started to look into the kernfs code now to debug this, but as I 
> haven't been following it closely during the review phase, it might take 
> some time before I familiarize myself with it; hence sending this as a 
> heads-up.

Oops, this got reported again and the fix patch has been posted
earlier today.

 http://lkml.kernel.org/g/<20140129170403.GJ30842@htj.dyndns.org>

Can you please see whether the above patch fixes the issue?

Thanks.

-- 
tejun
