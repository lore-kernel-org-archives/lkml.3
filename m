Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbaCLFDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 01:03:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46557 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbaCLFDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 01:03:35 -0400
Message-ID: <531FEA69.7050107@zytor.com>
Date: Tue, 11 Mar 2014 22:02:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org
CC: Stefani Seibold <stefani@seibold.net>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2 0/2] x86: Relocate the compat vdso per process
References: <cover.1394575968.git.luto@amacapital.net>
In-Reply-To: <cover.1394575968.git.luto@amacapital.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 03:15 PM, Andy Lutomirski wrote:
> The meat of this patch series is in patch 1.  Patch 2 is split out for
> improved bisectability.
>
> Changes from v1: Split into two patches and fixed a comment.
>
> Andy Lutomirski (2):
>    x86: Dynamically relocate the compat vdso
>    x86_32: Remove user bit from identity map PDE
>
>   Documentation/kernel-parameters.txt  |  18 +++-
>   arch/x86/Kconfig                     |  24 +++--
>   arch/x86/include/asm/elf.h           |   4 -
>   arch/x86/include/asm/fixmap.h        |   8 --
>   arch/x86/include/asm/pgtable_types.h |   7 +-
>   arch/x86/include/asm/vdso.h          |   5 +-
>   arch/x86/vdso/vdso-layout.lds.S      |   2 +-
>   arch/x86/vdso/vdso32-setup.c         | 173 ++++++++++++++++-------------------
>   arch/x86/vdso/vdso32/vdso32.lds.S    |   2 -
>   9 files changed, 111 insertions(+), 132 deletions(-)
>

Why per process?  *If* we have compat vdso turned on, can't we just put 
it in one place system-wide?

	-hpa

