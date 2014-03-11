Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbaCKATt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 20:19:49 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:34536 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbaCKATs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 20:19:48 -0400
MIME-Version: 1.0
In-Reply-To: <531E5531.20409@linux.intel.com>
References: <775280bd6cab6345a1d340e7038d2011763bf81b.1394492341.git.luto@amacapital.net>
 <531E5531.20409@linux.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 10 Mar 2014 17:19:27 -0700
Message-ID: <CALCETrX1RBVYAKyN_GdvF8w3S=A5wZ_XaMqR_MjdLim7RMR8NQ@mail.gmail.com>
Subject: Re: [PATCH] x86: Remove compat vdso support
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, X86 ML <x86@kernel.org>,
        Stefani Seibold <stefani@seibold.net>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 5:13 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> On 03/10/2014 05:12 PM, Andy Lutomirski wrote:
>> The compat vDSO is a complicated hack that's needed to maintain
>> compatibility with a small range of never-released glibc versions.
>>
>> This removes it and replaces it with a much simpler hack: a config
>> option to disable the 32-bit vDSO by default.
>>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>
> Can we verify this works correctly on the affected distributions?

It works correctly on Fedora 20 32-bit and 64-bit.

I don't actually know what the affected distribution is, which makes
it hard.  But it would be rather surprising if it didn't, since I
suspect people would have noticed and complained very quickly and
loudly if there was ever a glibc version that didn't work without a
vDSO.

TBH, I'd be more surprised if this breaks anything than I'd be if
current kernels are already broken.

--Andy
