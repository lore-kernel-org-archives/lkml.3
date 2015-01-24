Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417AbbAXHDz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 02:03:55 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:53918 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbbAXHDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 02:03:51 -0500
Date: Fri, 23 Jan 2015 23:03:41 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au, mhocko@suse.cz,
        Laura Abbott <lauraa@codeaurora.org>
Subject: mmotm 2015-01-23-16-19: build failures due to 'mm/page_alloc.c:
 don't offset memmap for flatmem'
Message-ID: <20150124070341.GA30638@roeck-us.net>
References: <54c2e51c.VbfIg4TfoWD0Qi0z%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54c2e51c.VbfIg4TfoWD0Qi0z%akpm@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.54C343D6.0088,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 04:19:40PM -0800, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2015-01-23-16-19 has been uploaded to
> 
>    http://www.ozlabs.org/~akpm/mmotm/
> 
New build failure:

mm/page_alloc.c: In function 'alloc_node_mem_map':
mm/page_alloc.c:4973: error: 'ARCH_PFN_OFFSET' undeclared (first use in this
function)
mm/page_alloc.c:4973: error: (Each undeclared identifier is reported only once
mm/page_alloc.c:4973: error: for each function it appears in.)
make[1]: *** [mm/page_alloc.o] Error 1

Culprit is c2ae2ed329 ("mm/page_alloc.c: don't offset memmap for flatmem").
While the code in question was already there, it is now also built if
CONFIG_FLATMEM is defined. Since the file defining ARCH_PFN_OFFSET
is not directly included, the build now fails for some architectures.

Affected:
	avr32:defconfig
	avr32:merisc_defconfig
	avr32:atngw100mkii_evklcd101_defconfig
	m68k:m5272c3_defconfig
	m68k:m5307c3_defconfig
	m68k:m5249evb_defconfig
	m68k:m5407c3_defconfig
	mn10300:asb2303_defconfig
	mn10300:asb2364_defconfig

Guenter
