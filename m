Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbaJHLWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 07:22:30 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40454 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755059AbaJHLW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 07:22:27 -0400
Date: Wed, 8 Oct 2014 12:21:55 +0100
From: Will Deacon <will.deacon@arm.com>
To: Arun Chandran <achandran@mvista.com>
Cc: Mark Rutland <Mark.Rutland@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH v1] Arm64: ASLR: fix text randomization
Message-ID: <20141008112154.GF26140@arm.com>
References: <1412685628-27178-1-git-send-email-achandran@mvista.com>
 <20141007134349.GR24725@leverpostej>
 <CAFdej01hex6aeNNjdA1uDodEQ-d=JhsoqFJHkPvnKY+xbzZmxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFdej01hex6aeNNjdA1uDodEQ-d=JhsoqFJHkPvnKY+xbzZmxw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 07:51:54AM +0100, Arun Chandran wrote:
> On Tue, Oct 7, 2014 at 7:13 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> > I wasn't able to spot where the randomness came from in the
> > ARCH_BINFMT_ELF_RANDOMIZE_PIE case, so it's not clear to me if the
> > generic implementation behaves identically other than disabling
> > randomization when told to via proc.
> 
> I also don't know from where it is coming; but it works on arm and x86 :)

The randomness will come from elf_map, since that will descend into the mmap
code and end up with a randomised base address (see mmap_base and
arch_pick_mmap_layout).

Will
