Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbaLQQzD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 11:55:03 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:36325 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751136AbaLQQy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 11:54:58 -0500
Date: Wed, 17 Dec 2014 16:54:50 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org
Subject: Re: [PATCH] arm/rpc: avoid static keyword removal via define
Message-ID: <20141217165450.GW11285@n2100.arm.linux.org.uk>
References: <1418633287-5019-1-git-send-email-borntraeger@de.ibm.com>
 <1418633287-5019-2-git-send-email-borntraeger@de.ibm.com>
 <5490146A.3000408@de.ibm.com>
 <20141216114056.GP11285@n2100.arm.linux.org.uk>
 <5491A16A.7050101@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5491A16A.7050101@de.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 04:29:46PM +0100, Christian Borntraeger wrote:
> Am 16.12.2014 um 12:40 schrieb Russell King - ARM Linux:
> > On Tue, Dec 16, 2014 at 12:15:54PM +0100, Christian Borntraeger wrote:
> >> Am 15.12.2014 um 09:48 schrieb Christian Borntraeger:
> >>> commit 4486b86368d7 ("[ARM] riscpc: fix decompressor font file handling")
> >>> introduced Makefile magic to avoid building a file two times. Using
> >>> -Dstatic= does break some assumptions on compiler.h that were introduced
> >>> for READ_ONCE.
> >>>
> >>> Lets just use sed on the copy instead of using a define.
> >>>
> >>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> >>> Cc: Russell King <linux@arm.linux.org.uk>
> >>
> >> This fixed the linux-next build http://kisskb.ellerman.id.au/kisskb/target/1508/
> >> Unless anybody complains, I will send the pull request for the access_once tree tomorrow and I have this patch applied on top.
> > 
> > Please give me some time to look at this.
> 
> >From all builds, the only problematic case was the rpc_defconfig.
> So only CONFIG_ARCH_ACORN is affected.
> 
> As I said, I want to send this series this merge window, so if you
> do not find the time to look into this before rc1, what about removing
> this patch from my queue and we solve this later? 
> Acorn Risc CPU is probably not the hottest platform right now, so if we 
> fix this in rc2 or rc3 this might be ok - I guess.

How does compiler.h get included when building font.o?

Since I haven't seen your patch series, I guess it gets included somehow
via linux/types.h ?

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
