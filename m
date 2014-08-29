Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbaH2PWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 11:22:03 -0400
Received: from gw1.transmode.se ([195.58.98.146]:52437 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605AbaH2PV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 11:21:59 -0400
In-Reply-To: <20140829091324.D71E61ABD63@localhost.localdomain>
References: <20140829091324.D71E61ABD63@localhost.localdomain>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>, scottwood@freescale.com
MIME-Version: 1.0
Subject: Re: [PATCH v2 00/19] powerpc/8xx: Optimise MMU TLB handling and add support
 of 16k pages
X-KeepSent: 844FADBC:6B73E319-C1257D43:005106B8;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Message-ID: <OF844FADBC.6B73E319-ONC1257D43.005106B8-C1257D43.005467D6@transmode.se>
Date: Fri, 29 Aug 2014 17:21:55 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.3FP6|November 21, 2013) at
 29/08/2014 17:21:55,
	Serialize complete at 29/08/2014 17:21:55
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christophe Leroy <christophe.leroy@c-s.fr> wrote on 2014/08/29 11:13:24:
> 
> This patchset:
> 1) provides several MMU TLB handling optimisation on MPC8xx.
> 2) adds support of 16k pages on MPC8xx.
> All changes have been successfully tested on a custom board equipped 
with MPC885
> 
> The two differences with first version of the patch are:
> 1) I removed the patch number 10, which was implementing a 16 bit 
alignment of the
> PGDIR. It is not worth potentially wasting up to 64k of memory just for 
removing one
> instruction (ori).
> 2) I managed to preserve r11 while calculating the level 2 address, 
therefore
> no more need to save r11 into CR.
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> Tested-by: Christophe Leroy <christophe.leroy@c-s.fr>

This looks good but I need to look harder, some minor critique 
though(already sent)
 
As you are optimizing I think the impl.of powerpc/8xx: Invalidate non 
present TLBs 
in 2.4 is better than 3.x, compare:
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/arch/powerpc/mm/fault.c?id=5efab4a02c89c252fb4cce097aafde5f8208dbfe
with
https://git.kernel.org/cgit/linux/kernel/git/wtarreau/linux-2.4.git/commit/?id=da5c5609e86fb12061f2c05a6ddd80ffc46592b2


This will free the TLB before you jump to xxx_page_fault which might need 
a TLB before invalidation
and it isolates this 8xx quirk in 8xx specific code.

 Jocke
