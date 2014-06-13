Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaFMD2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 23:28:00 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:44506 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaFMD17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 23:27:59 -0400
Date: Fri, 13 Jun 2014 06:27:54 +0300
From: Dan Aloni <dan@kernelim.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: mm/sched/net: BUG when running simple code
Message-ID: <20140613032754.GA20729@gmail.com>
References: <539A6850.4090408@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539A6850.4090408@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 10:56:16PM -0400, Sasha Levin wrote:
> Hi all,
> 
> Okay, I'm really lost. I got the following when fuzzing, and can't really explain what's
> going on. It seems that we get a "unable to handle kernel paging request" when running
> rather simple code, and I can't figure out how it would cause it.
[..]
> Which agrees with the trace I got:
> 
> [  516.309720] BUG: unable to handle kernel paging request at ffffffffa0f12560
> [  516.309720] IP: netlink_getsockopt (net/netlink/af_netlink.c:2271)
[..]
> [  516.309720] RIP netlink_getsockopt (net/netlink/af_netlink.c:2271)
> [  516.309720]  RSP <ffff8803fc85fed8>
> [  516.309720] CR2: ffffffffa0f12560
> 
> They only theory I had so far is that netlink is a module, and has gone away while the code
> was executing, but netlink isn't a module on my kernel.

The RIP - 0xffffffffa0f12560 is in the range (from Documentation/x86/x86_64/mm.txt):

    ffffffffa0000000 - ffffffffff5fffff (=1525 MB) module mapping space

So seems it was in a module.

-- 
Dan Aloni
