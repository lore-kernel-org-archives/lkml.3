Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbaD2Drf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 23:47:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:4553 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441AbaD2Dre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 23:47:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,948,1389772800"; 
   d="scan'208";a="502660947"
Message-ID: <535F20D3.1050407@linux.intel.com>
Date: Mon, 28 Apr 2014 20:47:31 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Andrew Lutomirski <amluto@gmail.com>
CC: comex <comexk@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <1398120472-6190-1-git-send-email-hpa@linux.intel.com> <CAPM5UJ1DYxhGASFVTg_2eUDpg1-whe-26mJ9BD+PB=4FM+540g@mail.gmail.com> <CAObL_7G06PYn=8LGQT69-qhvyWFm_mJYMkbsuwem0PeiLRe0HQ@mail.gmail.com> <535EDEC5.7030209@zytor.com> <535EDF67.3090501@linux.intel.com> <CAObL_7HVOjpgp0=Ot9ih2tb6x7xv6MGstu-Krad+rrO4cVqyTg@mail.gmail.com> <CAObL_7FZRji6ivcVvTQ4r=KULCA760fr_wKqkjaYKGL=KLOQRA@mail.gmail.com> <535F108C.9010001@linux.intel.com> <535F205F.9040101@zytor.com>
In-Reply-To: <535F205F.9040101@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2014 08:45 PM, H. Peter Anvin wrote:
> 
> OK, so I found a bug in ldttest.c -- it sets CS to an LDT segment, but
> it never sets SS to an LDT segment.  This means that it should really
> have zero footprint versus the espfix code, and implies that we instead
> have another bug involved.  Why the espfix code should have any effect
> whatsoever is a mystery, however... if it indeed does?
> 
> I have uploaded a fixed ldttest.c, but it seems we might be chasing more
> than that...
> 

In particular, I was already wondered how we avoid an "upside down
swapgs" with a #GP on IRET.  The answer might be that we don't...

	-hpa


