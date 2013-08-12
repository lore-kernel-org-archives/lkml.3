Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab3HLNhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:37:08 -0400
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:52687 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab3HLNhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:37:05 -0400
Date: Mon, 12 Aug 2013 15:37:19 +0200
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: Borislav Petkov <bp@alien8.de>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] x86, AMD: simplify load_microcode_amd() to fix
 early microcode loading to no longer access uninitialized per-cpu data
Message-ID: <20130812153719.2b357d5d@fem.tu-ilmenau.de>
In-Reply-To: <20130808192943.GF27974@pd.tnic>
References: <20130723230610.73bd048d@googlemail.com>
	<20130724193250.GO30777@pd.tnic>
	<20130808192943.GF27974@pd.tnic>
X-Mailer: Claws Mail 3.9.2-dirty (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Aug 2013 21:29:43 +0200
Borislav Petkov <bp@alien8.de> wrote:

> On Wed, Jul 24, 2013 at 09:32:50PM +0200, Borislav Petkov wrote:
> > Btw, this patch is the one that fixes the boot issue on your box,
> > correct?
> >
> > If so, please put a minimal version of it in the next patch set
> > you're sending right after
> 
> Ok, I've wiggled it ontop of the cpu_has_amd_erratum() patch, see
> below. Can you guys - Torsten and Johannes - run this branch here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git amd-ucode
> 
> to check whether you can boot your boxes with he failing configs? I
> mean, I tried reproducing with your configs on my F10h box and no
> luck - box boots just fine. And it is affected by E400 so...
> 
> In any case, the two patches make sense regardless so if they fix your
> issues, I'd like to send them upwards soonish.
> 
> Thanks.

Just tested your amd-ucode branch with CONFIG_MICROCODE_AMD_EARLY
re-enabled and it works so far.
