Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab3DYIPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 04:15:01 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:43023 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab3DYIO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 04:14:58 -0400
Date: Thu, 25 Apr 2013 10:14:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: [PATCH] x86, efi: Fix a build warning
Message-ID: <20130425081454.GA13818@gmail.com>
References: <1366798154-1380-1-git-send-email-bp@alien8.de>
 <20130424105610.GA15815@gmail.com>
 <5177BF67.2040308@intel.com>
 <20130425065529.GD7806@gmail.com>
 <5178D8E9.7020102@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5178D8E9.7020102@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Fleming <matt.fleming@intel.com> wrote:

> On 25/04/13 07:55, Ingo Molnar wrote:
> > It's a basic cleanliness and robustness issue: we generally avoid type 
> > casts in the kernel, because type casts override compile-time type checks 
> > and are easy to get wrong. They are also ugly.
> > 
> > So in generaly we try to use the right type for the data structure, which 
> > matches its usage (and standardize functions/methods around that type) - 
> > then no cast is needed.
> 
> Yeah, I'm not advocating using casts, I was just saying "Oh, x86-64
> avoids requiring the caller of efi_call_phys* to perform the cast by
> doing it in the definition of efi_call*. That's why this is only
> affecting 32-bit."
> 
> Cleaning this up would be nice. I think at this point, I'll apply
> Borislav's patch, and fix all this casting after v3.9 is released, since
> instead of just changing query_variable_info, we might as well change
> everything in efi_runtime_service_t so that it's consistent.

Sounds fine to me.

Thanks,

	Ingo
