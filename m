Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab3DYHTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 03:19:11 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:32845 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab3DYHTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 03:19:09 -0400
Message-ID: <5178D8E9.7020102@intel.com>
Date: Thu, 25 Apr 2013 08:19:05 +0100
From: Matt Fleming <matt.fleming@intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: [PATCH] x86, efi: Fix a build warning
References: <1366798154-1380-1-git-send-email-bp@alien8.de> <20130424105610.GA15815@gmail.com> <5177BF67.2040308@intel.com> <20130425065529.GD7806@gmail.com>
In-Reply-To: <20130425065529.GD7806@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/04/13 07:55, Ingo Molnar wrote:
> It's a basic cleanliness and robustness issue: we generally avoid type 
> casts in the kernel, because type casts override compile-time type checks 
> and are easy to get wrong. They are also ugly.
> 
> So in generaly we try to use the right type for the data structure, which 
> matches its usage (and standardize functions/methods around that type) - 
> then no cast is needed.

Yeah, I'm not advocating using casts, I was just saying "Oh, x86-64
avoids requiring the caller of efi_call_phys* to perform the cast by
doing it in the definition of efi_call*. That's why this is only
affecting 32-bit."

Cleaning this up would be nice. I think at this point, I'll apply
Borislav's patch, and fix all this casting after v3.9 is released, since
instead of just changing query_variable_info, we might as well change
everything in efi_runtime_service_t so that it's consistent.
