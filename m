Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbaDVOrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:47:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43419 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbaDVOrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:47:05 -0400
Date: Tue, 22 Apr 2014 16:46:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andrew Lutomirski <amluto@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
Message-ID: <20140422144659.GF15882@pd.tnic>
References: <CAObL_7EJi5+m-oDXRy4hu+-OTZ=9wZ9WEivTMsdDtccU00wfWA@mail.gmail.com>
 <5355A9E9.9070102@zytor.com>
 <CAObL_7EP+zPpx9TVgsSu2iFN+r0U8yy6UEZtdk=CPwowXUu=Qw@mail.gmail.com>
 <1dbe8155-58da-45c2-9dc0-d9f4b5a6e643@email.android.com>
 <CAObL_7FUDpV9md+UnDbXxWw=trrXLFLNNJMNegdezrQt7rm6TA@mail.gmail.com>
 <a035392c-f332-4b3f-b851-13b0c7a0fc68@email.android.com>
 <CAObL_7FMX9yaGVi19pVwsU5VwHqKLLWMEB7kwDF-fatsGnHvdQ@mail.gmail.com>
 <ee12ff5e-91fe-487b-bed9-4472f15f94fe@email.android.com>
 <CAObL_7HTDvN2zu2_CDnVR_ztZ-b7PfLYz0csuVX-ShQ7EHGEjg@mail.gmail.com>
 <20140422112312.GB15882@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140422112312.GB15882@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 01:23:12PM +0200, Borislav Petkov wrote:
> I wonder if it would be workable to use a bit in the espfix PGD to
> denote that it has been initialized already... I hear, near NX there's
> some room :-)

Ok, I realized this won't work when I hit send... Oh well.

Anyway, another dumb idea: have we considered making this lazy? I.e.,
preallocate pages to fit the stack of NR_CPUS after smp init is done but
not setup the percpu espfix stack. Only do that in espfix_fix_stack the
first time we land there and haven't been setup yet on this cpu.

This should cover the 1% out there who still use 16-bit segments and the
rest simply doesn't use it and get to save themselves the PT-walk in
start_secondary().

Hmmm...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
