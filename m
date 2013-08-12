Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab3HLRx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:53:57 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:45266 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316Ab3HLRxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:53:49 -0400
Message-ID: <5209212A.2030300@amacapital.net>
Date: Mon, 12 Aug 2013 10:53:46 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andreas Werner <wernerandy@gmx.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: question about ioremap_cache and PAT
References: <20130811165031.GA4439@thinkpad.fritz.box>
In-Reply-To: <20130811165031.GA4439@thinkpad.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2013 09:50 AM, Andreas Werner wrote:
> Hi i have a question about ioremap_cache and the resulting PAT attribute on X86 system. If I configure the mtrr to Write-Through for an adress range, and call ioremap_cache to map the mmio, the resulting PAT attribute is set to UC.
> If I check the Intel document IA-32 SDM vol 3a, the resulting PAT attribute should be WB.
> 
> I found the function pat_x_mtrr_type in arch/x86/mm/pat.c where the resulting attribute is returned. There will be always UC return expect if the MTRR is set to WB.
> 
> Why is there only WB or UC returned? In the Intel document there are a lot of combinations "allowed".
> 
> I need a Attribute of WT, so what i did is to modify the pat_x_mtrr_type function to return also WB if the MTRR is set to WT.   
> 
> Is this a solution to solve that or whats the reasion why the kernel doesn´t support this combination?

The kernel doesn't support it because I'm apparently the only person who
ever wanted it and I haven't implemented it yet.

This stuff is handled in hardware, so modifying the kernel's idea of
what hardware does won't do much.  Also, the kernel using MTRRs is on
its (very slow) way out.  You could probably hack something up, but I
can almost guarantee that hpa, etc won't accept the patches.

That being said, I'm planning to support WT directly using PAT in the
near future.  This will work on most recent cpus (there are errata that
will prevent use of the high PAT entries on some cpus).

What do you need WT for?  I want it for NVDIMMs, and all I need to get
started now is a heatsink*, so I'll hopefully start implementing this
stuff in the next week or so.

--Andy

* Damnit, Intel, it's not 2003 any more.  You already figured out that
heatsinks want screw holes.  But why couldn't you make sure that all
so-called "LGA 2011" sockets have the screw holes in the same place?


> 
> Best regards
> 
> B
> B
> B
> B
> B
> B
> B
> B
> B
> B
> B
> B
> B
> B
> B
> B
> B
> B
> A
> A
> A
> A
> A
> A
> A
> A
> A
> A
> A
> A
> A
> A
> A
> B
> B
> B
> Best regards
> 

