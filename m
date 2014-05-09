Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbaEIKjt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:39:49 -0400
Received: from mail.anarazel.de ([217.115.131.40]:59202 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224AbaEIKjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:39:48 -0400
Date: Fri, 9 May 2014 12:39:42 +0200
From: Andres Freund <andres@anarazel.de>
To: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@suse.de>, x86@kernel.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] x86: Fix typo preventing msr_set/clear_bit from
 having an effect
Message-ID: <20140509103942.GA30231@awork2.anarazel.de>
References: <1399598957-7011-1-git-send-email-andres@anarazel.de>
 <1399598957-7011-2-git-send-email-andres@anarazel.de>
 <20140509075452.GA16058@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140509075452.GA16058@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 2014-05-09 09:54:52 +0200, Borislav Petkov wrote:
> On Fri, May 09, 2014 at 03:29:16AM +0200, Andres Freund wrote:
> > Due to a typo the msr accessor function introduced in
> > 22085a66c2fab6cf9b9393c056a3600a6b4735de didn't have any lasting
> > effects because they accidentally wrote the old value back.
> > 
> > After c0a639ad0bc6b178b46996bd1f821a04643e2bde this at the very least
> > this causes cpuid limits not to be lifted on some cpus leading to
> > missing capabilities for those.
> > 
> > Signed-off-by: Andres Freund <andres@anarazel.de>
> > Cc: Borislav Petkov <bp@suse.de>
> > Cc: H. Peter Anvin <hpa@linux.intel.com>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > ---
> >  arch/x86/lib/msr.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> Good catch, thanks, and sorry about the screwup! :-[
> 
> Acked-by: Borislav Petkov <bp@suse.de>

It got caught before the release, so all is well... Actually rather
surprised it only causes relatively minor problems; i.e. still boots.

Did I CC the correct people for this to get picked up for 3.15 or to I
need to do anything else?

Greetings,

Andres Freund
