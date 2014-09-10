Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbaIJVWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 17:22:00 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:34857 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbaIJVV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 17:21:59 -0400
Message-ID: <1410383484.28990.303.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2 2/6] x86, mm, pat: Change reserve_memtype() to handle
 WT
From: Toshi Kani <toshi.kani@hp.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Yigal Korman <yigal@plexistor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 10 Sep 2014 15:11:24 -0600
In-Reply-To: <CALCETrUz016rDogLFTVETLh7ybVjgOMOhkL5kF2wJTLUF041xQ@mail.gmail.com>
References: <1410367910-6026-1-git-send-email-toshi.kani@hp.com>
	 <1410367910-6026-3-git-send-email-toshi.kani@hp.com>
	 <CALCETrXRjU3HvHogpm5eKB3Cogr5QHUvE67JOFGbOmygKYEGyA@mail.gmail.com>
	 <1410377428.28990.260.camel@misato.fc.hp.com> <5410B10A.4030207@zytor.com>
	 <1410381050.28990.295.camel@misato.fc.hp.com>
	 <CALCETrUz016rDogLFTVETLh7ybVjgOMOhkL5kF2wJTLUF041xQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-10 at 14:06 -0700, Andy Lutomirski wrote:
> On Wed, Sep 10, 2014 at 1:30 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> > On Wed, 2014-09-10 at 13:14 -0700, H. Peter Anvin wrote:
> >> On 09/10/2014 12:30 PM, Toshi Kani wrote:
> >> >
> >> > When WT is unavailable due to the PAT errata, it does not fail but gets
> >> > redirected to UC-.  Similarly, when PAT is disabled, WT gets redirected
> >> > to UC- as well.
> >> >
> >>
> >> But on pre-PAT hardware you can still do WT.
> >
> > Yes, if we manipulates the bits directly, but such code is no longer
> > allowed for PAT systems.  The PAT-based kernel interfaces won't work for
> > pre-PAT systems, and therefore requests are redirected to UC- on such
> > systems.
> >
> 
> Right, the PWT bit.  Forgot about that.
> 
> I wonder whether it would make sense to do some followup patches to
> replace the current support for non-PAT machines with a "PAT" and
> corresponding reverse map that exactly matches the mapping when PAT is
> disabled.  These patches are almost there.

That's possible, but the only benefit is that we can enable WT on
pre-PAT systems, which I do not think anyone cares now...  WB & UC work
on pre-PAT systems.  WC & WT need PAT.  I think this requirement is
reasonable.

Thanks,
-Toshi

