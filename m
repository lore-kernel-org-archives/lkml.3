Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbaDWMSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:18:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:59774 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbaDWMSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:18:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: James Hogan <james.hogan@imgtec.com>
Subject: Re: [RFC 3/3] asm-generic: Drop renameat syscall from default list
Date: Wed, 23 Apr 2014 14:18:04 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vineet Gupta <vgupta@synopsys.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, linux-c6x-dev@linux-c6x.org,
        Richard Kuo <rkuo@codeaurora.org>, linux-hexagon@vger.kernel.org,
        linux-metag@vger.kernel.org, Jonas Bonn <jonas@southpole.se>,
        linux@openrisc.net, Chen Liqin <liqin.linux@gmail.com>,
        Lennox Wu <lennox.wu@gmail.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
References: <1398247687-13453-1-git-send-email-james.hogan@imgtec.com> <1398247687-13453-4-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1398247687-13453-4-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201404231418.05174.arnd@arndb.de>
X-Provags-ID: V02:K0:iQ6iVNTDDVWhVCxee2E+xHnfPwx8sQzvbinRcPwqKwI
 cqEvTuONroj6fRwhPR2EvRUeW8SrMY4/oMf4T1B9rVzEsvXnGy
 ZwyCfqfFasvj+FgLTNcgVoxZOchtikU2wWYlZ+1l1EdiUUbiMo
 yyBl7AAeBvzSPXdWJ2Mr78/2YvxS6PSAB4j1USjIZeQ+cf3y6y
 J8eQJPQXiJyGCxRDDC2bBv+yvvRNgQk3VsRgSLMJ5MmH/etvnv
 ZhmbIScV6Z8IuUWmpf6oKSpduVz4p+sRAaP28jdNr2AXaxNyqP
 ftXdc9SisncaOvIGXmwbMybETA0vNXt5H51OgjODqG4NWwWYlz
 uhHW7biUlS7lhpt9Ao1A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 April 2014, James Hogan wrote:
> The new renameat2 syscall provides all the functionality provided by the
> renameat syscall and adds flags, so future architectures won't need to
> include renameat.
> 
> Therefore drop the renameat syscall from the generic syscall list unless
> __ARCH_WANT_RENAMEAT is defined by the architecture's unistd.h prior to
> including asm-generic/unistd.h, and adjust all architectures using the
> generic syscall list to define it so that no in-tree architectures are
> affected.

I should have read this one before replying to patch 2 ;-)

> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-arch@vger.kernel.org
> Cc: Vineet Gupta <vgupta@synopsys.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Mark Salter <msalter@redhat.com>
> Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
> Cc: linux-c6x-dev@linux-c6x.org
> Cc: Richard Kuo <rkuo@codeaurora.org>
> Cc: linux-hexagon@vger.kernel.org
> Cc: linux-metag@vger.kernel.org
> Cc: Jonas Bonn <jonas@southpole.se>
> Cc: linux@lists.openrisc.net
> Cc: Chen Liqin <liqin.linux@gmail.com>
> Cc: Lennox Wu <lennox.wu@gmail.com>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> ---
> Is this the approach we want to take to keep the default syscall list
> minimal? We could for example have made renameat2 use the renameat
> syscall number for new arches, but it seemed best to leave a gap for new
> arches to improve consistency of numbering.

I think leaving the hole is best.

> This patch is a no-op for arches in tree, so there's no harm for this to
> wait for the v3.16 merge window.

Sounds good. I guess I'll have to put this into my asm-generic tree
then, unless I can get the nios2 maintainers to pick it up.

If you don't mind, can you submit the first two patches to Linus
directly?

	Arnd
