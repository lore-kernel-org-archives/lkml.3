Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176Ab3FMSb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:31:29 -0400
Received: from blackhole.sdinet.de ([176.9.52.58]:56463 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759165Ab3FMSb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:31:27 -0400
Date: Thu, 13 Jun 2013 20:31:08 +0200 (CEST)
From: Sven-Haegar Koch <haegar@sdinet.de>
To: Willy Tarreau <w@1wt.eu>
cc: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Linux 2.6.32.61 - x86/ptrace/gcc 4.7 build error
In-Reply-To: <20130613175330.GC27760@1wt.eu>
Message-ID: <alpine.DEB.2.10.1306132028230.24569@aurora.sdinet.de>
References: <20130610101557.GA3235@1wt.eu> <alpine.DEB.2.10.1306101708360.1713@aurora64.sdinet.de> <20130613175330.GC27760@1wt.eu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jun 2013, Willy Tarreau wrote:

> Sven-Haegar, Christoph,
> 
> concerning the issue below, I could reproduce both Sven-Haegar's error (running
> make headers_check with the patch applied) and Christoph's build error with gcc
> 4.7 on i686 without the patch.
> 
> I noticed that neither syscall_trace_enter() nor syscall_trace_leave() were
> called from C code, all were from pure asm. So I simply reverted the first
> patch then removed the two function prototypes and everything is OK for me
> now using gcc 4.7, i686 and x86_64.
> 
> I'm attaching the two patches here to be appled on top of 2.6.32.61, I would
> like it if you could try in your environment to confirm that they correctly
> fix the issue.

hello Willy,

With your two new patches applied on top I was able to build my kernel 
package both using gcc 4.7 (Debian Wheezy) and gcc 4.4 (Debian Squeeze).

(But I did not try rebooting the server yet)

Thanks for the fix!
Haegar

-- 
Three may keep a secret, if two of them are dead.
- Ben F.
