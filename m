Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbaJYVb3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 17:31:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:51238 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbaJYVb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 17:31:28 -0400
Date: Sat, 25 Oct 2014 23:31:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@alien8.de>
cc: Andy Lutomirski <luto@amacapital.net>, Ben Harris <bjh21@bjh21.me.uk>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Don't allow stackprotector without TSC
In-Reply-To: <20141024120323.GA30459@pd.tnic>
Message-ID: <alpine.DEB.2.11.1410252327310.5308@nanos>
References: <alpine.DEB.2.10.1410232227580.28125@snap.ds.cam.ac.uk> <54499287.5070803@amacapital.net> <20141024120323.GA30459@pd.tnic>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2014, Borislav Petkov wrote:
> On Thu, Oct 23, 2014 at 04:43:03PM -0700, Andy Lutomirski wrote:
> > Presumably the actual failure is a #GP when trying to do the rdtsc. If
> > so, wouldn't a better fix be to make that rdtsc check cpuid first? Can
> > we easily check cpuid that early?
> 
> I don't see why not.
> 
> The real question, though is, can we have a fallback for RDTSC on those
> machines so that they don't have to disable stack protector in order to
> boot.

The simple solution is to make the rdtsc conditional on the
availability of the feature flag, which is going to be not set on
these kind of machines.

So for the non TSC case we can either leave the extra randomness alone
or readout PIT, which is available and better than nothing.

Thanks,

	tglx
