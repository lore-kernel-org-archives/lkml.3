Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304Ab3ASFyM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 00:54:12 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:37234 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab3ASFyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 00:54:10 -0500
Subject: Re: splice() giving unexpected EOF in 3.7.3 and 3.8-rc4+
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Willy Tarreau <w@1wt.eu>
In-Reply-To: <20130119044957.GA25395@dcvr.yhbt.net>
References: <20130119044957.GA25395@dcvr.yhbt.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Jan 2013 21:54:07 -0800
Message-ID: <1358574847.3464.422.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-01-19 at 04:49 +0000, Eric Wong wrote:
> With the following flow, I'm sometimes getting an unexpected EOF on the
> pipe reader even though I never close the pipe writer:
> 
>   tcp_wr -write-> tcp_rd -splice-> pipe_wr -> pipe_rd -splice-> /dev/null
> 
> I encounter this in in 3.7.3, 3.8-rc3, and the latest from Linus
> 3.8-rc4+(5da1f88b8b727dc3a66c52d4513e871be6d43d19)
> 
> It takes longer (about 20s) to reproduce this issue on my KVM (2 cores)
> running the latest Linus kernel, so maybe real/faster hardware is needed.
> My dual-core laptop (on 3.7.3) which hosts the VM does encounter this
> issue within a few seconds (or even <1s).
> 
> Using schedtool to pin to a single core (any CPU core) on real hardware
> seems to avoid this issue on real hardware.  Not sure how KVM uses CPUs,
> but schedtool doesn't help inside my VM (not even schedtool on the KVM
> process).
> 
> Example code below (and via: git clone git://bogomips.org/spliceeof )
> 
> Expected outout from ./spliceeof:
> 	done writing
> 	splice(in) EOF (expected)
> 
> Output I get from ./spliceeof:
> 	splice(out) EOF (UNEXPECTED)
> 	in left: 47716 # the byte value varies
> 
> I've successfully run similar code within the past year on some 3.x
> kernels, so I think this issue is fairly recent (Cc-ing folks who
> have touched splice lately).
> 
> Any likely candidates before I start bisection?  Thanks for reading.
> 
> -------------------------------- 8< ------------------------------

Hmm, this might be already fixed in net-next tree, could you try it ?

Thanks !


