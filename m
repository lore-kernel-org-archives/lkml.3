Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab3D2Pmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 11:42:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41853 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757386Ab3D2Pmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 11:42:43 -0400
Message-ID: <517E94E6.6040201@zytor.com>
Date: Mon, 29 Apr 2013 08:42:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 3/3] x86, FPU: Do not use static_cpu_has before alternatives
References: <1367244262-29511-1-git-send-email-bp@alien8.de> <1367244262-29511-4-git-send-email-bp@alien8.de>
In-Reply-To: <1367244262-29511-4-git-send-email-bp@alien8.de>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2013 07:04 AM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> The call stack below shows how this happens: basically eager_fpu_init()
> calls __thread_fpu_begin(current) which then does if (!use_eager_fpu()),
> which, in turn, uses static_cpu_has.
> 
> And we're executing before alternatives so static_cpu_has doesn't work
> there yet.
> 
> However, I don't want to cause the penalty of not using static_cpu_has
> to all callers of use_eager_fpu() which are a bunch spread around the
> tree so let's add the change only to __thread_fpu_begin() - it is still
> on the context switch path but we can at least keep the static_cpu_has
> call in the rest of the use_eager_fpu() callsites.
> 

I *was* considering adding static_cpu_has_safe() at some point which
would have a three-state jump, with the default (pre-alternatives) jump
pointing to dynamic detection code.

This might be useful here, on the other hand, perhaps it is acceptable
for use_eager_fpu() to be initially false?

	-hpa


