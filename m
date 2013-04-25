Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab3DYWCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 18:02:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60724 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932228Ab3DYWCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 18:02:16 -0400
Message-ID: <5179A7CE.2050605@zytor.com>
Date: Thu, 25 Apr 2013 15:01:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
Subject: Re: [PATCH v3 0/6] kernel ASLR
References: <1366926860-26776-1-git-send-email-keescook@chromium.org>
In-Reply-To: <1366926860-26776-1-git-send-email-keescook@chromium.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2013 02:54 PM, Kees Cook wrote:
> This continues to build on the tip/kaslr patches for KASLR. This series
> converts the logic to C, and moves both relocation and address selection
> into the decompress_kernel path. Several areas were refactored to allow
> for some code reuse (e.g. CPU flags, kernel command line).
> 
> This does not yet attempt to rework the page tables to handle an arbitrary
> physical memory location on x86_64. I would love some suggestions on
> how to do this. :)
> 

We *should* already support arbitrary physical memory locations at least
in the kernel proper (the decompressor might need some work.)

We may want to do in the decompressor what we already do in the kernel,
and set up a #PF handler which creates page tables on demand.  That way
you can simply treat the entire memory space as a single linear space.

	-hpa

