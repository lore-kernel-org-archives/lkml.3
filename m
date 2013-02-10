Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab3BJIgU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 03:36:20 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50662 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373Ab3BJIgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 03:36:19 -0500
Date: Sun, 10 Feb 2013 09:36:16 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 2/5 -v2.1] x86: Detect CPUID support early at boot
Message-ID: <20130210083616.GA4878@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
References: <20130209231351.GB5556@pd.tnic>
 <1360451762-10175-1-git-send-email-bp@alien8.de>
 <5117236D.5000607@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5117236D.5000607@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2013 at 08:34:53PM -0800, H. Peter Anvin wrote:
> I wouldn't really call it a "side effect". Perhaps the right thing
> here is to say something like "we want to start out with %eflags
> unambiguously clear".
>
> (Note also we have had to CLD earlier because we have already copied
> the command line.)

Ok, let's make it even more verbose so that people know in the future:

"... we want to start out with EFLAGS unambiguously clear. That means DF
in particular (even though we have cleared it earlier after copying the
command line) because GCC expects it."

How does that sound?

Also, I was wondering about the whole reasoning behind that: do you know
why DF=0 is a GCC requirement? I mean, nothing hurts GCC from issuing a
CLD each time?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
