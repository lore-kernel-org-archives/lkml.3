Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbaFKVxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 17:53:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53095 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaFKVxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 17:53:09 -0400
Message-ID: <5398CFA4.60202@zytor.com>
Date: Wed, 11 Jun 2014 14:52:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-arch@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC 00/10] tools: Revamp the unaligned endian access functions
References: <1402441994-16780-1-git-send-email-hpa@zytor.com> <20140611192111.GB16069@ravnborg.org>
In-Reply-To: <20140611192111.GB16069@ravnborg.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2014 12:21 PM, Sam Ravnborg wrote:
> On Tue, Jun 10, 2014 at 04:13:04PM -0700, H. Peter Anvin wrote:
>> After a recent problem in the x86 tree, which seems to be the heaviest
>> but not the only user of these functions, I went through and did a
>> patchset to revamp the *user space* unaligned/endian accessor
>> functions.  As much as I think it is downright pathetic that this
>> functionality still isn't part of the C standard, that is life and we
>> have to deal with it.  Furthermore, although glibc has a pretty nice
>> set of functions for byte swapping in <endian.h>, taken from FreeBSD I
>> believe, some older systems don't support them.
>>
>> This variant tries to fill in all the holes.  It assumes that
>> <endian.h> define the functions as macros if they exist, as I don't
>> know any other way of probing for them without reaching for autoconf,
>> but that should be valid enough of an assumption in this case.
>>
>> The hope is that this should give reasonable, if not optimal, code
>> generation on most processors, and give a hook where arch maintainers
>> can add their own changes if needed.
> 
> This looks like a very complex solution to a simple problem.
> We want a shared implementation of the *user space*
> unaligned/endian accessor functions.
> But do we really want *fast* versions for our use?
> 
> This is not a new libc that should generate optimal code,
> but only something were we want to provide e working
> implmentation for use in our user-space tools.
> 
> A much simpler approach without any fallback to arch specific
> version etc. is everything we need.

It doesn't matter so much for things that are just done for the kernel
compile, no, but there are some tools that are built to be used as
standalone things, and it could matter there.

Please note that the code currently doesn't have any arch-specific bits
at all... the code is somewhat complex in part because it is very
generic and handles several levels of fallback.  It *can* get
arch-specific overrides if it matters, but the intent is that it
shouldn't be necessary in the vast majority of the cases.

	-hpa

