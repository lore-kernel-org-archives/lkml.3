Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab3GWBYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 21:24:31 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:42899 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab3GWBYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 21:24:30 -0400
Message-ID: <51EDDB4B.6030609@hitachi.com>
Date: Tue, 23 Jul 2013 10:24:27 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>, x86@kernel.org
Subject: Re: Re: [PATCH -tip/x86/jumplabel] x86: call out into int3 handler
 directly instead of using notifier
References: <20130720131226.GA13893@localhost> <alpine.LNX.2.00.1307221307280.23128@pobox.suse.cz> <51ED9BC0.6020206@linux.intel.com> <alpine.LNX.2.00.1307222256120.14024@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1307222256120.14024@pobox.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/23 6:00), Jiri Kosina wrote:
> On Mon, 22 Jul 2013, H. Peter Anvin wrote:
> 
>>  What is the baseline for this patch?
> 
> Hi!
> 
> it's x86/jumplabel branch, as a followup to commit 
> fd4363fff3d96 ("x86: Introduce int3 (breakpoint)-based instruction 
> patching") sitting there.

AFAICS, tip/master already merged Jiri's works on tip/x86/jumplabel.
Thus both branches need this. (especially, since this is actual
bugfix, it should go into tip/master.)


> This branch however seems to be broken by Ingo's mismerge; this e-mail 
> from earlier today:
> 
> 	https://lkml.org/lkml/2013/7/22/147
> 
> implied that he fixed this ("all is fine"), however x86/jumplabel still 
> contains just 3/3 of Masami's series, and therefore is broken; 3/3 is not 
> enough, it needs also
> 
> 	kprobes/x86: Remove an incorrect comment about int3 in NMI/MCE
> 	kprobes/x86: Use text_poke_bp() instead of text_poke_smp*()
> 
> included or
> 
> 	kprobes/x86: Remove unused text_poke_smp() and text_poke_smp_batch() functions
> 
> dropped to be in consistent state again.

I hope to pull entire of this series in :)

> 
> I pinged Ingo about this:
> 
> 	https://lkml.org/lkml/2013/7/22/281
> 
> but the branch still seems to be in an odd state, containing last patch of 
> Masami's series.
> 
> Thanks in advance for fixing this and applying mi fix as well,	
> 

Thanks!

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


