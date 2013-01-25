Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab3AYIHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:07:05 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:63357 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab3AYIHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:07:00 -0500
Date: Fri, 25 Jan 2013 09:06:56 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Paul Turner <pjt@google.com>
Cc: Fabio Estevam <festevam@gmail.com>, mingo@redhat.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH v2] sched: Fix print format for u64
Message-ID: <20130125080656.GB25314@gmail.com>
References: <1356434680-10045-1-git-send-email-festevam@gmail.com>
 <CAOMZO5AzJUvrc5LcNyqPbEz0g4U5KZAXrNK8oJUiht=fdyuc5g@mail.gmail.com>
 <20130124141930.GA14881@gmail.com>
 <CAOMZO5CC76Md9T=2z3RWi4GrKsUuFcc8VYV1QfmZWF41vnOhVw@mail.gmail.com>
 <20130125071933.GA17846@gmail.com>
 <CAPM31RKPZeNhUx5OCzE2+Rr=5qSL72=tgRpacZwFos9p-cajAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM31RKPZeNhUx5OCzE2+Rr=5qSL72=tgRpacZwFos9p-cajAg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Turner <pjt@google.com> wrote:

> On Thu, Jan 24, 2013 at 11:19 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Fabio Estevam <festevam@gmail.com> wrote:
> >
> >> On Thu, Jan 24, 2013 at 12:19 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >>
> >> > I suppose - is this patch warning-free both on 64-bit and 32-bit
> >> > systems?
> >>
> >> Yes, just confirmed that this patch is warning-free on both 64-bit and
> >> 32-bit machines.
> >
> > Apparently it's not all good, see the warning attached below.
> 
> Yeah this patch is broken; this is not properly fixable as is without
> #ifdefs (or fixing the insanity that is atomic64_read).
> 
> Specifically:
> 
> On some architectures (e.g. x86_64) atomic64_read is typed long
> On some others (e.g. x86-32) it's typed long long
> On yet others (e.g. arm) it's typed u64

Hm, cannot we type atomic64_read() to u64 on x86-64 as well, and 
fix other architectures? How widespread is this problem, have 
you checked that perhaps?

I'm all for clean, consistent types instead of #ifdef or 
temporary variable uglies.

Thanks,

	Ingo
